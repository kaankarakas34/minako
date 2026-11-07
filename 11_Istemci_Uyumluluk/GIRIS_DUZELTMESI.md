# Girişte bekleme teşhisi — 5 Kasım 2026

Etkin profil: `05_Yamalar/v24_Patch/KnightOnline.exe` dosyasının ayrı kopyası. SHA256: `683BEFABAE1F217296BEFDA2A824B26BD2FFF77BFF67AA72A66C219C040F12FE`. EXE değiştirilmedi. Grafik giriş sonrası sunucu listesi henüz doğrulanmadı; çalışma sürüyor.

Özgün Gamesoft EXE'sinin yüklediği `gamesoft.xasm`, bağlantı adresini sabit bir uzak adresle karşılaştırıp farklı hedefleri TCP bağlantısı kurulmadan reddediyor. Salt okunur kanıt `client-ip-code-references.json` içindedir. Yalnızca adres verisini değiştiren geçici deneme bütünlük denetimince reddedildi ve tamamen geri alındı. Etkin başlatıcıda işlem belleği yazma, kod ekleme veya denetim atlama yoktur. Yama EXE'si bu Gamesoft modülünü yüklemiyor.

## Kopyada yapılan veri uyarlamaları

- UIs: ilk 312 sütun, EXE'nin beklediği 8.712 baytlık kayıt.
- Item_Org: ilk 40 sütun, 148 baytlık kayıt.
- Cloak: ilk 7 sütun, 52 baytlık kayıt.
- Üç satın alma tablosu: mevcut Item_Org verisinden ad sütunu eklenerek 44 baytlık kayıt. Mevcut kimlikler ve diğer alanların baytları korundu. Eşleşmeyen 303 ad boş bırakılıp raporlandı; tamamlanmış içerik sayılmıyor.

`patch-table-adaptation.json`, kayıt sayıları, EXE'deki boyut kontrolü adresleri, dosya özetleri ve ikili dönüşüm doğrulamasını içerir. Dönüştürücü: `06_Dokumantasyon/Araclar/uyarla-yama-istemci-tablolari.py`. Şifreli veri çerçevesi için MIT lisanslı [ko-tbl-tools](https://github.com/Bymuhh/ko-tbl-tools/tree/d1c49328188dec4b2474e21a43b0bfb4d9ce4d7c) kullanılır; kaynak ve lisans araştırma klasöründedir.

UI arşivi 109.769 kayıt bildirirken geçerli 2.815 kayıt içeriyordu. Tüm kaynak sınırları doğrulandı; kopyadaki sayı düzeltildi ve dosyalar baytları değişmeden UI klasörüne açıldı. Kopyanın Path.Ini ayarı UI için açık dosyaları kullanır. Raporlar `ui-archive-header-repair.json`, `ui-resource-extraction.json`; tekrarlanabilir araç `ac-istemci-ui-arsivi.py`. Bu değişiklikten sonra açılış animasyonu ve grafik giriş formu gözlemlendi.

## Sunucu ve doğrulama

TemuKO'nun paket anahtarı yama EXE'sindeki standart protokolle uyuşmuyordu. Ayrı kaynak kopyasındaki `shared/LocalClientProfile.h` bu istemciye uygun anahtarı seçer. CRC, paket sırası ve SQL kimlik doğrulaması korunur. GameServer ve LogInServer yeniden derlendi; özetleri `stock-profile-build.json` içindedir.

`test-yerel-sifreli-giris.py` gerçek LogInServer üzerinden anahtar alışverişi, yanlış şifrenin reddi, doğru hesabın kabulü ve tek yerel sunucunun listelenmesini doğruladı. `encrypted-login-baseline.json` son başarısız liste görünürlüğü denemesini, `encrypted-login-test.json` güncel başarıyı içerir. Bu test grafik istemcinin başarısı anlamına gelmez.

Yeni istemcinin giriş formu açık. Kullanıcının denemesi ve gerçek istemci paketleri bekleniyor. Karakter seçimi, haritaya giriş, görevler ve etkinlikler ayrıca sınanmalıdır. Hizmetler yalnızca loopback adreslerinde; yayın yapılmadı. Özgün kaynaklar ve istemci klasörleri değiştirilmedi.

## Invalid password düzeltmesi

Gerçek istemcinin iki denemesi giriş sunucusuna ulaştı ve INVALID yanıtı aldı. İstemci `HashPasswordString` biçimini kullanırken ilk sentetik hesap düz metinle oluşturulmuştu. Önceki ağ testi aynı biçimi kullanmadığından bu uyumsuzluğu yakalamadı.

