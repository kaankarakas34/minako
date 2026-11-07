# GitHub genişletilmiş eksik dosya araştırması

Tarih: 4 Kasım 2026. Ana oyun klasörlerine ve SQL şema/verisine değişiklik uygulanmadı.

## Sonuç

**Eksik SQL prosedürünün yayınlanmış tanımı bulundu. Lua tarafında ise dosya adı kapsamı çok arttı; tam çalışan görev kapsamı henüz doğrulanmadı.**

| Aranan | Bulgu | Kurulum açısından anlamı |
| --- | --- | --- |
| `UPDATE_ALL_CHAR_ID` | TemuKO POSIX deposunda gerçek `CREATE PROCEDURE` tanımı | Yerel alanlar ve beş parametreli sunucu çağrısıyla arayüzü örtüşüyor; henüz kurulmadı/test edilmedi |
| Önceki 183 eksik Lua adı | Rust deposunda 182 tam ad eşleşmesi | 180 dosya yalnızca `SearchQuest` / `SelectMsg` / `NpcMsg` yönlendirmesi; iki dosyada otomatik üretilmiş ek olay kodları var |
| `29516_iruta.lua` | İncelenen setlerde tam ad yok | `25177_iruta.lua` farklı NPC'ye ait; doğrudan yeniden adlandırılamaz |
| 12 uzantısız SQL referansı | Her biri için aynı numara önekli, daha uzun ad taşıyan adaylar | Örneğin `25163_Rea` → `25163_Rea_k.lua`; isim eşlemesi ve davranış doğrulaması gerekiyor |
| Önceki sayımlardaki boş dosyalar | İlk iki kaynakta 285 ad eşleşmesinin 8'i yalnızca boş dosya | Sayım düzeltmesi: içerik taşıyan ad 277; boş dosyaları çözülmüş eksik saymıyoruz |

Rust deposu dahil indirilen tüm setlerde, özgün 468 eksik Lua adının **467'si için ad eşleşmesi** var. Bu sayı 467 görevin onarıldığı anlamına gelmez. Başlangıç yönlendirmesi sonrasında gereken kabul/tamamlama/ödül kodları birçok yeni adayda yok. Ayrıca bu kaynak Rust, PostgreSQL ve v2603 istemciyi hedefliyor; elimizdeki C++ / MSSQL sunucusuna doğrudan uyum iddiası yok.

## 1. Bulunan SQL prosedürü

