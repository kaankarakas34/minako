# Knight Online 24xx — gereklilikler ve yerel kurulum

İnceleme tarihi: 4 Kasım 2026. Hedef, `02_Sunucu/24xx` hazır paketini ayrı bir yerel SQL ortamıyla değerlendirmek. `01_Kaynak_Kod/TemuKO-main` kaynakları 2239 sürümünde ve ayrı tutuluyor.

**Kurulum tamamlandı ve 32 bit ODBC bağlantısı geçti.** SQL Server 2022 Express `16.0.4305.5`, ODBC Driver 18 ve sqlcmd çalışıyor. Yedek `KNIGHT_24XX_TEST` adıyla geri yüklendi; `RESTORE VERIFYONLY` ve `DBCC CHECKDB ... PHYSICAL_ONLY` hata vermedi. Yeniden başlatma gerekmedi.

**Oyun paketi henüz eksiksiz değil:** 468 `.lua` adı ve uzantısız 12 ek görev dosyası referansı dosyalarda bulunamadı. `UPDATE_ALL_CHAR_ID` prosedürü SQL'de yok. Veritabanındaki 43 harita referansının tamamı dosyalarda mevcut.

## Gerekli bileşenler

| Bileşen | Neden gerekli? | Bu bilgisayardaki bulgu / işlem |
| --- | --- | --- |
| Windows x64 ve x86 uygulama desteği | Hazır üç sunucu EXE'si ve incelenen istemci bileşenleri x86 | Windows 11 Pro x64 mevcut |
| Microsoft SQL Server | SQL yedeği Microsoft SQL Server biçiminde; programlar SQL'e ODBC üzerinden bağlanıyor | Ayrı `KNIGHTLOCAL` SQL Server 2022 Express örneği kuruldu; hizmet çalışıyor |
| SQL güncellemeleri | Yeni kurulacak motorun servis ve güvenlik güncellemeleri | CU27 KB5104824 ve CU27 güvenlik güncellemesi KB5126934 kuruldu; sürüm 16.0.4305.5 |
| ODBC Driver 18, x86 ve x64 | Oyun sunucuları 32 bit olduğu için x86 sürücü/DSN gerekli; yönetim araçları x64 kullanabilir | 18.7.1.1 sürücü iki mimaride kuruldu |
| sqlcmd | SQL sürümü, yedek ve sorgu kontrolleri için yönetim aracı | Microsoft sqlcmd 1.10.0 kuruldu |
| Visual C++ çalışma zamanı | SQL ODBC sürücüsü gibi bileşenlerin C/C++ çalışma zamanı | 2015–2022 v14.44 x86/x64 mevcut. Üç oyun sunucusunda ayrı `msvcr110.dll` veya debug CRT importu yok |
| .NET Framework | SQL kurulum/yönetim bileşenleri | Release 533509, sürüm 4.8.09221 mevcut |
| DirectX ve eski grafik yardımcıları | İstemci D3D9/DirectInput/DirectSound kullanıyor | Windows sistem kitaplıkları ve istemci yanındaki `d3dx9_43.dll` mevcut; mevcut taramada ek kurulum gereksinimi doğrulanmadı |
| OpenAL ve Vorbis ses kitaplıkları | KnightOnline.exe ses bağımlılıkları | `OpenAL32.dll` ve `libvorbisfile.dll` ana istemci klasöründe mevcut |
| Lua görev motoru ve görev dosyaları | NPC/görev akışı | Lua motoru hazır sunucuya gömülü görünüyor; ayrı Lua DLL importu yok. `Quests/01_main.lua` mevcut |
| Haritalar ve oyun verisi | Bölgeler, NPC'ler, item/skill verileri | 43 SQL harita referansı bulundu; görev dosyalarında ve bir SQL prosedüründe eksik var |

