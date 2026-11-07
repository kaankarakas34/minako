# Karakter stat yönetimi ve giriş hikâyesi — 6 Kasım 2026

GM panelinde **Oyuncu Yönetim Masası → Karakter Stat Yönetimi** sekmesi eklendi. Panel adresi: http://127.0.0.1:8080. Soldan karakter seçilip mevcut kayıt okunur. Seviye, EXP, beş temel stat, boş stat puanı, boş skill puanı, üç skill dalı, Master skill, ırk, sınıf ve ülke düzenlenebilir. Değerler sonraki oyun girişinde yüklenir.

## Kullanım

1. Karakterin hesabından oyunu normal kapatın. Çevrimiçi hesapta değerler yalnızca okunabilir.
2. Sekmedeki **Mevcut değerleri yeniden yükle** düğmesiyle son kaydı okuyun.
3. Alanları düzenleyip **Karakter değişikliklerini kaydet** düğmesine basın.
4. Oyuna yeniden giriş yapın.

Sınıf seçimi skill alanlarını sıfırlar; sınıf değişimi kaydedilirken dağıtılmış dallar sıfır olmalıdır. Yeni sınıf kaydedildikten sonra istenen skill dağılımı ayrıca kaydedilebilir. Yeni sınıf için eski skill kısayolları temizlenir. Irk değişiminde yüz/saç varsayılana döner. Envanter ve para korunur. Yeni sınıfa uymayan ekipman oyun içinde çıkarılmalıdır.

Ülke değişimi hesap bilgisiyle birlikte atomik kaydedilir. Yalnızca hesapta tek karakter, karakter klansız ve Moradon'dayken yapılabilir. Çok karakterli hesabın tek karakterini başka ülkeye çevirip hesabı tutarsız bırakmaz.

## Kayıt kuralları

Seviye 1–83; statlar 1–255; boş stat 0–32767; boş skill 0–255. Skill dalı seviyeyi aşamaz. Master sınıfı en az 60, Master skill en fazla `seviye − 60` (üst sınır 23) ister. EXP, seçilen seviyenin LEVEL_UP değerinden küçük olmalıdır. Sınırlar GM düzenlemesi içindir; normal oyuncu toplam puan bütçesi zorunlu tutulmaz.

`strSkill` düz metin sayılarla yazılmaz. Native sunucunun kullandığı 10 baytlık düzenin 0/5/6/7/8 alanları güncellenir; ayrılmış diğer baytlar korunur. SQL ANSI/Unicode dönüşümü sonrası aynı baytların geri okunması zorunludur. 148 gibi ASCII üstü değerle gerçek SQL testi yapıldı.

Her başarılı değişiklik, önceki ve sonraki değerlerle `dbo.KNIGHTLAB_CHARACTER_EDIT_AUDIT` tablosuna aynı işlem içinde kaydedilir. Eski formun yeni veriyi ezmesini önlemek için revizyon kontrolü vardır. Çevrimiçi hesap ve başarısız doğrulama kayıtları değiştirilmez. Eski tek-seviye API'si devreden çıkarıldı; ekonomi sekmesindeki seviye düğmesi yeni düzenleyiciye yönlendirir.

Panel yalnızca bu bilgisayardaki loopback adresinde çalışır. Çevrimiçi karaktere anlık stat aktarımı eklenmedi; yeni değerler yeniden girişte uygulanır.

## Giriş hikâyesi

GameStart içindeki `WIZ_STORY` gönderimi kaldırıldı; yeni karakter oluşturulduğunda intro bayrağı da kapalı tutuluyor. Release x64 GameServer derlendi, çevrimiçi hesap kalmadığı doğrulandıktan sonra yerel sunucuya alındı. Gerçek şifreli oyun girişinin ilk fazında normal GAMESTART cevabı geldi, hikâye opcode'u `0x81` gelmedi.

Başlatıcı her açılışta yalnızca oyunun `Option.ini` dosyasındaki `[Movie] MovieVisible=0` ayarını uygular. Oyun veya Windows EXE'si yamalanmadı. Bu ayar, ayrı yayıncı/logo ekranlarının kaldırıldığının kanıtı değildir. Karaktere girişin grafik kontrolü kullanıcı denemesiyle ayrıca doğrulanır.

## Kontroller

- Native GameServer ve Launcher derlemeleri başarılı.
- `test_character_editor.py`: gerçek SQL + FastAPI handler testleri başarılı; tüm geçici test değişiklikleri geri alındı.
- Kaydetme, limit/ırk/sınıf/EXP doğrulaması, eski revizyon, çevrimiçi hesap reddi, skill baytları, sınıf/kısayol ve tek karakterli ülke geçişi sınandı.
- Playwright ile sekmenin gerçek verileri yüklediği, form kontrolleri, 84 seviye sınırı ve 60 altı Master hatasının sayfada gösterilmesi doğrulandı. Sadece test amaçlı geçersiz istekler gönderildi; cabbar statları düzenlenmedi.
- `cabbar` mevcut 25. seviyesinde korundu.

Eski dosyalar `Yedek` klasöründe; sonuçlar `character-editor-test.json`, `no-story-network-test.json`, `deployment.json` ve derleme günlüklerinde. Görsel: `output/playwright/character-editor-wide.png`.
