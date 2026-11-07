#include "stdafx.h"
#include "../shared/signal_handler.h"

LoginServer * g_pMain;
static Condition s_hEvent;
bool g_bRunning = true;

BOOL WINAPI _ConsoleHandler(DWORD dwCtrlType);

int main(int argc, char ** argv)
{
	if (argc == 2 && strcmp(argv[1], "--hardware-id") == 0)
	{
		HardwareInformation hardware;
		printf("%lld\n", hardware.GetHardwareID());
		return 0;
	}
	SetConsoleTitle("LO Server - v2500");

	// Override the console handler
	SetConsoleCtrlHandler(_ConsoleHandler, TRUE);

	CBugTrap* sBugTrap = new CBugTrap();
	if (!sBugTrap->IsBugTrapLoaded())
	{
#ifndef _WIN64
		MessageBox(0, "You Need BugTrap.dll", "BugTrap.dll Error", MB_SYSTEMMODAL | MB_OK | MB_ICONERROR);
#else
		MessageBox(0, "You Need BugTrap.dll", "BugTrap-x64.dll Error", MB_SYSTEMMODAL | MB_OK | MB_ICONERROR);
#endif
		return 0;
	}

	HookSignals(&s_hEvent);

	g_pMain = new LoginServer();
	g_pMain->s_hEvent = &s_hEvent;

	// Startup server
	bool started = g_pMain->Startup();
	if (started){
		printf("\nServer started up successfully!\n\n");
		fflush(stdout);
		// Wait until console's signaled as closing
		s_hEvent.Wait();
	}
	else { printf("Startup failed. Review the startup and SQL logs.\n"); }

	printf("Server shutting down, please wait...\n");
	// This seems redundant, but it's not. 
	// We still have the destructor for the dialog instance, which allows time for threads to properly cleanup.
	g_bRunning = false;

	delete g_pMain;

	CleanupTimeThread();
	UnhookSignals();

	return started ? EXIT_SUCCESS : EXIT_FAILURE;
}

BOOL WINAPI _ConsoleHandler(DWORD dwCtrlType)
{
	s_hEvent.BeginSynchronized();
	s_hEvent.Signal();
	s_hEvent.EndSynchronized();
	sleep(10000); // Win7 onwards allows 10 seconds before it'll forcibly terminate
	return TRUE;
}
