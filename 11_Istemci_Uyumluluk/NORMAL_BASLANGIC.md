# Normal ilerleme hedefi

Kullanıcı PvP hazır karakteri yerine 1. seviyeden başlayan USKO tarzı ilerleme istiyor. Resmî USKO'nun birebir ekonomisi/oyun verisi elde edilmiş değildir; laboratuvarın mevcut verisi ayrıca denetlenmelidir. Yardımdaki 11111 metni kullanıcının isteğiyle sonraya bırakıldı.

## Uygulanan başlangıç

- BEGINNER_SETTINGS/ServerNo=1: BeginnerType=0; beş sınıfın seviye ayarı 1, başlangıç deneyimi/Noah/NP 0. Statlar karakter oluşturma ekranından gelir.
- Normal ekipman artık ayrı KNIGHTLAB_NORMAL_STARTER_ITEMS tablosundan gelir. Warrior/Rogue/Mage/Priest için mevcut ITEM tablosundaki altı temel Novice parçası kullanılır. Kurian için sınıfa özel doğrulanmış düşük seviye set bulunmadığından ortak Short Sword ve boş zırh yuvaları kullanılır; bu sınıfın normal görev ekipmanı ayrıca incelenmelidir.
- 25 tanımın tümü mevcut istemcinin Item_Org tablosunda bulundu, seviye gereksinimleri 0. Normal başlangıçta Krowaz, Dark Knight, gelişmiş takılar, PvP yedek silahları ve scroll paketi dağıtılmaz.
- Normal oluşturma yolunda 13 REGALO posta hediyesi ve 50.000/55.000 otomatik CashPoint/BonusCashPoint verilmez. Yüksek seviye şablonlar açıkça seçilen ayrı profiller için korunur.
- Cabbar çevrimdışıyken 31 hatalı başlangıç eşya yuvası temizlendi, altı temel rahip parçası verildi. Kullanılmamış 13 başlangıç hediye postası geri alınabilir biçimde bDeleted=1 yapıldı. Önceki ikili veriler ve posta kimlikleri normal-start-before-cabbar-*.json dosyasına yedeklendi. Oynayarak kazanılan 2. seviye, 25 EXP, 438 Noah ve diğer loot korundu; karakter sıfırlanmadı. Yeni karakterler 1. seviyeden başlar.

## Doğrulama

test-karakter-olusturma-sql.ps1 geçici hesabın tam oluşturma yolunu, beş sınıfın 75 eşya yuvasını, sıfır başlangıç paralarını/NP'yi, güçlü hediye verilmemesini ve 448 başarı kimliğini sınar; işlemleri geri alır. character-select-network-test.json gerçek GameServer'dan cabbar için yalnızca temel ekipmanı ve başarılı karakter seçimini kaydeder. Sonraki grafik görünüm tekrar doğrulanmalıdır.

## Henüz USKO uyumlu sayılmayan kapsam

Görevler/ödüller, yaratık EXP ve dropları, upgrade olasılıkları, sınıf/master görevleri, pazar/takas, klan, savaş ve etkinlikler uçtan uca doğrulanmış değildir. Mevcut kaynakta bazı görevler eksiktir. BONUS bölümündeki EXP/MONEY/NP ek bonusları 0 olsa da bu, yaratık ve görev tablolarının resmî oranlarla aynı olduğunu kanıtlamaz. Online KC/NP, chat cash ve Wanted gibi özel paket ödülleri de ayrı denetlenmelidir. Bunlar kapatılmış veya USKO'ya birebir çevrilmiş diye raporlanmamalıdır.

Araçlar: kur-karakter-bagimliliklari.ps1 normal profili kurar; uygula-normal-baslangic.ps1 varsayılan olarak önizleme verir, -Apply yalnızca çevrimdışı cabbar kaydına kontrollü uygulama yapar.
