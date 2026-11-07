# Knight Online dosya haritası

Tarama ve düzenleme: 4 Kasım 2026. Proje kökü: `C:\Users\murat\OneDrive\Desktop\mınako`.

**Kurulum güncellemesi:** SQL Server 2022 Express 16.0.4305.5, ODBC 18 ve sqlcmd kuruldu; yedek ayrı test veritabanına açıldı. 43 SQL harita referansı bulundu; 468 `.lua` adı, 12 uzantısız görev referansı ve `UPDATE_ALL_CHAR_ID` prosedürü eksik çıktı. Ayrıntılar: `06_Dokumantasyon/Kurulum/GEREKLILIKLER.md`. İndirilen araçlar yeni `07_Kurulum_Paketleri/` klasöründe.

**Alternatif dosya araştırması:** `08_Arastirma_Adaylari/` altında `AKGame-2383`, `22xx-FilesKoRelease`, `Orcun-24xx`, `KORust-Inceleme` ve `SQL_Referans` bulunuyor. Eksik `UPDATE_ALL_CHAR_ID` SQL tanımı bulundu; uygulanmadı. Tüm setlerde 468 Lua adının 467'si için ad eşleşmesi var; yeni 182 eşleşmenin 180'i yalnızca başlangıç yönlendirmesi. İlk 285 ad eşleşmesinin 8'i de boş dosyaydı. Bu sayılar çalışır görev sayısı değildir. Adaylar ana sunucuya uygulanmadı; mevcut eksik dosya durumu henüz değişmedi. Ayrıntılar: `06_Dokumantasyon/Internet_Arastirmasi/GITHUB_GENIS_TARAMA.md`.

**12.413 mevcut dosya, 3.164.586.643 bayt (2,947 GiB) tarandı ve yeni konumlarında doğrulandı.** Bu sayı, tarama sonrasında üretilen harita ve envanter belgelerini içermez. Tüm mevcut dosyaların yolları ve boyutları kaydedildi; 48 kritik dosyanın SHA-256 özeti taşınmadan önce ve sonra karşılaştırıldı. Eksik dosya, boyut farkı veya kontrol edilen özetlerde fark bulunmadı.

## Yeni klasör düzeni

```text
mınako/
├── DOSYA_HARITASI.md
├── 01_Kaynak_Kod/
│   └── TemuKO-main/
│       ├── README.md
│       ├── AntiCheat/
│       │   ├── TEMUKOACS.sln
│       │   └── TEMUKOACS/
│       └── ServerFiles/SourceFiles/
│           ├── KnightOnlineServer.sln
│           ├── GameServer/
│           ├── LogInServer/
│           ├── shared/
│           ├── scripting/Lua/
│           ├── N3BASE/
│           └── BugTrap/
├── 02_Sunucu/
│   └── 24xx/
│       ├── AIServer.exe
│       ├── AIServer.ini
│       ├── GameServer.exe
│       ├── GameServer.ini
│       ├── LogInServer.exe
│       ├── LogIn.ini
│       ├── Map/
│       ├── Lua/
│       ├── Quests/
│       ├── Logs/
│       └── ... .pdb, .ilk, .lib ve özgün açıklama dosyaları
├── 03_Veritabanlari/
│   └── 24xx/
│       ├── v24xx Database.bak
│       └── Lütfen Okuyun.txt
├── 04_Istemci/
│   └── Gamesoft_v24xx/
│       ├── KnightOnLine.exe
│       ├── Launcher.exe
│       ├── Server.ini
│       ├── Option.exe
│       ├── Data/
│       ├── Zones/
│       ├── Chr/, ChrSelect/, Item/, Object/
│       ├── UI/, DTex/, fx/, Snd/
│       ├── GameSoft/
│       └── ... diğer özgün istemci dosyaları
├── 05_Yamalar/
│   └── v24_Patch/
│       ├── KnightOnline.exe
│       ├── Launcher.exe
│       ├── Server.ini
│       └── Lütfen Okuyun.txt
└── 06_Dokumantasyon/
    ├── Onceki_Arastirma/
    ├── Orijinal_Notlar/
    ├── Envanter/
    │   ├── dosya-envanteri.csv
    │   ├── dosya-agaci.txt
    │   ├── klasor-ozeti.csv
    │   ├── uzanti-ozeti.csv
    │   ├── tasima-plani.json
    │   ├── tasima-gunlugu.json
    │   └── dogrulama.json
    └── Araclar/
        └── geri-al.ps1
```

