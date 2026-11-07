# Options, Hedef Barı ve Ekran Düzeltmesi

İstemci, kaynak tablosunun 160. sütunundan `ui\re_Seed_Helper.uif` yüklüyordu. Bu yeni özel arayüzdeki group_option_font panelini 2083 istemcisi tanımadığı için diğer seçenek sayfasıyla birlikte görünür bırakıyordu. İki ülkenin yolu mevcut `ui\co_seed_helper_us.uif` dosyasına çevrildi. Bu dosya eski game/graphic/effect/sound/pet seçenek düzenini içeriyor. Yeni düğme ve panel görselleri yüklenmeyerek üst üste binme kaynağı giderildi; son grafik doğrulaması kullanıcı girişinden sonra yapılmalıdır.

Ayrıca 282. sütundaki `ui\re_target_framebar.uif` yolu, 2083 istemcisinin desteklemediği ve güncelleyemediği sabit `Text_Health` ("0 / 0 ( %0 )") ile çalışmayan `Btn_Drops` butonunu içeriyordu. Bu yol orijinal uyumlu `ui\co_target_framebar.uif` dosyasına bağlandı; böylece sahte ve güncellenmeyen `0 / 0 ( %0 )` yazısı kaldırılarak temiz USKO hedef çerçevesine dönüldü.

Envanterde 8-27 arası slotların üzerinde asma kilit (`ui\re_cash_warehouse.dxt`) gösteren `base_LockImg` düğümü `re_Inventory.uif` içerisinden tamamen ayıklandı ve dosya yeniden derlendi. Orijinal dosya `Yedek/re_Inventory.before-lock-removal.uif` olarak saklandı. Böylece çantanın tüm 28 yuvası açık ve kilitsiz hale getirildi.

Kaynak yolları dışında UIs_us.tbl hücreleri ve 312 sütunluk şema korunuyor. Şifreleme sonrası çözülüp bayt karşılaştırması yapıldı.

Donanımdan okunan çözünürlük 1920x1080. Yalnızca oyun Option.ini dosyasındaki ViewPort Width/Height/ColorDepth ile Screen WindowMode değiştirildi: 1920/1080/32/0. Windows ekran ayarları değiştirilmedi. Önceki INI ve kaynak tablosu Yedek klasöründedir. Oyun kapalıyken uygulandı.

Araçlar: `06_Dokumantasyon/Araclar/duzelt-options-arayuzu.py`, `duzelt-target-bar.py`, `ayarla-istemci-ekran.py`. Temel altı tabloyu hazırlayan `uyarla-yama-istemci-tablolari.py` aracı da aynı uyumlu kaynak yollarını (160 ve 282) seçer; sonraki hazırlamada bu düzeltmelerin geri gitmesi engellendi.

Raporlar: options-resource-fix.json, targetbar-resource-fix.json, display-settings.json. EXE değiştirilmedi.
