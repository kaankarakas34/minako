# Yerel 2239 çalışma durumu

Sunucu kaynağı ayrı kopyada Release x64 olarak derlendi. GameServer ve LogInServer, yerel SQL bağlantısı ve yalnızca loopback portlarıyla başlatma testini geçti. Testler, gerçek grafik istemciyle oyuna girildiği anlamına gelmez.

## Tamamlanan somut işler

- MSVC v142 ve kurulu Windows SDK 10.0.19041.0 ile dört proje derleniyor. Çıktılar `TemuKO/ServerFiles/bin/x64/Release` altında.
- Rebirth sisteminin mevcut C++ uygulaması Lua'ya bağlandı. `JuraidTempleEventJoin` mevcut kayıt yoluna, `UpdateEvent` mevcut helper kaydetme yoluna bağlandı.
- Derlenmiş PE64 içindeki 140 Lua komutu, düzenlenen kaynak tablosuyla isim/sıra bakımından eşleşti.
- Yerel makine, kaynağın kurulum başına donanım izin listesine eklendi. Denetim kaldırılmadı. Makineye özel başlık yayımlanmamalı.
- Giriş sunucusuna açık dinleme adresi ayarı eklendi; varsayılanı `127.0.0.1`.
- Eski hata raporlama adresleri ve ekran görüntüsü seçeneği kaldırıldı.
- Boş bot tablosunun sunucu başlangıcını hatalı biçimde durdurması düzeltildi.
- Yerel yama istemcisi için `shared/LocalClientProfile.h` ile standart paket anahtarı seçildi; GameServer ve LogInServer yeniden derlendi. SQL kimlik doğrulaması, CRC ve paket sırası korunuyor. Özgün kaynak değişmedi.

## Veritabanı

`KNIGHT_TEMU_2239`, yayımlanan TemuKO referansının SQL Server için ayrı laboratuvar dönüşümüdür. 252 tablo ve 975.788 oyun/ayar kaydı aktarıldı; yayımlanmış oyuncu hesapları aktarılmadı. Kaynaktan çağrılan 142 T-SQL prosedürü başlangıçta oluşturulabildi. Özgün TEST/ADAPT veritabanları değiştirilmedi.

Yayımlanmış PostgreSQL verisindeki negatif değerler, C++'ın açıkça unsigned okuduğu döngüsüz alanlarda aynı bit değerini koruyarak düzeltildi: 47 sütunda 585.308 hücre. İlk değişiklik kaydı `06_Dokumantasyon/Derleme/temu-unsigned-initial-migration.json` dosyasındadır. Döngüyle okunan kayıt kümeleri, metin taramasının tip konumlarını kaydırmaması için bu otomatik düzeltmeden çıkarıldı.

Eksik harita adları için 10 benzersiz dosya, Git blob özeti doğrulanarak eklendi. Dosyanın açılması, istemci geometrisi ve NPC yerleşimlerinin oyun içinde doğru olduğunun kanıtı değildir.

`KNIGHT_AKGAME_REF` yalnızca karşılaştırma içindir. Daha yeni dalda birçok tablo `2369` ekiyle tutulduğundan doğrudan etkin veritabanı yapılmadı.

## Görevler

757 farklı veritabanı dosya başvurusu incelendi. Referans tabanın 224 dosyasında API/sözdizimi denetimi geçti; 231 dosyada olay kapsamı kısmi, 1 dosyada inceleme gerektiren çağrı var. Bilinen SQL alanları ve tarifleri eşleşen 5 dosya eklendi. 296 başvuru için doğrulanmış tam içerik bulunamadı. Yalnızca arama/dağıtım yapan taslaklar tamamlanmış görev diye eklenmedi.

Bu sayılar statik denetimdir; ödül ve envanter akışları ayrıca sınanmalıdır. `09_Uyarlama` içindeki eski 2083 denemesi etkin kurulum değildir.

## Gerçek bağlantı testleri

