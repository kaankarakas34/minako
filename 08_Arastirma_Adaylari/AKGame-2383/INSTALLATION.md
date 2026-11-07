# Installation Guide / Kurulum Dokumani

## Turkce Kurulum

### 1. Gereksinimler

- Windows 10/11 veya Windows Server.
- Microsoft SQL Server 2022 Express, Developer, Standard veya daha yeni surum.
- SQL Server Management Studio (SSMS).
- ODBC Data Source Administrator.
- Bu paket klasoru: `C:\KnightOnline\github` veya kendi sectiginiz kurulum yolu.

Bu paketteki yeni yedekler SQL Server 2022 Express uzerinde alinmistir:

- `Database/Backups/KO_DATABASE_SERVER_001_github_local_20260730_021838.bak`
- `Database/Backups/KO_LOG_github_local_20260730_021838.bak`

### 2. SQL Server Kurulumu

SQL Server 2022 Express veya Developer surumunu kurun. Kurulumdan sonra SQL Server servisinin calistigindan emin olun.

Yerel instance icin ornek baglanti:

```powershell
sqlcmd -S localhost -E -Q "SELECT @@VERSION;"
```

### 3. Database Restore

SSMS veya `sqlcmd` ile asagidaki komutlari calistirin. Paket yolunu farkli kullaniyorsaniz `.bak` yollarini guncelleyin.

```sql
RESTORE DATABASE [KO_DATABASE_SERVER_001]
FROM DISK = N'C:\KnightOnline\github\Database\Backups\KO_DATABASE_SERVER_001_github_local_20260730_021838.bak'
WITH
  MOVE N'KO_DATABASE_SERVER_001' TO N'C:\SQLData\KO_DATABASE_SERVER_001.mdf',
  MOVE N'KO_DATABASE_SERVER_001_log' TO N'C:\SQLData\KO_DATABASE_SERVER_001_log.ldf',
  REPLACE,
  RECOVERY;

RESTORE DATABASE [KO_LOG]
FROM DISK = N'C:\KnightOnline\github\Database\Backups\KO_LOG_github_local_20260730_021838.bak'
WITH
  MOVE N'KO_LOG' TO N'C:\SQLData\KO_LOG.mdf',
  MOVE N'KO_LOG_log' TO N'C:\SQLData\KO_LOG_log.ldf',
  REPLACE,
  RECOVERY;
```

`C:\SQLData` klasoru yoksa restore oncesinde olusturun.

### 4. SQL Login ve Yetkiler

Config dosyalarinda varsayilan SQL kullanicisi su sekildedir:

- ODBC SQL kullanicisi: `akgame` / `akgame`

Asagidaki SQL komutlari varsayilan config ile uyumludur. Public ortamda kullanmadan once sifreleri degistirmeniz onerilir.

```sql
USE [master];

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'akgame')
  CREATE LOGIN [akgame] WITH PASSWORD = N'akgame', CHECK_POLICY = OFF;

USE [KO_DATABASE_SERVER_001];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'akgame')
  CREATE USER [akgame] FOR LOGIN [akgame];
ALTER ROLE [db_owner] ADD MEMBER [akgame];

USE [KO_LOG];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'akgame')
  CREATE USER [akgame] FOR LOGIN [akgame];
ALTER ROLE [db_owner] ADD MEMBER [akgame];
```

### 5. ODBC DSN Ayarlari

Server dosyalari x64 olarak calistigi icin 64-bit ODBC yoneticisini acin:

```text
C:\Windows\System32\odbcad32.exe
```

System DSN olarak su DSN kayitlarini olusturun:

- `KO_MAIN` -> `KO_DATABASE_SERVER_001`
- `KO_GAME` -> `KO_DATABASE_SERVER_001`
- `KO_LOG` -> `KO_LOG`

SQL Server Authentication kullanin:

- `KO_MAIN`, `KO_GAME` ve `KO_LOG`: `akgame` / `akgame`

### 6. Local IP Ayarlari

Paket hazir olarak localhost ayarlidir:

- `Server/GameServer.ini`: `LOGIN_IP=127.0.0.1`, `SERVER_IP_00=127.0.0.1`
- `Server/LogInServer.ini`: `URL=127.0.0.1`
- `Client/Server.ini`: `IP0=127.0.0.1`

Tek bilgisayarda calistiracaksaniz bu ayarlari degistirmeniz gerekmez.

### 7. Server Calistirma Sirasi

1. SQL Server servisinin calistigindan emin olun.
2. `Server/LogInServer.exe` dosyasini calistirin.
3. `Server/GameServer.exe` dosyasini calistirin.
4. Client tarafinda `Client/Launcher.exe` dosyasini calistirin.
5. Gerekirse dogrudan `Client/KnightOnLine.exe` ile test edin.

### 8. Portlar

Varsayilan portlar:

- Login Server public port: `15100`
- Game server login baglanti portu: `13001`
- Game Server portu: `15572`

Sadece lokal test icin firewall acmaniz gerekmez. Baska bilgisayarlardan baglanti verecekseniz IP ve firewall ayarlarini ayrica yapmalisiniz.

