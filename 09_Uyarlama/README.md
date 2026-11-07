# 2083 hazır sunucu için karşılaştırma çalışması

Kullanıcı 4 Kasım 2026 tarihinde kaynak koddan derleme ve yeni etkinlikleri ekleme yolunu seçti. **Aktif hedef `10_Kaynak_Derleme/` içindeki TemuKO kaynak kopyasıdır.** Bu klasör eski hazır GameServer'a karşı hazırlanan deneysel karşılaştırma kopyasıdır; canlıya alınmış veya eksiksiz oyun testi yapılmış paket değildir.

Hazır EXE'nin gerçek Lua kayıt tablosu çıkarıldı: 112 fonksiyon, 2083 kaynak referansıyla ad/sıra olarak aynı. TemuKO 2239 API'sinden farklı. `UpdateEvent` ve bazı görev durum işlemleri uyarlandı. Ödül işlemi başarısızken görevin tamamlanmasını önleyen Lua denetimleri denendi. Seçilebilir ödüllerde eski native işlevin maliyet/bonus davranışı farklı olduğundan kör bir eşleme yapılmadı; son deneysel dosyalar kısmi ve devre dışı olaylar içerir.

`KNIGHT_24XX_ADAPT` ayrı SQL kopyasında `UPDATE_ALL_CHAR_ID` kuruldu; beş parametreli güncelleme, diğer hesaba dokunmama ve test verisini geri alma kontrolleri geçti. `KNIGHT_24XX_TEST` ve özgün oyun dosyaları değiştirilmedi.

Kanıtlar: `06_Dokumantasyon/Uyarlama/`. Oradaki son benzetim raporları yalnızca çalıştırıldıkları çalışma kopyasına aittir; kaynak koddan derlenecek yeni sunucuyu doğrulamaz. Eski hedefte seçilebilir ödül uyarlaması yeniden sınırlandırıldığı için son dört-NPC regresyonunda bir başarısız durum vardır; bu klasör hazır sürüm olarak sunulmamalıdır.
