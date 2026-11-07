# 6 Kasım 2026 açılış incelemesi

## Güncel durum — kullanıcının açık dosya izni talebinden sonra

6 Kasım 21:36'da kullanıcı isteğiyle yalnızca etkin `Gamesoft_Yerel\KnightOnLine.exe` tam dosya yolu için Defender dosya istisnası eklendi. Windows yönetici onayından sonra Microsoft `MpCmdRun -Restore -FilePath` ile yalnızca bu dosya geri yüklendi. Dosya SHA256 özeti önceki çalışan EXE'nin `683BEFABAE1F217296BEFDA2A824B26BD2FFF77BFF67AA72A66C219C040F12FE` değeriyle eşleşti. Bu eşleşme güvenli yazılım doğrulaması veya yanlış tespit kararı değildir. Defender bütünüyle kapatılmadı; klasör, süreç veya tehdit ailesi istisnası eklenmedi.

Oyun standart kullanıcı yetkisiyle normal başlatıcıdan açıldı. Giriş formu grafik olarak görüldü; yeniden hesap girişi yapılmadı. `file-permission-result.json` ve `restore-game-file.log` sonucu kaydeder. `Oyuna-Dosya-Izni.ps1 -Action Undo` yönetici yetkisiyle çalıştırılırsa bu tek dosya istisnasını kaldırır. Aşağıdaki bulgular, izin verilmeden önceki inceleme kaydıdır.

## İzin öncesi inceleme

Grafik istemci henüz çalışır durumda değildir. Etkin `Gamesoft_Yerel/KnightOnLine.exe` yoktur. Windows Defender Operational günlüğündeki 1116/1117 olayları, dosyanın 6 Kasım 2026 saat 14:31'de `Behavior:Win32/DefenseEvasion.A!ml` tespitiyle karantinaya alındığını gösterir. Saatler İstanbul saatidir. Bunun yanlış tespit olduğu doğrulanmadı. Yedek EXE'ye normal dosya erişimi de Windows tarafından engellendi. Engellenen dosya geri yüklenmedi, başka adla çalıştırılmadı ve güvenlik ayarı değiştirilmedi.

Bu bulgu, istemcinin açılmamasının Antigravity kaynak değişikliklerinden kaynaklandığı anlamına gelmez. Başlatıcı 15:40'tan itibaren eksik EXE'yi yanlış biçimde `launcher.ini` yolu hatası olarak bildiriyordu. Junction doğru hedefe yöneliyor; olmayan bir INI oluşturmak sorunu çözmez.

## Yapılan onarım ve kontroller

- Duran yerel GameServer ve bağlantı aktarıcısı, mevcut başlatma betiğiyle yeniden başlatıldı. LogInServer zaten çalışıyordu. Mevcut Antigravity sunucu derlemesi korundu.
- Başlatıcı, eksik EXE ile Windows'un güvenlik nedeniyle erişimi/çalıştırmayı engellemesi durumlarını anlaşılır mesajlarla bildiriyor. Release Win32 derlemesi geçti.
- Sağlık raporu artık `ClientExecutablePresent` ve `ClientIssue` alanlarını içeriyor. Üç sunucu hizmetinin hazır olması, istemcinin de hazır olması olarak gösterilmiyor. Çalışan istemci denetimi hem gerçek klasörü hem junction yolunu tanıyor.
- Windows PowerShell 5.1 ile `-VerifyOnly` kontrolü geçti: üç yerel hizmet hazır, istemci EXE'si eksik.
- Şifreli girişte doğru parola kabulü, yanlış parolanın reddi ve `KnightLocal2239|Local-1` sunucu listesi testi geçti.
- Gerçek GameServer üzerinden `cabbar` listelendi ve karakter yükleme kabul edildi. Veritabanındaki güncel sınıf 111, seviye 23, bölge 21 ile uyumluydu. Testin eski sınıf-104 varsayımı düzeltildi; karakter kaydı değiştirilmedi. Yeni `--expected-class` seçeneği, veritabanı görüntüsüyle açık karşılaştırma yapıyor.
- Giriş ve oyun sunucusunda parçalı TCP paketi testleri geçti.
- Mevcut inventory, Options ve target UIF dosyaları ayrıştırılabildi. Inventory kilit paneli yok; iki ülkenin uyumlu Options ve target kaynak yolları korunuyor. Grafik davranışı yeniden test edilmedi.

## Kalan engel

İstemci için güvenilir kaynaktan, sunucu protokolüyle uyumluluğu ayrıca doğrulanmış temiz bir EXE veya mevcut tespit için doğrulanmış bir yanlış tespit sonucu gerekir. Bugünkü onarım, oyuna grafik girişin tamamlandığı anlamına gelmez. Karantinadaki dosyayı farklı konuma kopyalamak veya güvenlik denetimini kapatmak çözüm olarak uygulanmadı.

Önceki başlatıcı, kaynak ve başlatma betiği `Yedek` altında. Kanıtlar `repair-status.json`, ağ testleri ve `msbuild-launcher.log` içindedir. Şifre kaydedilmedi; oyun internete açılmadı.
