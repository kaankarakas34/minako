# Minako — Knight Online yerel sunucu projesi

Sunucu kaynakları, veritabanı yedekleri ve SQL hazırlama araçları, istemci dosyaları, yerel başlatıcı ve GM yönetim panelinin çalışma kopyasıdır.

## İçindekiler

| Klasör | İçerik |
|---|---|
| `01_Kaynak_Kod` – `05_Yamalar` | Özgün kaynaklar, hazır sunucu, SQL yedekleri, istemci ve yamalar |
| `06_Dokumantasyon` | Kurulum, uyarlama, derleme ve test araçları |
| `07_Kurulum_Paketleri` | Mevcut bağımlılık kurulum paketleri |
| `08_Arastirma_Adaylari` | Araştırılan referans projeler; kökenleri `UPSTREAM_SOURCES.json` içinde |
| `09_Uyarlama` | Ara uyarlama dosyaları |
| `10_Kaynak_Derleme` | Düzenlenen C++ sunucu kaynakları, SQL hazırlığı ve yerel çalışma dosyaları |
| `11_Istemci_Uyumluluk` | Etkin istemci kopyası, başlatıcı ve bağlantı testleri |
| `12_USKO_Denetimi` – `13_Istemci_Arayuz_Duzeltmesi` | Oyun kuralı denetimleri ve arayüz düzeltmeleri |
| `14_GM_Admin_Paneli` | FastAPI tabanlı GM paneli ve web arayüzü |
| `15_Acilis_Onarimi_20261106` – `18_Kalici_Sinematik_20261107` | Açılış, karakter stat yönetimi ve sinematik düzeltmelerinin araç/raporları |

## İndirme

Büyük dosyalar Git LFS ile tutulur. Normal ZIP indirmesi yerine Git LFS kurulu bir Git istemcisi kullanın:

```powershell
git clone https://github.com/kaankarakas34/minako.git
cd minako
git lfs pull
```

## Çalışma profili

- Windows, Visual Studio 2019 C++ Build Tools (v142), Windows SDK 10.0.19041.
- SQL Server 2022 Express; yerel instance `KNIGHTLOCAL`, etkin veritabanı `KNIGHT_TEMU_2239`.
- Python 3, ODBC Driver 18, `pyodbc`, `fastapi`, `uvicorn`. Panel testi için `httpx`.
- Sunucu kaynak motoru 2239; bu kopyadaki istemci için açık 2083 protokol uyarlaması kullanılır.
- Oyun hizmetleri loopback adreslerinde, GM paneli `http://127.0.0.1:8080` üzerinde çalışır.

Bu bir dosya aktarımıdır; yeni bilgisayarda SQL instance/veritabanı/DSN ve makineye özgü yerel ayarlar ayrıca hazırlanmalıdır. Yerel başlatıcı ve bazı araçlardaki klasör yollarını kendi kurulumunuza göre doğrulayın. Makineye özgü `LocalBuild.private.h` ve test hesabı dosyaları depoya alınmadı; derleme/hesap hazırlığında yerelde sağlanmalıdır.

Yerel hizmetler ve oyun için `11_Istemci_Uyumluluk/Baslat-Yerel.ps1`; GM paneli için `14_GM_Admin_Paneli/Baslat-Panel.bat` kullanılır. SQL ve kurulum betiklerini çalıştırmadan önce ilgili README dosyalarını okuyun; paketler bu depo indirilince otomatik kurulmaz.

GM panelinde oyuncu, eşya, para, boss, drop/spawn ve karakter stat yönetimi bulunur. Karakter statları çevrimdışı kaydedilir ve sonraki girişte uygulanır. Hikâye sinematiğinin kaldırılması kullanıcı tarafından temiz açılışla doğrulandı.

## Aktarım kapsamı

`AKTARIM_OZETI.json` dosya sayılarını ve erişilemeyen dosyaları belirtir. Çalışan oyun klasörü yerinde korunmuştur. Gizli hesap dosyaları, kayıtlı SQL şifreleri, özel makine başlığı, kişisel çalışma günlükleri ve yeniden üretilebilir derleme/ortam önbellekleri aktarılmadı. Diğer kopyalanan dosyalardaki yerel test parolası yer tutucuyla değiştirildi. Yapılandırma şifre alanları depodaki kopyada boş bırakıldı.

Üçüncü taraf kaynakların mevcut lisans ve atıfları korunur; bu depo bunların lisansını değiştirmez. Tam USKO oran/özellik eşitliği doğrulanmış değildir; ilgili denetim raporları klasörlerde bulunur.

Windows güvenlik denetiminin engellediği eski Gamesoft referans EXE’sinin iki kopyası aktarım dışında tutuldu. Etkin `11_Istemci_Uyumluluk/Gamesoft_Yerel/KnightOnLine.exe` istemcisi dahildir. Ayrıntı `AKTARIM_OZETI.json` içindedir.