[Kaynak tanım, satır 7020](https://github.com/luisfelipe18/temuko-posix/blob/af34b1131c21b42d1949d2a63d689165b812103d/Database/KO_DATABASE_SERVER_001_SPs.sql#L7020).

Commit: `af34b1131c21b42d1949d2a63d689165b812103d`.

Yerel referans: `08_Arastirma_Adaylari/SQL_Referans/UPDATE_ALL_CHAR_ID.sql`. Yalnızca ilgili prosedür çıkarıldı; bütün alternatif veritabanı betiği uygulanmadı.

| Parametre | Yayınlanan tür | Yerel `ACCOUNT_CHAR` alanı |
| --- | --- | --- |
| `@strAccountID` | `varchar(21)` | `strAccountID char(21)` |
| `@strCharID1`–`@strCharID4` | `char(21)` | Aynı adlı dört `char(21)` alan |

Prosedür, hesap kimliği ile eşleşen `ACCOUNT_CHAR` kaydının dört karakter alanını güncelliyor. Önceden incelenen hazır EXE çağrısı da beş giriş parametreli. Tip/uzunluk arayüzü makul şekilde örtüşüyor; bu, işleyişinin test edildiği anlamına gelmiyor. Son salt okunur kontrolde `KNIGHT_24XX_TEST` içinde bu prosedür hâlâ yok; kurulum yapılmadı.

## 2. Yeni Lua kaynağı

[derdems44/KORustGameServer](https://github.com/derdems44/KORustGameServer/tree/5ee5b737a42f87ccb951ac54ff5eaa4007820902/Quests).

Commit: `5ee5b737a42f87ccb951ac54ff5eaa4007820902`. Yerel kopya: `08_Arastirma_Adaylari/KORust-Inceleme`.

Depo ağacında 845 Lua yolu var; ana `Quests` klasöründe 841 dosya bulunuyor. Özgün 468 eksik ada karşılık 467 dosya ana klasörde mevcut. Önceki 183 adın 182'si bu sette var ve bu 182 dosya Lua 5.2 sözdizimi kontrolünden geçti. Kodlar çalıştırılmadı.

- 180 yeni eşleşme, yalnızca başlangıç `SearchQuest` yönlendirmesi içeriyor. Atanan `QuestNum` için sonraki olaylar aynı dosyada bulunmuyor. Salt diyalog NPC'si için yeterli olabilse de tamamlanabilir görev kanıtı değil.
- Diğer ikisi `29084_Ballen.lua` ve `29161_Snebeker.lua`; dosyalardaki `[AUTO-GEN]` işaretleri ek olayların otomatik üretildiğini gösteriyor. Görev kimlikleri ve davranışı yerel veritabanıyla ayrıca doğrulanmalı.
- Önceki setlerde yalnızca boş dosya olarak bulunan 8 ad da bu depoda kod içeriyor. İki altar dosyası yalnızca `SearchQuest` çağırıyor. Kalan altısında otomatik üretilmiş olaylar ve mevcut TemuKO global tablosunda aynı adla bulunmayan `ExistMonsterQuestSub` çağrıları var. Bunlar da hazır onarım olarak sayılmadı.
- `29499_karu.lua` için eski setlerdeki `29499_ParadisE.lua` aynı NPC numaralı bir adayı oluşturuyor. İncelenen alternatifte doğrudan eşya veren özel menüler var; yalnızca isim değiştirerek kullanmak doğru değil.
- `29516_iruta.lua` yerine bulunan `25177_iruta.lua`, NPC 25177'yi ve farklı özel eşya menülerini kullanıyor; NPC 29516'nın görevini karşıladığı doğrulanmadı.

## 3. Uzantısız 12 referans

Yeni kaynakta aynı NPC numarasıyla aşağıdaki adaylar var. Hiçbiri SQL'deki kısa adla birebir dosya değil; SQL'e veya dosya adlarına otomatik değişiklik yapılmadı.

| SQL referansı | Aday |
| --- | --- |
| `25075_2` | `25075_2_Prison1.lua` |
| `25076_2` | `25076_2_Prison2.lua` |
| `25077_2` | `25077_2_Prison3.lua` |
| `25078_2` | `25078_2_Prison4.lua` |
| `25079_2` | `25079_2_Prison5.lua` |
| `25080_1` | `25080_1_Prison1.lua` |
| `25081_1` | `25081_1_Prison2.lua` |
| `25082_1` | `25082_1_Prison3.lua` |
| `25083_1` | `25083_1_Prison4.lua` |
| `25084_1` | `25084_1_Prison5.lua` |
| `25163_Rea` | `25163_Rea_k.lua` |
| `25167_Magaret` | `25167_Magaret_k.lua` |

Prison adayları kısa diyalog metinleri içeriyor. Rea ve Magaret daha kapsamlı görev kodları taşıyor. Aynı NPC numarası, görev durumları ve ödüllerinin aynı olduğunu kanıtlamaz.

## 4. Diğer taramalar ve kapsam sınırı

Bu turda 27 farklı depo sorgulandı: 24'ünün tam dosya ağacı alındı; iki Resurrected deposunda büyük ağaç hatası nedeniyle kök ve ilgili alt klasörler incelendi. `volkanisbilen/RST26` GitHub API'sinde 404 döndü; taranmış sayılmadı. Repo keşfi, kod araması, Lua dosya adı karşılaştırması, NPC numarası önekleri ve SQL betikleri birlikte kullanıldı. Tüm GitHub'ın veya bütün branch/tarihçelerin tarandığı iddia edilmiyor.

`OrcunEryurekliler/KO-24xx-Server` içinde `31527_ChBox.lua`–`31530_ChBox.lua` adları bulundu, fakat dördü de 0 bayt. Ayrı aday klasörüne alınan bu set ek çalışan görev sağlamadı. Rust deposundaki aynı adlı dosyalar da yalnızca başlangıç yönlendirmeleri içeriyor.

TemuKO, 22xx ve Orcun depolarının sürüm yayınlarında ayrıca indirilebilir bir release paketi yoktu. Diğer bazı depolar yalnızca kaynak kod, eski sürüm Lua seti veya ilgisiz editörler içeriyordu. Tam ağaç kontrollerinde yeni ad sağlamayan depolar `github-genis-tarama.json` içinde commit ve dosya yollarıyla kayıtlı.

## Kanıtlar

- `github-genis-tarama.json`: taranan depolar, commitler, Lua/SQL yolları ve ilk 183 ad.
- `github-ek-bulgular.json`: Rust dosya ağacı, 12 referansın adayları, bulunan SQL tanımı ve kaynak satırı.
- `github-rust-gorev-kontrolu.csv`: 467 dosyanın kaynak URL'si, SHA-256 özeti, sözdizimi ve yönlendirme kontrolü.
- `github-rust-gorev-ozeti.json`: 182 yeni eşleşmenin 180 yönlendirme / 2 ek olay kodu ayrımı.
- `alternatif-lua-dosya-kontrolu.csv`: eski sunucu setlerindeki 989 eşleşen sürüm yolu; 289 adın yalnızca 277'si için boş olmayan kod var.
- `alternatiflerde-kodlu-dosyasi-bulunamayan-lua.csv`: eski setlerde kodlu karşılığı olmayan 191 ad; Rust setinin içerik niteliği ayrı raporlanmıştır.

Kullanılan kontrol araçları yalnızca dosya okur ve Lua kodunu derleyerek sözdizimini denetler; üretilen fonksiyonları çağırmaz. Ana sunucu EXE'leri, oyun INI'leri ve SQL verileri bu araştırmada değiştirilmedi.