SQL Server 2022 Express ücretsiz küçük sunucu kullanımına uygun bir edition; ilişkisel veritabanı başına 10 GB sınırı var. Yedeğin sıkıştırılmış boyutu tek başına geri yüklenen veritabanının boyutunu kanıtlamaz. Developer edition canlı sunucu için lisanslanmıyor. [Microsoft edition karşılaştırması](https://learn.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2022).

SQL Server 2014 yedeklerinin daha yeni SQL sürümüne taşınması desteklenen geçiş kapsamındadır; bu yedek de test veritabanına başarıyla geri yüklendi. [Microsoft SQL Server 2022 geçiş kuralları](https://learn.microsoft.com/en-us/sql/database-engine/install-windows/supported-version-and-edition-upgrades-2022).

## Kurulumun kapsamı

- SQL instance: `KNIGHTLOCAL`.
- Test veritabanı: `KNIGHT_24XX_TEST`. Başka bir veritabanının üzerine yazılmayacak.
- Başlangıçta Windows kimlik doğrulaması; SQL TCP ve named pipes kapalı. Yönetim shared memory üzerinden yerel yapılacak.
- SQL bellek ayarı: 2.048 MB üst sınır.
- Kurulumda kullanılan yerel SQL medyası: `%ProgramData%\KnightOnlineLab\Sql2022Media`. Kullanıcı profili altındaki ilk medya denemesinde Windows Installer yol hatası verdi; ProgramData medyasıyla kurulum tamamlandı.
- SQL'in okuduğu yedek kopyası: `%ProgramData%\KnightOnlineLab\Backups`. Klasör erişimi ilgili kullanıcı, Administrators, SYSTEM ve yeni SQL hizmetiyle sınırlandırıldı.
- ODBC deneme DSN'si: `Knight24xx_Audit`, 32 bit. `kn_online` oyun DSN'si ve ayrı oyun hesabı, oyun çalışma ayarları hazırlanırken tamamlanmalı.
- Mevcut PostgreSQL hizmeti bu kurulumun parçası değil.
- Özgün oyun INI'leri ve EXE'leri değiştirilmedi. Oyun sunucuları/istemci çalıştırılmadı; güvenlik duvarında internet erişimi açılmadı.

Kurulumun gerçek durumu `kurulum-durumu.json` dosyasında. İşlem günlüğü ve hatalar bu klasöre yazılıyor. Betik: `../Araclar/kur-gereklilikler.ps1`.

## İndirilen Microsoft paketleri

Altı kurulum paketi proje kökündeki `07_Kurulum_Paketleri` klasörüne indirildi. Çalıştırılmadan önce Microsoft Authenticode imzaları doğrulandı. ODBC, bootstrap, sqlcmd ve güvenlik güncellemesi için yayınlanan SHA-256 değerleri de karşılaştırıldı. Son dosya özetleri ve imzalar `paket-imzalari.csv` içinde.

- [SQL Server 2022 Express bootstrap — Microsoft WinGet manifestosu](https://github.com/microsoft/winget-pkgs/tree/master/manifests/m/Microsoft/SQLServer/2022/Express)
- [SQL Server 2022 CU27 — Microsoft Download Center](https://www.microsoft.com/en-us/download/details.aspx?id=105013)
- [SQL Server 2022 CU27 güvenlik güncellemesi — Microsoft Download Center](https://www.microsoft.com/en-us/download/details.aspx?id=108870)
- [ODBC kurulumu ve gereksinimleri — Microsoft Learn](https://learn.microsoft.com/en-us/sql/connect/odbc/windows/system-requirements-installation-and-driver-files)
- [sqlcmd kurulumu — Microsoft Learn](https://learn.microsoft.com/en-us/sql/tools/sqlcmd/sqlcmd-download-install)
- [sqlcmd 1.10.0 — Microsoft GitHub sürümü](https://github.com/microsoft/go-sqlcmd/releases/tag/v1.10.0)

Kurulum medyası hazır oyun dosyalarından çalıştırılmadı; gerekli araçlar yayıncı kaynaklarından alındı. SSMS, IIS, FTP sunucusu, PHP, MySQL veya PostgreSQL oyun sunucusunun saptanan doğrudan bağımlılıkları arasında değil. SSMS isteğe bağlı bir grafik yönetim aracıdır.

## Dosya/bağımlılık incelemesi

`pe-dll-bagimliliklari.csv`: 19 EXE/DLL dosyası ve 144 tekilleştirilmiş import referansı. Ana sunucu ve ana istemcide kontrol edilen doğrudan DLL'ler uygulama veya Windows x86 sistem dizininde bulundu.

Yama klasöründeki KnightOnline.exe için OpenAL32.dll ve libvorbisfile.dll aynı klasörde yok; bu dosyalar ana istemcide var. Yama dosyaları tek başına oyun istemcisi oluşturmaz. Protokol uyumu belirlenmeden ana istemciye uygulanmamalı.

Hazır GameServer.exe içinde `Notice.txt`, `Notice_up.txt` ve `01_main.lua` dosya adları bulundu. İki duyuru dosyası pakette eksik; bunlar kaynak koddaki davranışa göre duyuru içeriğidir. Hazır EXE için eksikliğin etkisi çalıştırma testiyle ayrıca doğrulanmalı. `01_main.lua`, hem `Quests/` hem `Lua/Quests/` altında mevcut.

`init.lua` ve `loadall.dll` gibi adlar Lua'nın genel arama şablonlarında da bulunabilir; yalnızca EXE içinde adları geçtiği için zorunlu eksik dosya olarak sayılmadı.

Yedek başlığı `TAPE` imzası ve Microsoft SQL Server bilgisini taşıyor. Kesin kaynak sürüm/kolasyon ve mantıksal dosyalar `RESTORE HEADERONLY` / `FILELISTONLY` çıktısıyla kaydedildi; SQL Server 2014 kökeni doğrulandı.

## SQL geri yükleme ve eksik kontrolünün sonuçları

- Özgün veritabanı adı: `kn_online`. Yedek tarihi: 12 Eylül 2017.
- Kaynak SQL motoru: **12.0.2000**, SQL Server 2014. Uyumluluk seviyesi: **100**; test veritabanında korundu.
- Kolasyon: `SQL_Latin1_General_CP1_CI_AS`.
- Geri yüklenen şema: **158 tablo, 163 prosedür**. Veri dosyası yaklaşık 97,7 MiB, günlük yaklaşık 9,9 MiB; Express kapasite sınırının altında.
- Üç hazır EXE'den çıkarılan **56 farklı prosedür adının 55'i** mevcut. Eksik: **`UPDATE_ALL_CHAR_ID`**. GameServer.exe içindeki çağrı `{CALL UPDATE_ALL_CHAR_ID(?, ?, ?, ?, ?)}` şeklinde. Aynı adı veya `ALL ... CHAR` adını taşıyan alternatif prosedür bulunmadı. Beş parametreli imzaya ve bu SQL sürümünün karakter düzenine uygun özgün tanım bulunmalı; prosedür mantığı uydurulmadı.
- Doğrudan SQL ifadelerinden çıkarılan **18 tablo adının tamamı** mevcut. Bu, dinamik SQL'in veya bütün kolonların uyumunu kanıtlamaz.
- `ZONE_INFO` tablosunda harita dosyası sütunu `strZoneName`. **43 satırın tamamının harita dosyası beklenen `Map/` yolunda bulundu**. Bu pakette `strZoneSmdName` kolonu yok; 2239 kaynak şemasıyla karıştırılmadı.
- `QUEST_HELPER.strLuaFilename` alanında **693 farklı, boş olmayan referans** var. Bunların **213'ü** mevcut görev dosyalarıyla eşleşti. **468 `.lua` dosyası adı** bulunamadı; ayrıca **12 uzantısız referans** ne özgün adıyla ne de `.lua` eklenmiş haliyle bulundu. Toplam eşleşmeyen referans: **480**. Bunların hangi oyun akışlarında etkin kullanıldığı çalıştırma testiyle ayrıca belirlenmeli.
- Eksik Lua örnekleri: `31567_Fellor.lua`, `29193_Dolkin.lua`, `25188_Rogos_KC.lua`, `19063_NewAdven.lua`. Eşleşmeyen dosyalar listelendi; farklı bir sürümden rastgele görev kopyalanmadı.
- `Quests/` ve `Lua/Quests/` arasında **274 dosya SHA-256 olarak aynı**. Sadece `Quests/` içinde bulunan ek iki dosya `ko-pvp.com.ini` ve `ko-pvp.com.lua`.
- `Notice.txt` ve `Notice_up.txt` paket kökünde bulunmuyor. Duyuru içeriği olarak sınıflandırıldı; eksik SQL prosedürü/görev dosyalarıyla aynı kritik düzeyde kabul edilmedi. Dosyalar bu incelemede oluşturulmadı.

### Kanıt dosyaları

- `sql-database-summary.json`: kurulu motor sürümü, edition, kolasyon ve nesne sayıları.
- `backup-header.json`, `backup-filelist.json`: SQL'in okuduğu gerçek yedek metadatası.
- `odbc-x86-baglanti-testi.json`: x86 süreçten `Knight24xx_Audit` DSN'siyle başarılı bağlantı ve veritabanı sorgusu.
- `hazir-sunucu-sql-uyumluluk.csv`: EXE–SQL nesne karşılaştırması.
- `sql-harita-detayli-kontrol.csv`: 43 bölge/harita eşleşmesi.
- `sql-gorev-dosya-kontrolu.csv`: 693 görev dosyası referansının tamamı.
- `eksik-gorev-dosyalari.csv`: 480 eşleşmeyen referans.
- `eksik-lua-dosyalari.csv`: `.lua` uzantılı 468 eşleşmeyen dosya adı.
- `gorev-seti-karsilastirma.csv`: iki görev klasörünün içerik karşılaştırması.

Kurulum altyapısı hazır. Oyun açılışı öncesinde uyumlu görev/SQL seti tamamlanmalı; ardından `kn_online` oyun DSN'si, sınırlı yetkili oyun hesabı, yerel sunucu/istemci IP ayarları ve istemci protokol eşleşmesi hazırlanıp test edilmeli. Mevcut dış IP'li INI'lerle oyun başlatılmadı.

Bu statik import taraması, dinamik olarak yüklenen bütün bileşenleri veya paketlenmiş EXE içindeki çalışma yollarını kanıtlamaz. Çalıştırma ve istemci bağlantı testi ayrıca gerekli.

## Kaynak koddan derleme için ek durum

TemuKO solution'ı MSVC v142 ve Windows SDK `10.0.22000.0` istiyor. v142 Build Tools 2019 mevcut; kurulu SDK `10.0.19041.0`. Kaynak derlemesi seçilirse istenen SDK'nın kurulması veya projenin mevcut SDK'ya uyarlanıp derlenmesi gerekiyor. Projedeki eski mutlak include yolları ve yapılandırmalar arası çıktı yolları da düzeltilmeli. Bunlar hazır 24xx EXE'lerini çalıştırmak için gereken bağımlılıklar değil.

TemuKO'daki donanım/IP lisans kontrolü kaynak sürümüne ait bir bulgu. Hazır 24xx EXE'lerinde aynı kontrolün varlığı doğrulanmadı. 2239 kaynakları ile 24xx SQL/istemci paketleri otomatik olarak uyumlu kabul edilmedi.
