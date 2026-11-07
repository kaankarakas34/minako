#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <string>
#include <cwchar>
#include <cstdio>
#include <cstdint>
#include <vector>
#include <tlhelp32.h>
#include <bcrypt.h>

static HWND statusLabel;
static PROCESS_INFORMATION clientProcess = {};
static std::wstring clientDirectory;
static std::wstring logPath;

static bool MatchesSha256(const std::wstring& path, const char* expected)
{
    HANDLE file = CreateFileW(path.c_str(), GENERIC_READ, FILE_SHARE_READ, nullptr,
        OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, nullptr);
    if (file == INVALID_HANDLE_VALUE) return false;
    BCRYPT_ALG_HANDLE algorithm = nullptr;
    BCRYPT_HASH_HANDLE hash = nullptr;
    DWORD objectSize = 0, returned = 0;
    bool ok = BCryptOpenAlgorithmProvider(&algorithm, BCRYPT_SHA256_ALGORITHM, nullptr, 0) >= 0;
    if (ok) ok = BCryptGetProperty(algorithm, BCRYPT_OBJECT_LENGTH,
        reinterpret_cast<PUCHAR>(&objectSize), sizeof(objectSize), &returned, 0) >= 0;
    std::vector<UCHAR> object(objectSize);
    if (ok) ok = BCryptCreateHash(algorithm, &hash, object.data(), objectSize, nullptr, 0, 0) >= 0;
    UCHAR buffer[65536], digest[32]; DWORD count = 0;
    while (ok)
    {
        if (!ReadFile(file, buffer, sizeof(buffer), &count, nullptr)) { ok = false; break; }
        if (!count) break;
        ok = BCryptHashData(hash, buffer, count, 0) >= 0;
    }
    if (ok) ok = BCryptFinishHash(hash, digest, sizeof(digest), 0) >= 0;
    char hex[65] = {};
    if (ok) for (unsigned i = 0; i < 32; ++i) sprintf_s(hex + 2 * i, 3, "%02X", digest[i]);
    if (hash) BCryptDestroyHash(hash);
    if (algorithm) BCryptCloseAlgorithmProvider(algorithm, 0);
    CloseHandle(file);
    return ok && strcmp(hex, expected) == 0;
}

static void WriteResult(const wchar_t* message)
{
    SetWindowTextW(statusLabel, message);
    FILE* file = nullptr;
    if (_wfopen_s(&file, logPath.c_str(), L"a, ccs=UTF-8") == 0 && file)
    {
        SYSTEMTIME time; GetLocalTime(&time);
        fwprintf(file, L"%04u-%02u-%02u %02u:%02u:%02u %ls\n", time.wYear,
            time.wMonth, time.wDay, time.wHour, time.wMinute, time.wSecond, message);
        fclose(file);
    }
}