Bu gösterim ana bileşenleri özetler. Bütün mevcut dosyaların ayrıntılı listesi `06_Dokumantasyon/Envanter/dosya-envanteri.csv`, tam ağaç gösterimi `06_Dokumantasyon/Envanter/dosya-agaci.txt` içindedir.

## Bileşen envanteri

| Klasör | Mevcut dosya | Boyut (MiB) | İşlev |
| --- | ---: | ---: | --- |
| `01_Kaynak_Kod` | 954 | 21,26 | TemuKO C/C++ sunucu ve istemci anti-cheat kaynakları |
| `02_Sunucu` | 822 | 464,06 | Hazır 24xx sunucu programları, ayarlar, haritalar, görevler, günlükler |
| `03_Veritabanlari` | 2 | 82,10 | SQL yedeği ve özgün paylaşım notu |
| `04_Istemci` | 10.627 | 2.435,88 | Oyun istemcisi, görseller, sesler, tablolar, haritalar |
| `05_Yamalar` | 4 | 14,65 | Alternatif istemci/launcher programları ve bağlantı ayarı |
| `06_Dokumantasyon` | 4 | 0,03 | Önceki araştırma çıktıları ve kökteki özgün not; yeni raporlar hariç |

Başlıca dosya türleri: 3.916 `.dxt`, 2.303 `.png`, 636 `.n3chr`, 572 `.gtt`, 547 `.lua`, 540 `.h`, 503 `.ogg`, 286 `.tbl`, 285 `.cpp`, 169 `.smd`. Tam uzantı dökümü ayrı CSV'dedir.

## Kaynak kod ile hazır sunucu paketinin ayrımı

**TemuKO kaynağının protokol sabiti 2239. Hazır paket ise 24xx etiketi taşıyor; bu iki paketin uyumluluğu doğrulanmış değil.**

| Konu | TemuKO kaynak kodu | Hazır 24xx paketi |
| --- | --- | --- |
| Ana parçalar | GameServer, LogInServer, shared, Lua; ayrıca TEMUKOACS | AIServer.exe, GameServer.exe, LogInServer.exe |
| Veritabanı bağlantısı | Örnek ayarlarda `KO_MAIN` ve `KO_GAME` DSN'leri | Üç programın ayarlarında `kn_online` DSN'si |
| Sunucu ayar adları | `.GameServer.ini`, `.EventAwards.ini`, `.Chat.ini`, `.LogInServer.ini` | `GameServer.ini`, `AIServer.ini`, `LogIn.ini` |
| AI bileşeni | Ayrı AIServer projesi solution içinde yok | Ayrı AIServer.exe mevcut; AI bağlantı ayarı var |
| Haritalar/görevler | Kodda `./map/` ve `./Quests/` yolları | `Map/`, `Quests/` ve `Lua/` dizinleri mevcut |

Kaynak projesindeki `shared/version.h`, `GameServer/Define.h`, `LogInServer/Define.h` ve hazır paketin INI dosyaları bu ayrımı gösteriyor. Dosya isimleri benzer diye hazır EXE'ler, SQL yedeği ve kaynak çıktıları birleştirilmedi.

## SQL yedeği bulundu

Dosya: `03_Veritabanlari/24xx/v24xx Database.bak`.

- Boyut: **86.092.288 bayt**, yaklaşık **82,10 MiB**.
- Taşımadan önce ve sonra SHA-256 karşılaştırması başarılı.
- SQL Server 2014 (12.0.2000) kaynaklı `kn_online` yedeği olduğu doğrulandı. `KNIGHTLOCAL` örneğinde `KNIGHT_24XX_TEST` adıyla geri yüklendi; 158 tablo ve 163 prosedür bulundu. Özgün yedek korundu.
- `kn_online`, INI dosyalarındaki **DSN adıdır**; gerçek SQL veritabanının adının da aynı olduğunu kanıtlamaz.
- Önceki araştırmanın SQL nesne listeleri TemuKO **kaynak kodundan** çıkarılmış referanslardır. Bu BAK dosyasının içeriğinin envanteri değildir.

