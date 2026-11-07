# Yerel istemci ve başlatıcı çalışması

**Güncel profil ve teşhis: [GIRIS_DUZELTMESI.md](GIRIS_DUZELTMESI.md).** Aşağıdaki notlar önceki Gamesoft EXE denemesine aittir. Etkin kopya artık kullanıcının değiştirilmemiş yama EXE'sini, uyarlanmış altı tabloyu ve açık UI kaynaklarını kullanıyor. Sunucuda buna uygun standart paket profili derlendi. Şifreli ağ testi geçti; grafik giriş sonrası liste henüz doğrulanmadı.

Yama EXE'sinin gerçek protokolü 2083 olarak doğrulandı; 2239 motor için giriş paketi uyumluluk profili etkin. Grup/kanal adı `KnightLocal2239|Local-1`. Doğrudan ve aktarıcı üzerinden şifreli oyun girişi ile TCP parçalı paket testleri geçti; grafik ülke/karakter/harita doğrulaması bekleniyor.

Mevcut Gamesoft istemcisi ayrı kopyada, yazılan 32 bit başlatıcıyla **giriş ekranına kadar açıldı**. Oyun içi giriş henüz doğrulanmadı. Kullanıcının ilk denemesinde form kapanıp bekleme görüldü; etkin yerel oturumda bağlantı inceleniyor.

## Çalışma dosyaları

- `Gamesoft_Yerel`: asıl istemcinin 10.626 dosya / 2.554.202.549 baytlık ayrı kopyası. Orijinal klasör korunuyor.
- `Yerel_Launcher/Launcher.cpp`: yazılan Win32 başlatıcının kaynağı.
- `Yerel_Launcher/Launcher.vcxproj`: v142 / Windows SDK 10.0.19041.0 / Release Win32 projesi.
- `Yerel_Launcher/bin/Launcher.exe`: derlenen 32 bit başlatıcı. İstemciye kendi süreç numarasını verir ve oyun açıkken açık kalır.
- `Baslat-Yerel.ps1`: yerel oyun/giriş sunucusu ve kayıt aktarıcısını hazırlar; ardından başlatıcıyı açar. `-VerifyOnly` yalnızca durum raporlar, `-NoClient` oyun penceresini açmaz.
- `Durdur-Yerel.ps1`: çevrimiçi karakter yoksa yalnızca bu kurulumun deneme süreçlerini durdurur; SQL hizmetini durdurmaz.
- `launcher-yerel.py`: ilk süreç-numarası test aracı; normal kullanımda süre sınırı yoktur.
- `local-test-account.private.json`: yalnızca yerel deneme hesabı. İnternete açılmadan önce kaldırılmalı veya yeniden oluşturulmalı.
- `connection-metadata.jsonl`: yerel aktarıcıdan geçen paketlerin yönü, boyutu ve ilk protokol baytı. Hesap/şifre gövdeleri kaydedilmez.
- `client-tcp-endpoints.jsonl`: yalnızca denenen istemci sürecinin adres/port durumları.

Eski istemcinin yol/çalışma klasörü sorununu ayırmak için `C:\Users\murat\KnightOnlineLab\ClientGamesoft` adlı bir NTFS junction oluşturuldu. Bu bağlantı yalnızca yukarıdaki çalışma kopyasına gider.

## Doğrulananlar

- Doğru çalışma klasörüyle orijinal EXE, ilk görülen “file is corrupted” aşamasını geçti.
- Komut satırı olmadan `NullParam`, geçersiz süreç numarasıyla `ProcID` bildirimi görüldü. Canlı ebeveyn süreç numarasıyla bu aşama geçildi.
- Yazılan 32 bit başlatıcıyla oyunun grafik giriş ekranı gözlemlendi. EXE, Gamesoft modülü, koruma kontrolleri ve Windows güvenlik ayarları değiştirilmedi.
- Kaynak sunucunun sürüm yanıtı ve sunucu listesi ayrı ağ testinden geçti.
- Yerel hesabın doğru/yanlış şifre akışı gerçek LogInServer üzerinden geçti; sonuç `06_Dokumantasyon/Derleme/local-account-network-test.json` dosyasında.

## Henüz doğrulanmayanlar

- Grafik istemcinin şifreli giriş akışı ve 2239 oyun protokolüyle tam uyumu.
- Sunucu listesi, ülke/karakter seçimi ve haritaya giriş.
- Görev kabulü, maliyetler, seçmeli ödüller ve yeni etkinliklerin oyun içi davranışı.

Özgün launcher “Unknown data stream” verdi. İçerik sürümünü ve sürüm paketi başlığını değiştiren geçici aktarıcı denemeleri bunu çözmedi; bunlar etkin çözüm değildir. Yeni başlatıcı özgün oyun EXE’sini normal Windows süreç oluşturma yoluyla açar; kod ekleme veya bellek yaması yapmaz.

GitHub'daki `CyberACS/Knight-Online-Client-Source-Fire-Drake` deposu `49b5b9b6c81f858a8307a60eeaaaa496fcfa43f4` sürümünde incelendi. İstemci klasöründe yalnızca bir `Read me.txt` bulundu; tam 24xx istemci kaynağı olarak kullanılmadı. OpenKO'nun ana dalı 1298/9 hedefini belirttiği için 2239 yerine hazır çözüm sayılmadı.
