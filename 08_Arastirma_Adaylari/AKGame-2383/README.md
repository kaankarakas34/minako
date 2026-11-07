# Ak Game / Knight Online Server Files

## YouTube Video

[![AK Game gameplay and bot showcase](https://img.youtube.com/vi/xWWO_55ev5A/maxresdefault.jpg)](https://www.youtube.com/watch?v=xWWO_55ev5A&t=91s)

> Turkish and English documentation are included below.

## Turkce

Bu paket, AK Game / Knight Online tarzi MMORPG sunucu-client calisma paketidir. Mevcut calisan dosyalar bozulmadan GitHub icin ayri bir lokal paket olarak hazirlanmistir.

Paket 127.0.0.1 uzerinden lokal bilgisayarda calismaya gore ayarlanmistir. Login server, game server, launcher ve client tarafindaki bilinen IP ayarlari localhost olarak duzenlenmistir.

### Icerik

- `Server/`: `LogInServer.exe`, `GameServer.exe`, map dosyalari, quest dosyalari ve server ayarlari.
- `Client/`: oyun client dosyalari, launcher, ACS dll ve client kaynaklari/assets.
- `Database/`: ana database yedekleri.
- `Database/Backups/`: GitHub paketi icin alinmis taze SQL backup dosyalari.
- `INSTALLATION.md`: Turkce ve Ingilizce kurulum dokumani.

### Oyun Hakkinda

Bu paket 2383 client dosya versiyonu ve 2369 include exe ayarlariyla hazirlanmis lokal calisma paketidir. Icerikte oyun girisi, karakter/zone akisi, haritalar, questler, merchant ve oyun ici etkinlik sistemlerine ait server-client dosyalari bulunur.

Sunucu tarafinda Login Server ve Game Server ayri calisir. Client tarafinda Launcher ve `KnightOnLine.exe` dosyalari kullanilir. Paket varsayilan olarak tek makinede test, gelistirme ve lokal sunucu kurulumu icin hazirlanmistir.

### Bot Sistemleri

Projede oyun ekonomisini ve test sureclerini desteklemek icin bot altyapilari bulunur. Server ayarlarinda `BOT_SETTINGS` bolumu altinda `AUTO_MINING_BOTS` ayari yer alir. Bu ayar, otomatik mining bot davranislarini kontrol etmek icin kullanilir.

Merchant, etkinlik ve oyun ici sistemlerle birlikte bot altyapisi; lokal testlerde oyuncu hareketliligini, pazar/ekonomi denemelerini ve server davranislarini daha rahat gozlemlemek icin tasarlanmistir. Bot sistemleriyle ilgili gelistirme, ozellestirme veya yeni bot senaryolari icin benimle iletisime gecebilirsiniz.

### Neler Yapiyorum

Bu proje uzerinde calisan server-client paketleri hazirliyor, lokal veya ozel sunucu kurulumlari icin gerekli ayarlari duzenliyorum. Amacim sadece dosyalari paylasmak degil, calisabilir ve gelistirilebilir bir oyun ortami sunmak.

Yaptigim baslica isler:

- Game Server, Login Server, Launcher ve Client dosyalarini lokal veya ozel IP yapisina gore ayarlamak.
- SQL Server database yedeklerini hazirlamak, restore surecini dokumante etmek ve ODBC baglantilarini duzenlemek.
- Bot sistemleri, mining botlari, merchant/ekonomi testleri ve oyun ici aktivite senaryolari uzerinde gelistirme yapmak.
- Quest, event, drop, exp, item, merchant ve oyun ici sistemlerde dengeleme ve ozellestirme yapmak.
- Client tarafinda launcher, ACS, UI, video/gorsel paketleri ve local test dosyalarini hazirlamak.
- Hata cozumu, performans iyilestirme, kurulum destegi ve yeni ozellik gelistirmeleri icin destek vermek.

Gelistirme, ozel sistem talepleri, bot senaryolari veya proje destegi icin benimle iletisime gecebilirsiniz.

### Gerekli SQL Server Surumu

Bu paketteki taze `.bak` dosyalari `Microsoft SQL Server 2022 Express 16.0.1000.6` uzerinde alinmistir.

Onerilen surum: **SQL Server 2022 Express, Developer, Standard veya daha yeni bir SQL Server surumu**.

Not: SQL Server backup dosyalari genellikle daha eski SQL Server surumlerine restore edilemez. Bu nedenle SQL Server 2019 veya daha eski surumler bu `.bak` dosyalari icin onerilmez.

### Kurulum

Detayli kurulum icin [INSTALLATION.md](INSTALLATION.md) dosyasina bakin.

### Iletisim

Gelistirme, ozel istekler, hata bildirimi veya proje destegi icin benimle iletisime gecin:

- Email: `hello@halilcan.dev`
- GitHub Issues: Bu repoda issue acabilirsiniz.

---

## English

This package is a local AK Game / Knight Online style MMORPG server-client runtime package. It was prepared as a separate GitHub-ready local copy without modifying the currently working server and client folders.

The package is configured to run on the local computer through `127.0.0.1`. Known Login Server, Game Server, Launcher, ACS and Client IP settings were adjusted for localhost.

### Contents

- `Server/`: `LogInServer.exe`, `GameServer.exe`, map files, quest files and server configuration.
- `Client/`: game client files, launcher, ACS dll and client assets.
- `Database/`: main database backup files.
- `Database/Backups/`: fresh SQL backups created for this GitHub package.
- `INSTALLATION.md`: Turkish and English installation guide.

### About The Game

This package is prepared with client file version `2383` and include exe version `2369`. It contains server-client files for login flow, character and zone flow, maps, quests, merchant systems and in-game event systems.

The server side runs with separate Login Server and Game Server executables. The client side uses the Launcher and `KnightOnLine.exe`. By default, this package is intended for single-machine local testing, development and private local server setup.

### Bot Systems

The project includes bot infrastructure to support game economy testing and server behavior testing. In the server configuration, the `BOT_SETTINGS` section includes the `AUTO_MINING_BOTS` option, which controls automatic mining bot behavior.

Together with merchant, event and in-game systems, the bot infrastructure helps simulate activity during local tests, observe market/economy behavior and test server-side flows more comfortably. For bot development, customization or new bot scenarios, contact me.

### What I Do

I prepare working server-client packages for this project and configure them for local or private server environments. The goal is not only to share files, but to provide a runnable and customizable game setup.

Main areas I work on:

- Configuring Game Server, Login Server, Launcher and Client files for local or custom IP setups.
- Preparing SQL Server database backups, documenting restore steps and configuring ODBC connections.
- Developing bot systems, mining bots, merchant/economy tests and in-game activity scenarios.
- Customizing and balancing quests, events, drops, experience, items, merchant systems and gameplay flows.
- Preparing client-side launcher, ACS, UI, video/visual assets and local test files.
- Providing bug fixing, performance improvements, setup support and custom feature development.

For development, custom systems, bot scenarios or project support, contact me.

### Required SQL Server Version

The fresh `.bak` files in this package were created on `Microsoft SQL Server 2022 Express 16.0.1000.6`.

Recommended version: **SQL Server 2022 Express, Developer, Standard or any newer SQL Server version**.

Note: SQL Server backup files usually cannot be restored to older SQL Server versions. SQL Server 2019 or older is therefore not recommended for these `.bak` files.

### Installation

See [INSTALLATION.md](INSTALLATION.md) for the full setup guide.

### Contact

For development, custom work, bug reports or project support, contact me:

- Email: `hello@halilcan.dev`
- GitHub Issues: You can open an issue in this repository.