## Bağlantı ve sürüm bulguları

- Hazır sunucu ayarları: GameServer `15001`, Login `15100`, AI bağlantısı `10020`. Bunlar yapılandırma değerleridir; çalışan süreç veya açık port ölçümü yapılmadı.
- TemuKO kaynağında LoginServer `15100–15109` aralığını açan döngü bulunur. Bu davranışın hazır 24xx LoginServer.exe için de geçerli olduğu varsayılmamalı.
- Hazır sunucunun bazı ayarları localhost kullanırken Login sunucu listesinde eski bir dış IP ve indirme alan adı bulunuyor.
- Ana istemcinin `Server.ini` dosyasında dış IP, `Files=2452`, `Last=2226` var.
- Yamanın `Server.ini` dosyasında localhost, `Files=2083`, `Last=2083` var.
- Bu INI alanları güncelleme/istemci ayarı göstergeleridir; tek başlarına gerçek ağ protokolünün sürümünü kanıtlamaz.
- Ana istemci ile yamanın KnightOnline.exe dosyalarının boyutları farklı. Windows dosya sürüm alanları ise ikisinde de `4, 23, 13, 3000`; bu bilgiyle uyumluluk kararı verilemez.
- `Lua/Quests` ve `Quests` ayrı ayrı korundu. Bunların kopya veya alternatif görev setleri olup olmadığı içerik bazında henüz karşılaştırılmadı.
- Hazır sunucu paketindeki 56 günlük ile `.pdb`, `.ilk`, `.lib` dosyaları korundu. İstemcinin yardımcı araçları ve diğer içerikleri de yerinde tutuldu.

## Yapılan düzenleme ve doğrulama

1. Tüm mevcut dosyaların eski/yeni göreli yolları, boyutları ve son değiştirilme zamanları kaydedildi.
2. BAK, EXE, DLL, INI, SLN ve VCXPROJ türlerindeki 48 kritik dosyanın SHA-256 değerleri alındı.
3. Paketlerin iç yapıları korunarak yedi taşıma işlemi uygulandı. Tekrarlanan dış paket klasörleri yalnızca boş kaldıkları doğrulandıktan sonra kaldırıldı.
4. 12.413 dosyanın tamamı hedef yollarında boyutlarıyla kontrol edildi; seçilen 48 dosyanın SHA-256 değerleri yeniden karşılaştırıldı. Fark yok.
5. İlk dosya haritalama aşamasında EXE/DLL çalıştırılmadı ve SQL geri yüklenmedi. Sonraki kurulum aşamasında yedek test veritabanına geri yüklendi. Oyun EXE'leri çalıştırılmadı; özgün INI içerikleri değiştirilmedi; yama uygulanmadı. Dosya taraması zararlı yazılım analizi veya oyun çalışabilirlik testi değildir.

Taşıma kaydı `tasima-gunlugu.json` içindedir. `Araclar/geri-al.ps1`, paketleri eski yollarına taşımak için hazırlanmıştır; otomatik olarak çalıştırılmadı. Yeni raporları silmez.

## Kurulum için sonraki teknik inceleme

SQL altyapısı kuruldu; yedek geri yükleme ve 32 bit ODBC bağlantısı doğrulandı. Sıradaki işler eksik görev dosyaları ile SQL prosedürünün uyumlu setten tamamlanması, oyun DSN/hesap ayarları ve istemci–sunucu eşleşmesinin test edilmesidir. Hazır oyun sunucusunun çalıştığı henüz kanıtlanmış değil. TemuKO 2239 kaynak geliştirmesi ayrı tutulmalı; uyumluluk belirlendikten sonra hangi tabanın kullanılacağı seçilmeli.

Canlıya geçiş öncesinde gerçek portlar, hesap/karakter kaydı, harita geçişi, NPC/görevler, yeniden başlatma sonrası veri kalıcılığı, yedek geri dönüşü ve kullanılan paketlerin lisans/izin durumu ayrıca doğrulanmalı.