static void StartGame(HWND window)
{
    if (clientProcess.hProcess && WaitForSingleObject(clientProcess.hProcess, 0) == WAIT_TIMEOUT)
    {
        WriteResult(L"Oyun zaten acik. Yukleme sonucu bekleniyor.");
        return;
    }
    if (clientProcess.hProcess) CloseHandle(clientProcess.hProcess);
    if (clientProcess.hThread) CloseHandle(clientProcess.hThread);
    clientProcess = {};
    std::wstring exe = clientDirectory + L"\\KnightOnLine.exe";
    if (GetFileAttributesW(exe.c_str()) == INVALID_FILE_ATTRIBUTES)
    {
        DWORD error = GetLastError();
        if (error == ERROR_VIRUS_INFECTED || error == ERROR_VIRUS_DELETED)
            WriteResult(L"Windows guvenligi oyun EXE dosyasina erisimi engelliyor. Istemci baslatilmadi.");
        else
            WriteResult(L"KnightOnLine.exe istemci klasorunde yok. Eksik veya karantinaya alinmis olabilir. Sunucunun acik olmasi oyunun hazir oldugu anlamina gelmez.");
        return;
    }
    wchar_t configuredIp[64] = {};
    GetPrivateProfileStringW(L"Server", L"IP0", L"", configuredIp, 64,
        (clientDirectory + L"\\Server.ini").c_str());
    if (wcscmp(configuredIp, L"127.0.0.2") != 0
        || !MatchesSha256(exe, "683BEFABAE1F217296BEFDA2A824B26BD2FFF77BFF67AA72A66C219C040F12FE"))
    {
        WriteResult(L"Yerel profil bu istemciyle eslesmiyor. Bilinmeyen dosyalara uyarlama yapilmadi.");
        return;
    }
    // The supplied patch client expects the live launcher's process ID.
    // It is launched unmodified; no process memory is edited.
    // Keep the local cinematic scene table empty on every launch, including
    // after an asset refresh. The disabled table retains the native schema.
    const std::wstring disabledScenes = logPath.substr(0, logPath.find_last_of(L"\\/"))
        + L"\\movie_scene.disabled.tbl";
    const std::wstring activeScenes = clientDirectory + L"\\Data\\movie_scene.tbl";
    const char* disabledSceneHash = "03996BB53A545AFB88341C2B4C01AAA1CB6913FD891971713A36AA5AFB950968";
    if (!MatchesSha256(disabledScenes, disabledSceneHash)
        || !CopyFileW(disabledScenes.c_str(), activeScenes.c_str(), FALSE)
        || !MatchesSha256(activeScenes, disabledSceneHash))
    {
        WriteResult(L"Hikaye sinematigini kapatma profili uygulanamadi. Istemci baslatilmadi.");
        return;
    }
    // Reapply before each launch: the running client may save an older setting on exit.
    if (!WritePrivateProfileStringW(L"Movie", L"MovieVisible", L"0",
        (clientDirectory + L"\\Option.ini").c_str()))
    {
        WriteResult(L"Acilis sinematigi ayari kaydedilemedi. Option.ini dosyasini kontrol edin.");
        return;
    }
    std::wstring command = L"\"" + exe + L"\" " + std::to_wstring(GetCurrentProcessId());
    STARTUPINFOW start = {}; start.cb = sizeof(start);
    if (!CreateProcessW(exe.c_str(), &command[0], nullptr, nullptr, FALSE, 0,
        nullptr, clientDirectory.c_str(), &start, &clientProcess))
    {
        wchar_t message[160];
        DWORD error = GetLastError();
        if (error == ERROR_VIRUS_INFECTED || error == ERROR_VIRUS_DELETED)
            swprintf_s(message, L"Windows guvenligi oyun EXE dosyasini engelledi (hata %lu). Istemci baslatilmadi.", error);
        else
            swprintf_s(message, L"Istemci baslatilamadi. Windows hata kodu: %lu", error);
        WriteResult(message);
        return;
    }
    wchar_t message[200];
    swprintf_s(message, L"Istemci baslatildi (PID %lu). Bu baslatici oyun acikken acik kalir.", clientProcess.dwProcessId);
    WriteResult(message);
    SetTimer(window, 1, 500, nullptr);
}

