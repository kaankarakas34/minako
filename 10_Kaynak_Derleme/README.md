# Kaynak koddan kurulum — aktif çalışma

Hedef: sağlanan TemuKO C++ kaynağını Windows üzerinde derlemek ve yeni görev/etkinlik çağrılarını bu sunucuya uyarlamak.

- Kaynak kopyası: `TemuKO/ServerFiles/SourceFiles`.
- Derleme: Visual Studio 2019 Build Tools, MSVC v142, Windows SDK 10.0.19041.0, Release x64.
- Çıktılar: `TemuKO/ServerFiles/bin/x64/Release/GameServer.exe` ve `LogInServer.exe`.
- Asıl kaynak ve hazır sunucu dosyaları korunuyor. `09_Uyarlama` içindeki eski 2083 uyarlaması etkin hedef değildir.
- Lua'ya eklenen Rebirth çağrısı, mevcut C++ uygulamasına gider; seviye, NPC ve ücret kontrollerini kullanır.
- `JuraidTempleEventJoin` adı, mevcut `JoinEvent` yoluna bağlanır; etkinlik/kayıt zamanı kontrollerini kullanır.
- Giriş sunucusuna `SETTINGS/LISTEN_IP` eklendi; varsayılan `127.0.0.1`.
- Her iki EXE için `--hardware-id`, ağ/SQL başlatmadan yerel kurulum kimliğini verir.
- Hata raporlama ayarlarından eski geliştirici adresleri ve ekran görüntüsü kaldırıldı.

Derleme başarılı olması, oyuna girişin veya etkinliklerin çalıştığının kanıtı değildir. SQL şeması, görev dosyaları, haritalar ve istemci protokolü ayrıca sınanmalıdır. Henüz canlı yayın yapılmadı.

Raporlar: `06_Dokumantasyon/Derleme`.
