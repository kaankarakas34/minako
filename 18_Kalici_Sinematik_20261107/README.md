# Hikâye sinematiği — 7 Kasım 2026

Önceki sunucu düzenlemesi tek başına kullanıcıdaki tekrar sorununu çözmedi. 6 Kasım'da ayrı istemciden 81 sinematik kaynağı çıkarılmış, 10 satırlı `movie_scene.tbl` sıfır satırlı, aynı şemada geçerli tabloyla değiştirilmişti. 7 Kasım kontrolünde kaynaklar hâlâ yoktu ve tablo boştu.

Bu aşamada başlatıcı her oyun açılışından önce kendi yanındaki SHA256 ile doğrulanan boş sahne tablosunu etkin `Data/movie_scene.tbl` üzerine yeniden uygular ve kopyanın özetini tekrar kontrol eder. Kopyalama veya doğrulama başarısızsa istemci başlatılmaz. MSBuild bu profil dosyasını başlatıcının `bin` klasörüne kopyalar. Böylece sonraki dosya yenilemeleriyle tablo geri gelirse normal masaüstü kısayolundan açılışta tekrar boşaltılır. `MovieVisible=0` uygulaması da korunur.

İstemcinin salt okunur incelemesinde, film tamamlandığında `0x8e2910` yolunun `ShowIntroMovie` değerini `HKLM\Software\KnightOnlineUS\ServerSelect` anahtarına dört baytlık `REG_BINARY 01 00 00 00` olarak yazdığı görüldü. Bu 32 bit uygulama anahtarı bilgisayarda bulunmuyordu. Kullanıcının sinematiği kalıcı kaldırma isteği kapsamında ve Windows yönetici onayıyla yalnızca bu uygulama değeri aynı biçimde oluşturuldu. `Set-IntroWatched.ps1` sonucu `intro-flag-result.json` içinde; değer yeniden okunarak doğrulandı. Bu kaydın sonraki girişteki davranışı kullanıcı testiyle ayrıca doğrulanmalıdır.

Sunucunun `WIZ_STORY` göndermemesine ilişkin önceki düzenleme korunuyor. Oyunun EXE dosyası, karakter verileri, eşyalar ve güvenlik ayarları bu aşamada değiştirilmedi. Kaynak/PDB/EXE başlatıcı yedekleri `Yedek` altında. Önceki sinematik dosyalarının geri dönüş kopyaları `17_Sinematik_Kaldirma_20261106/Yedek` altında; etkin oyun kopyasında bulunmuyor.

İstemci açıldıktan sonra hesap çevrimiçi olduğu için zorla yeniden başlatılmadı. Temiz açılış ve karaktere girişteki grafik sonucun kullanıcı tarafından doğrulanması bekleniyor. Doğrulama gelmeden tüm giriş sorununun çözüldüğü iddia edilmiyor.

## Son doğrulama

7 Kasım 2026 tarihinde kullanıcı, oyunu normal kapatıp yerel masaüstü kısayolundan yeniden açtıktan sonra hikâye sinematiğinin gelmediğini ve doğrudan oyuna girdiğini doğruladı. Temiz açılış testi geçti.