static LRESULT CALLBACK WindowProc(HWND window, UINT message, WPARAM wParam, LPARAM lParam)
{
    switch (message)
    {
    case WM_CREATE:
    {
        HFONT font = static_cast<HFONT>(GetStockObject(DEFAULT_GUI_FONT));
        HWND title = CreateWindowW(L"STATIC", L"Knight Local - istemci uyumluluk denemesi",
            WS_CHILD | WS_VISIBLE, 22, 20, 570, 28, window, nullptr, nullptr, nullptr);
        HWND description = CreateWindowW(L"STATIC",
            L"Ozgün oyun dosyalarinin ayri kopyasini baslatir. Yerel sunucu testi icindir.\r\nOyuna giris ve gorevlerin calismasi ayrica dogrulanmalidir.",
            WS_CHILD | WS_VISIBLE, 22, 58, 570, 45, window, nullptr, nullptr, nullptr);
        statusLabel = CreateWindowW(L"STATIC", L"Hazir. Oyunu baslatabilirsiniz.",
            WS_CHILD | WS_VISIBLE | SS_LEFT, 22, 125, 570, 55, window, nullptr, nullptr, nullptr);
        HWND button = CreateWindowW(L"BUTTON", L"Oyunu baslat", WS_CHILD | WS_VISIBLE | WS_TABSTOP | BS_DEFPUSHBUTTON,
            22, 198, 170, 38, window, reinterpret_cast<HMENU>(100), nullptr, nullptr);
        HWND close = CreateWindowW(L"BUTTON", L"Kapat", WS_CHILD | WS_VISIBLE | WS_TABSTOP,
            210, 198, 120, 38, window, reinterpret_cast<HMENU>(101), nullptr, nullptr);
        for (HWND control : { title, description, statusLabel, button, close })
            SendMessageW(control, WM_SETFONT, reinterpret_cast<WPARAM>(font), TRUE);
        if (wcsstr(GetCommandLineW(), L"--start")) PostMessageW(window, WM_COMMAND, 100, 0);
        return 0;
    }
    case WM_COMMAND:
        if (LOWORD(wParam) == 100) StartGame(window);
        if (LOWORD(wParam) == 101) PostMessageW(window, WM_CLOSE, 0, 0);
        return 0;
    case WM_TIMER:
        if (clientProcess.hProcess && WaitForSingleObject(clientProcess.hProcess, 0) == WAIT_OBJECT_0)
        {
            DWORD code = 0; GetExitCodeProcess(clientProcess.hProcess, &code);
            wchar_t text[200]; swprintf_s(text, L"Istemci kapandi. Cikis kodu: 0x%08lX. Sonuc yerel gunluge yazildi.", code);
            WriteResult(text); KillTimer(window, 1);
        }
        return 0;
    case WM_CLOSE:
        if (clientProcess.hProcess && WaitForSingleObject(clientProcess.hProcess, 0) == WAIT_TIMEOUT)
        {
            WriteResult(L"Oyun acikken baslatici acik kalmali. Once oyunu kapatin.");
            return 0;
        }
        DestroyWindow(window); return 0;
    case WM_DESTROY:
        if (clientProcess.hProcess) CloseHandle(clientProcess.hProcess);
        if (clientProcess.hThread) CloseHandle(clientProcess.hThread);
        PostQuitMessage(0); return 0;
    }
    return DefWindowProcW(window, message, wParam, lParam);
}

int WINAPI wWinMain(HINSTANCE instance, HINSTANCE, PWSTR, int show)
{
    wchar_t exePath[MAX_PATH], profile[MAX_PATH], configured[MAX_PATH];
    GetModuleFileNameW(nullptr, exePath, MAX_PATH);
    std::wstring directory(exePath); directory.resize(directory.find_last_of(L"\\"));
    std::wstring ini = directory + L"\\launcher.ini";
    GetEnvironmentVariableW(L"USERPROFILE", profile, MAX_PATH);
    std::wstring fallback = std::wstring(profile) + L"\\KnightOnlineLab\\ClientGamesoft";
    GetPrivateProfileStringW(L"Client", L"ClientDirectory", fallback.c_str(), configured, MAX_PATH, ini.c_str());
    clientDirectory = configured; logPath = directory + L"\\launcher-result.log";
    WNDCLASSW cls = {}; cls.lpfnWndProc = WindowProc; cls.hInstance = instance;
    cls.lpszClassName = L"KnightLocalLauncher"; cls.hCursor = LoadCursorW(nullptr, IDC_ARROW);
    cls.hbrBackground = reinterpret_cast<HBRUSH>(COLOR_WINDOW + 1);
    if (!RegisterClassW(&cls)) return 1;
    HWND window = CreateWindowW(cls.lpszClassName, L"Knight Local Launcher",
        WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX, CW_USEDEFAULT, CW_USEDEFAULT,
        640, 300, nullptr, nullptr, instance, nullptr);
    if (!window) return 2;
    ShowWindow(window, show); UpdateWindow(window);
    MSG message;
    while (GetMessageW(&message, nullptr, 0, 0) > 0) { TranslateMessage(&message); DispatchMessageW(&message); }
    return static_cast<int>(message.wParam);
}