### 9. Notlar

- Bu paket runtime, client ve database icerir. `Source` klasoru bu paket icinden kaldirilmistir.
- Bot ayarlari `Server/GameServer.ini` icindeki `BOT_SETTINGS` bolumunden kontrol edilir. Varsayilan pakette `AUTO_MINING_BOTS=0` olarak gelir.
- YouTube video linki `README.md` dosyasinin en ustune eklenmistir.
- Gelistirme, destek veya ozel talepler icin `hello@halilcan.dev` adresinden iletisime gecebilirsiniz.

---

## English Installation

### 1. Requirements

- Windows 10/11 or Windows Server.
- Microsoft SQL Server 2022 Express, Developer, Standard or newer.
- SQL Server Management Studio (SSMS).
- ODBC Data Source Administrator.
- This package folder: `C:\KnightOnline\github` or your own installation path.

The fresh backups in this package were created on SQL Server 2022 Express:

- `Database/Backups/KO_DATABASE_SERVER_001_github_local_20260730_021838.bak`
- `Database/Backups/KO_LOG_github_local_20260730_021838.bak`

### 2. Install SQL Server

Install SQL Server 2022 Express or Developer edition. Make sure the SQL Server service is running.

Example local connection test:

```powershell
sqlcmd -S localhost -E -Q "SELECT @@VERSION;"
```

### 3. Restore Databases

Run the following commands in SSMS or with `sqlcmd`. If you use a different package path, update the `.bak` paths.

```sql
RESTORE DATABASE [KO_DATABASE_SERVER_001]
FROM DISK = N'C:\KnightOnline\github\Database\Backups\KO_DATABASE_SERVER_001_github_local_20260730_021838.bak'
WITH
  MOVE N'KO_DATABASE_SERVER_001' TO N'C:\SQLData\KO_DATABASE_SERVER_001.mdf',
  MOVE N'KO_DATABASE_SERVER_001_log' TO N'C:\SQLData\KO_DATABASE_SERVER_001_log.ldf',
  REPLACE,
  RECOVERY;

RESTORE DATABASE [KO_LOG]
FROM DISK = N'C:\KnightOnline\github\Database\Backups\KO_LOG_github_local_20260730_021838.bak'
WITH
  MOVE N'KO_LOG' TO N'C:\SQLData\KO_LOG.mdf',
  MOVE N'KO_LOG_log' TO N'C:\SQLData\KO_LOG_log.ldf',
  REPLACE,
  RECOVERY;
```

Create `C:\SQLData` before restoring if it does not exist.

### 4. SQL Logins And Permissions

The default SQL user in the configuration files is:

- ODBC SQL user: `akgame` / `akgame`

The following SQL commands match the default configuration. Change passwords before using the package outside local testing.

```sql
USE [master];

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'akgame')
  CREATE LOGIN [akgame] WITH PASSWORD = N'akgame', CHECK_POLICY = OFF;

USE [KO_DATABASE_SERVER_001];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'akgame')
  CREATE USER [akgame] FOR LOGIN [akgame];
ALTER ROLE [db_owner] ADD MEMBER [akgame];

USE [KO_LOG];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'akgame')
  CREATE USER [akgame] FOR LOGIN [akgame];
ALTER ROLE [db_owner] ADD MEMBER [akgame];
```

### 5. ODBC DSN Settings

The server executables are x64, so open the 64-bit ODBC administrator:

```text
C:\Windows\System32\odbcad32.exe
```

Create these System DSNs:

- `KO_MAIN` -> `KO_DATABASE_SERVER_001`
- `KO_GAME` -> `KO_DATABASE_SERVER_001`
- `KO_LOG` -> `KO_LOG`

Use SQL Server Authentication:

- `KO_MAIN`, `KO_GAME` and `KO_LOG`: `akgame` / `akgame`

### 6. Local IP Settings

The package is already configured for localhost:

- `Server/GameServer.ini`: `LOGIN_IP=127.0.0.1`, `SERVER_IP_00=127.0.0.1`
- `Server/LogInServer.ini`: `URL=127.0.0.1`
- `Client/Server.ini`: `IP0=127.0.0.1`

No change is needed for single-machine local testing.

### 7. Startup Order

1. Make sure SQL Server is running.
2. Start `Server/LogInServer.exe`.
3. Start `Server/GameServer.exe`.
4. Start `Client/Launcher.exe`.
5. If needed, test directly with `Client/KnightOnLine.exe`.

### 8. Ports

Default ports:

- Login Server public port: `15100`
- Game server login connection port: `13001`
- Game Server port: `15572`

Firewall changes are usually not required for local-only testing. If other computers will connect, update IP and firewall settings separately.

### 9. Notes

- This package contains runtime, client and database files. The `Source` folder was removed from this package.
- Bot settings are controlled from the `BOT_SETTINGS` section in `Server/GameServer.ini`. The default package ships with `AUTO_MINING_BOTS=0`.
- The YouTube video link is included at the top of `README.md`.
- For development, support or custom requests, contact `hello@halilcan.dev`.