- Kaynak motorun sürümü 2239. İlk sürüm testi 2239 yanıtını doğruladı; mevcut yama EXE'sinin gerçek 2083 protokolü belirlendiği için etkin GameServer artık açıkça seçilen 2083 giriş uyumluluk profiliyle çalışıyor. Tüm oyun paketlerinin uyumu henüz doğrulanmadı.
- LogInServer `127.0.0.1:15100` üzerinden sürüm ve sunucu listesi yanıtını verdi.
- Yerel deneme hesabı doğru şifreyle kabul edildi, yanlış şifre reddedildi. SQL tarafında engelli hesap ve zaten çevrimiçi hesap denemeleri de geçti.
- Şifreli anahtar alışverişi, doğru/yanlış şifre ve sunucu listesi ağ testi geçti (`11_Istemci_Uyumluluk/encrypted-login-test.json`).
- Altı tablo ve UI arşivi ayrı kopyada uyarlandı. Yama EXE'si değiştirilmeden grafik giriş ekranına ulaştı. Yeni profilde kullanıcının giriş denemesi bekleniyor; grafik sunucu listesi henüz doğrulanmadı.
- Gerçek istemcide parola doğrulaması geçti; kullanıcı sunucu seçim ekranını gördü. Grup adı biçimi `KnightLocal2239|Local-1` olarak düzeltildi. Oyun bağlantısında sürüm/anahtar paketi uyarlandı; şifreli doğru/yanlış parola ve yeni hesap için ülke seçimi yanıtı testleri geçti.
- TCP okuyucusunun ayrı gelen paket sonunu beklememesi bağlantıyı kapatıyordu. Hata testle yeniden üretildi, düzeltildi; her iki sunucuda parçalı başlık/yük/paket sonu testi geçti.
- GAME_LOGIN_V2 ve NATION_SELECT, boş yeni hesabın normal ülke seçimi akışı için düzeltildi. Parola/yetki/bakım/kapasite kontrolleri korundu; seçilmiş ülkenin değiştirilmesi reddediliyor. Ülke ve karakter seçim ekranları hâlen gerçek istemcide doğrulanmalıdır.

Aktif oturumda istemci `127.0.0.2` yerel kayıt aktarıcısına, aktarıcı `127.0.0.1` sunucularına gider. SQL bağlantısı mevcut kullanıcı için Windows doğrulamalı 64 bit `KnightTemu2239_Lab` DSN'idir. Güvenlik duvarında dışa açılan port yoktur; yayın yapılmadı.

5 Kasım güncellemesi: gerçek istemcide Karus seçildi ve `cabbar` (ırk 4, sınıf 104, seviye 1) oluşturuldu. Oluşturma yolunun eksik fonksiyon/prosedürleri ve posta/başarı şablonları uyarlandı. PostgreSQL kaynağında metin olarak kalmış başlangıç envanterleri ve başarı ikili dizileri çözüldü; birebir bozuk başlangıç şablonuyla eşleşen cabbar kayıtları yedeklenerek onarıldı. Sonraki grafik gözlemde karakterin tüm gövdesi ve eşyaları göründü.

Start Game ile GameServer'ın LoadAchieveData içinde çöktüğü yerel BugTrap XML'inden doğrulandı. Başarı yükleyicisine veri uzunluğu/kayıt sayısı ve eksik tanım denetimleri eklendi; Release x64 derlemesi ve yerel dağıtımı tamamlandı. Gerçek şifreli ağ testinde cabbar seçimi artık başarı kodu 1 veriyor. SQL testi 448 başarı kimliğinin tamamını ve oluşturma bağımlılıklarını doğruluyor; geçici değişiklikleri geri alıyor. Grafik istemciyle haritaya giriş hâlen doğrulanmalıdır. Kanıtlar: `11_Istemci_Uyumluluk/character-creation-sql-test.json`, `character-select-network-test.json`, `Cokme_Incelemesi/character-select-crash.json`.

## Yeniden hazırlama sırası

1. `hazirla-kaynak-derleme.py` ve MSBuild ile sunucuyu derleyin.
2. Yeni/boş laboratuvar için `hazirla-temu-veritabani.py`, ardından `kur-temu-lab-db.ps1` çalışır. Var olan dolu veritabanı üzerine yazmaz.
3. `temu-unsigned-alanlar.py` ve `duzelt-temu-unsigned-veri.ps1` ile unsigned alanlar denetlenir.
4. `hazirla-yerel-calisma.py`, `yapilandir-temu-lab.ps1`, `kaynak-lua-api.py`, `temu-gorev-eslestir.py` çalışma dosyalarını/raporlarını hazırlar.
5. `kur-test-hesabi.ps1` yalnızca yerel deneme hesabını oluşturur ve geri alınan SQL testlerini yapar.
6. `test-yerel-baslatma.ps1`, `istemci-protokol-test.py`, `test-yerel-auth.py` somut başlatma/ağ testlerini yapar.
7. `kur-karakter-bagimliliklari.ps1`, karakter fonksiyon/prosedürlerini ve gerçek ikili başlangıç şablonlarını hazırlar. `test-karakter-olusturma-sql.ps1` oluşturma yolunu geri alınan işlemlerle sınar. `test-karakter-listesi.py --select` yalnızca bu laboratuvardaki mevcut cabbar ile gerçek seçim akışını sınar; yeni karakter oluşturmaz.

Araçların tümü `06_Dokumantasyon/Araclar` altındadır. Hazırlık dönüşümü bir canlıya geçiş paketi değildir; tam istemci, karakter ve görev sınamaları tamamlanmadan yayımlanmamalıdır.