Kullanıcının özgün SQL yedeğindeki `dbo.HashPasswordString` fonksiyonu salt okunur alındı ve laboratuvar veritabanına eklendi. Özel dosyadaki şifreden hesaplanan değer iki gerçek istemci denemesiyle birebir eşleşti. Yalnızca KnightLab1 hesabının kaydı bu biçime taşındı; kullanıcının giriş formuna yazacağı şifre değişmedi. Kanıt: `password-format-fix.json`.

`ko_password.py` aynı dönüşümün ASCII test portudur. Hesap hazırlama ve her iki ağ testi doğru biçimi kullanacak şekilde güncellendi. Doğru şifre kabulü, yanlış şifre, engelli hesap, olmayan hesap ve şifreli sunucu listesi testleri yeniden geçti. `password-encoder-test.json`, 1..16 uzunluklarındaki testlerin özgün SQL fonksiyonuyla eşleşmesini kaydeder.

Kaynağın giriş ve OTP günlüklerindeki şifre alanı kaldırıldı. LogInServer yeniden derlenip çalıştırıldı; bu kurulumun eski giriş günlüklerindeki şifre alanları temizlendi. Grafik istemcinin ikinci denemesi bekleniyor; sunucu listesinin görünmesi hâlâ ayrıca doğrulanmalıdır.

## Boş sunucu satırı ve oyun bağlantısı

Kullanıcı giriş sonrası sunucu seçim ekranını gördü, ancak sunucu adı boştu; satır seçilince bağlantı kopuyordu. Tam oyun girişi yapılmış sayılmadı.

Değiştirilmemiş yama EXE'sinin F5 okuyucusu `0x4b7e92` adresinde ad içinde `|` arıyor. Ayırıcının solu grup adı, sağı kanal adı. Grup adı boşsa `0x4d7119` adresindeki UI yolu grubu listeye eklemiyor. Laboratuvar kaydı `KnightLocal2239|Local-1` olarak düzeltildi; hazırlama betiği ve ağ testi de bu biçimi zorunlu kılıyor. `ko_server_list.py` gerçek paket içindeki tüm alanları ve görünür grup/kanal adını doğrular.

EXE'nin `GetVersion()` fonksiyonu (`0x4a93c0`) 2083 döndürüyor; bu bir 2239 istemcisi değildir. `0x4b17a0` sürüm okuyucusu `bayrak:u8, sürüm:u16, anahtar:u64, kip:u8` düzeni bekler. Kaynak motor 2239 olarak tutuldu; `LocalClientProfile.h` ile girişte 2083 protokolü için ayrı uyarlama seçildi. GameServer bu düzende rastgele açık anahtar gönderir ve sonrasındaki hesap girişinde şifreli paket, sıra ve CRC denetimini kullanır. Bu, tüm oyun paketlerinin uyumlu olduğunun kanıtı değildir.

Yeni hesabın `bNation=0`, karakter sayısı ve karakter kimlikleri boş olduğu durumda normal ülke seçimine ulaşması için GAME_LOGIN_V2 düzeltildi; diğer parola/yetki/bakım/kapasite denetimleri korundu. Önceden oluşturulmuş boş ACCOUNT_CHAR satırına seçilen ülkenin kaydı da NATION_SELECT içinde düzeltildi. Var olan seçilmiş ülke değiştirilmez. SQL testleri geçici verileri geri alır.

Gerçek GameServer üzerinden doğrudan ve yerel aktarıcıyla şifreli sürüm/anahtar, doğru/yanlış parola ve yeni hesap için ülke seçimi yanıtı testleri geçti: `game-account-network-test.json`, `game-account-relay-test.json`. SQL kapsamı `game-account-sql-test.json` ve `nation-select-sql-test.json` içindedir. Henüz grafik istemciyle ülke/karakter/harita doğrulanmadı.

TCP okuyucusunda ayrıca somut hata yeniden üretildi: yük ulaşıp iki baytlık paket sonu henüz gelmediğinde sunucu bağlantıyı kapatıyordu (`tcp-fragmentation-baseline.json`). Okuyucu tam paket sonunu bekleyecek şekilde düzeltildi. Şifreli paketin en küçük boyutu da sıra+opcode+CRC için 9 bayt olarak doğrulandı. `test-tcp-parcali-paket.py` hem oyun hem giriş sunucusunda başlık/yük/paket sonunu ayrı göndererek kontrol eder.

## Yaklaşık bir saniyede, veri gelmeden kopma

Son gerçek istemci denemesinde oyun portuna TCP bağlantısı kuruldu; istemci henüz hiçbir bayt göndermeden sunucu yaklaşık 0,85 saniyede bağlantıyı kapattı. Salt okunur inceleme süre birimi hatasını buldu: UNIXTIME2 ve GetLastResponseTime, GetTickCount64 ile milisaniyeydi; Timer_UpdateSessions ise 30 ve 1800 saniye değerlerini doğrudan karşılaştırıyordu. Böylece niyet edilen 30 saniye ve 30 dakika, 30 ms ve 1800 ms olarak uygulanıyordu.

İlk paketi iki saniye geciktiren test eski sunucuda 0,929 saniyede koptu (`idle-handshake-baseline.json`). Timer_UpdateSessions içinde iki değer de SECOND (1000) ile çarpılarak düzeltildi; denetim kapatılmadı. Yeni derlemede ilk paketten önce iki saniye, doğrulanmış girişten sonra üç saniye bekleyen test geçti; beklemeden sonra gerçek karakter listesi yanıtı da alındı (`game-account-relay-test.json`). Önceki hemen paket gönderen testler bu zamanlama hatasını kapsamıyordu.

Güncel gerçek istemci denemesi bekleniyor. `test-yerel-oturum-suresi.py` ilk giriş için amaçlanan 30 saniyelik boşta kalma sınırının hâlâ uygulandığını ayrıca doğrular.

## Karakter oluşturma, görünmeyen gövde ve karakter seçiminde sunucu çökmesi

5 Kasım'daki gerçek istemci denemesinde ülke ve karakter oluşturma ekranına ulaşıldı. `CREATE_NEW_CHAR` ilk olarak eksik `dbo.IsValidCharacters` nedeniyle başarısız oldu. Kullanıcının özgün SQL yedeğindeki gerçek fonksiyon alındı. Aynı oluşturma yolundaki `LOAD_NEW_CHAR_VALUE`, `LOAD_NEW_CHAR_SET`, `DELETE_GM`, posta ve başarı başlangıç şablonları da yazarın referansından uyarlandı. Zorunlu USERDATA alanları ve okunmamış posta durumu/tarihi açıkça başlatılır. Başlangıç türü 4 için tanım bulunmadığından normal seviye-1 profili 0 seçildi; başlangıç eşyalarının mevcut kimlikleri korundu.

`cabbar` oluşturulduktan sonra gövde görünmüyordu. BEGINNER_ITEMS alanlarında gerçek 600 bayt yerine `#(23 124 ...)` biçimindeki sayısal dizinin metin baytları bulunuyordu; eski prosedür bunun ilk 600 baytını envanter diye kaydediyordu. Beş sınıfın statik şablonu, sayılar ve uzunluk doğrulanarak gerçek baytlara çevrildi. LOAD_NEW_CHAR_SET artık 75 yuva için 600 bayt eşya ve derlenen sunucunun okuduğu düzende 300 bayt süre üretir. Son yuvadaki sıfır olmayan süreyle little-endian doğrulaması da yapıldı. Yalnızca bilinen bozuk başlangıç şablonuyla birebir eşleşen, çevrimdışı `cabbar` kaydı yedeklenip onarıldı; karakter istatistikleri değiştirilmedi. Sonraki grafik gözlemde tüm gövde, zırh ve silahlar göründü.

Start Game sonrasında görülen `System BugsTrap`, GameServer.exe'ye aitti. Yerel XML, ACCESS_VIOLATION konumunu `CDBAgent::LoadAchieveData`, DBAgent.cpp:3805 olarak gösterdi. Başarı şablonu da aynı metin kodlamasıyla kalmıştı: 11.366 bayt metin yerine 5.200 bayt ikili veri ve 448 geçerli başarı kimliği gerekir. İki statik şablon ve yalnızca bunlarla birebir eşleşen cabbar başlangıç kaydı yedeklenip onarıldı. Kaynak kopyasına uzunluk/kayıt sayısı ve bulunamayan başarı tanımı denetimleri eklendi; GameServer Release x64 derlenip yerel çalışma kopyasına alındı.

`character-creation-sql-test.json`: aynı ırk 4/sınıf 104 parametreleriyle oluşturma ve native takip prosedürleri; isim/ülke retleri, kayıt bağımlılıkları, 448 başarı kimliğinin tamamı ve ikili boyutlar geçti. Geçici hesap/karakter ve şablon test değişiklikleri geri alındı. `character-select-network-test.json`: gerçek şifreli GameServer bağlantısında `cabbar` listelendi ve karakter seçimi 1 (başarılı) döndü. Grafik istemciyle haritaya giriş henüz doğrulanmadı; görev ve etkinliklerin tamamlandığı anlamına gelmez.

Tekrarlanabilir araçlar: `kur-karakter-bagimliliklari.ps1`, `test-karakter-olusturma-sql.ps1`, `test-karakter-listesi.py`. Tek seferlik ve eşleşme kontrollü onarımlar: `onar-bozuk-baslangic-envanteri.ps1`, `onar-basari-kaydi.ps1`. Yedekler ve onarım raporları bu klasördedir. Özgün istemci, kaynak ve referans veritabanları değiştirilmedi.
