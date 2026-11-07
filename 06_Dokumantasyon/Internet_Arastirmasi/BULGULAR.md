# Eksik Knight Online dosyaları — internet araştırması

Araştırma tarihi: 4 Kasım 2026.

**Güncel sonuç: eksik SQL prosedürünün yayınlanmış tanımı bulundu. İndirilen tüm setlerde 468 eksik Lua adının 467'si için ad eşleşmesi var; fakat yeni 182 eşleşmenin 180'i yalnızca başlangıç yönlendirmesi içeriyor.** Bu nedenle görevlerin tamamlandığı veya paketin kuruluma hazır olduğu söylenemez. Dosyalar ayrı inceleme klasörlerinde; ana sunucu ve SQL değiştirilmedi. Tam adla bulunamayan Lua: `29516_iruta.lua`. Uzantısız 12 kayıt için daha uzun dosya adlarıyla adaylar bulundu.

**Genişletilmiş araştırma ve sayım düzeltmeleri:** [GITHUB_GENIS_TARAMA.md](GITHUB_GENIS_TARAMA.md). İlk iki kaynakta bildirilen 285 sayısı dosya adı eşleşmesiydi; içerik kontrolünde bu adların 8'inin yalnızca boş dosya olduğu görüldü. Kod içeren karşılık sayısı o aşama için 277. Boş dosya ve yalnızca yönlendirme içeren adaylar çalışır görev sayılmadı.

## İlk iki açık alternatif — araştırmanın önceki aşaması

| Kaynak | İncelenen klasör | Lua dosyası | 468 eksik adla eşleşen ad |
| --- | --- | ---: | ---: |
| [AK Game 2383](https://github.com/halilcanakcay/knight-online-server-files-2383) | `Server/Quests` | 505 | 236 |
| [22xx FilesKoRelease](https://github.com/omeraraz22/22xx-FilesKoRelease) | `Quests` | 458 | 212 |
| Aynı 22xx deposunun eski seti | `OldQuests` | 570 | 263 |

Birleşimde 285 farklı eksik ad var. Aynı dosyanın farklı sürümleri dahil 711 eşleşen dosya yolu incelendi. Kaynak commitleri sırasıyla `cfec765ff19d58a1b9a8ae07bcedcd7bf72f0ece` ve `ad45c5d707a1506e8f48532124573bdf2bc2d92d`. İndirilen kopyalar `08_Arastirma_Adaylari/AKGame-2383` ve `08_Arastirma_Adaylari/22xx-FilesKoRelease` altında. GitHub bağlayıcısı dosya ağacı ve metin incelemesinde kullanıldı; ikili indirme desteği olmadığından klasörler Git ile kısmi olarak indirildi. Git çalışma kopyalarında kök seviyedeki bazı ek dosyalar da bulunur; bunlar çalıştırılmadı.

`31567_Fellor.lua`, `29193_Dolkin.lua` ve `19063_NewAdven.lua` gibi somut eksikler bulundu. Bu iki depodan farklı olarak `xHaplo/22xx-FilesKoRelease` ağacı da kontrol edildi; ek eksik ad sağlamadı, indirilmedi.

### Kontroller ve sınırları

- Lua 5.2 ile yalnızca derleme/sözdizimi kontrolü yapıldı; aday Lua kodu çalıştırılmadı. TemuKO'nun `luaL_loadfile` davranışına uygun olarak UTF-8 BOM, yalnızca kontrol girdisinden atlandı; aday dosya değiştirilmedi.
- 711 sürümün 708'i sözdizimi kontrolünü geçti. `OldQuests` içindeki `25005_Earth.lua`, `25019_Mars.lua`, `25178_Rogos_M.lua` hata verdi. Bu üç ad için diğer setlerde geçen sürümler var; böylece 285 adın tamamı için geçen en az bir sürüm mevcut.
- 278 ad için sözdizimi geçen ve TemuKO kaynak kodunun global fonksiyon listesinde bulunmayan bir çağrı tespit edilmeyen en az bir sürüm var. Bu, hazır GameServer.exe uyumluluğunu kanıtlamaz: kaynak 2239 ile hazır sunucunun aynı derleme olduğu doğrulanmadı.
- `QuestMonsterCount`, `SendNpcKillID`, `NpcKillID`, `SendSiegeKickOut`, `isOwner`, `JobGroupCheck` çağrıları bazı sürümlerde mevcut kaynak kodun global kayıt tablosunda bulunamadı. Karşılaştırma metin tabanlı ön kontroldür.
- Yerel SQL'deki NPC ve ITEM_EXCHANGE kimlikleri ile görev tetikleme/tamamlama numaraları karşılaştırıldı. Bazı sürümlerde farklar var. Dosya adı eşleşmesi; ödülleri, görev akışını, istemci metinlerini veya istismar dayanıklılığını doğrulamaz. Toplu kopyalama yapılmadı.
- Yalnızca bağımsız kontrol aracı için `06_Dokumantasyon/Araclar/lua-audit-venv` içine Lupa 2.8 kuruldu; oyun bağımlılığı olarak sunulmadı.

Kanıtlar: `alternatif-lua-ozeti.json`, `alternatif-lua-dosya-kontrolu.csv` (dosya yolu, kaynak URL, commit, SHA-256 ve kontrol sonuçları), `alternatiflerde-bulunamayan-lua.csv` (183 ad). Tekrar çalıştırılabilir araç: `06_Dokumantasyon/Araclar/alternatif-lua-kontrol.py`.

## Öncelikli kaynaklar

### 1. Ko-Yardım: v24XX Lua & Map, SexyKo uyumlu

[Paylaşım sayfası](https://ko-yardim.com/konu/v24xx-lua-map-sexyko-uyumlu-100-sorunsuz.47/).

Yayıncı, görevler ve ek haritalar içeren bir paket sunduğunu; kaynak tarafında uyarlama gerekebileceğini belirtiyor. Başlığın 24xx olması tek başına mevcut sunucu ile uyumu kanıtlamıyor. İlk incelemede oturum açık değildi. Kullanıcı giriş yaptıktan sonra sayfa yeniden kontrol edildi: hesap e-posta onayı bekliyor; bağlantı ve parola ayrıca konuya yanıt/beğeni şartıyla gizlenmiş. Bu forumdan dosya indirilmedi, arşivin güncel erişilebilirliği ve içeriği doğrulanamadı. Kullanıcı adına mesaj veya beğeni gönderilmedi.

Mevcut paketin açıklama dosyasında aynı forumun adı bulunduğundan bu kaynak öncelikli bir aday. Aynı dosyalar olduğunu kanıtlayan yayıncı özeti veya checksum bulunmadı.

### 2. Ko-Yardım: Server Files / Database / Patch 24xx

[Paylaşım sayfası](https://ko-yardim.com/konu/server-files-database-patch-24xx-ko-yardim-paylasimi.52/).

27 Aralık 2020 tarihli paylaşım, sunucu, veritabanı ve yama içerdiğini söylüyor. Bu tarih ve içerik, yerel paketteki paylaşım notlarıyla tutarlı. İndirme bağlantısı ve parola üyelik arkasında. Bunun elimizdeki arşivin aynısı veya tamamlayıcı güncellemesi olduğu henüz dosya karşılaştırmasıyla doğrulanmadı.

### 3. Ko-Cuce: StoneSoft / ArtyGuard 24xx

[Paylaşım sayfası](https://www.ko-cuce.net/konular/stonesoft-artyguard-server-files-source-v24xx-database-lua-acs-artygame.80306/).

Yayıncı kaynak kod, database, Lua/Map ve sunucu bileşenlerini listeliyor. İndirme bağlantıları üyeler için gizlenmiş. Mevcut paketle uyumlu bir onarım seti olduğu doğrulanmadı; ayrı bir sunucu tabanı adayı olarak değerlendirilmeli.

## Açık GitHub depolarının karşılaştırılması

Eksik dosya listemizdeki 468 `.lua` adı, her deponun dosya ağacındaki dosya adlarıyla büyük/küçük harf duyarsız karşılaştırıldı. Tablodaki sayı Lua dosya yollarının sayısıdır; aynı deponun farklı klasörlerinde kopyalar bulunabilir.

| Depo | Lua dosya yolu | Eksik adlarla tam eşleşme |
| --- | ---: | ---: |
| [CihanAksoy/KOServer](https://github.com/CihanAksoy/KOServer) | 124 | 0 |
| [Ernosto/KOServer](https://github.com/Ernosto/KOServer) | 124 | 0 |
| [RBACS/KnightOnline-Projectv1886](https://github.com/RBACS/KnightOnline-Projectv1886) | 126 | 0 |
| [nathank33/KOServer](https://github.com/nathank33/KOServer) | 742 | 0 |
| [yfz912/Knight-Online-Project](https://github.com/yfz912/Knight-Online-Project) | 273 | 0 |

Commit kimlikleri `kaynak-karsilastirma.json` içinde. Sonuç, bu beş depoda tam dosya adı eşleşmesi bulunamadığını gösterir; internetin tamamında dosyaların bulunmadığı anlamına gelmez. Sadece ada bakarak farklı bir görev dosyası aynı adla kopyalanmadı.

## Eksik SQL işlemi için bulunan kanıt

[2083 kaynak sürümü](https://github.com/nathank33/KOServer/blob/95e7942926653dd306947cb147a10ea75c383064/Source/shared/version.h), [SetAllCharID çağrısı](https://github.com/nathank33/KOServer/blob/95e7942926653dd306947cb147a10ea75c383064/Source/GameServer/DBAgent.cpp#L140).

Bu kaynakta `UPDATE_ALL_CHAR_ID` beş giriş parametresiyle çağrılıyor: hesap kimliği ve dört karakter kimliği. Bu, hazır GameServer.exe içinde daha önce bulunan beş parametreli çağrıyla aynı arayüzde.

Yerel test veritabanının `ACCOUNT_CHAR` tablosunda `strAccountID` ve `strCharID1`–`strCharID4` alanlarının `char(21)` olduğu ayrıca doğrulandı. İlk aşamada yalnızca çağrı kanıtı vardı. Genişletilmiş taramada [TemuKO POSIX içindeki tanım](https://github.com/luisfelipe18/temuko-posix/blob/af34b1131c21b42d1949d2a63d689165b812103d/Database/KO_DATABASE_SERVER_001_SPs.sql#L7020) bulundu ve `08_Arastirma_Adaylari/SQL_Referans/UPDATE_ALL_CHAR_ID.sql` dosyasına ayrıldı. Parametre arayüzü örtüşüyor; veritabanına uygulanmadı ve işlem testi yapılmadı.

## Tarayıcı kontrolü

PvPers'teki mevcut TemuKO oturumu incelendi. TemuKO indirme bağlantısı, kullanıcının zaten açık tuttuğu Yandex kaynak arşivine gidiyor; bu, mevcut kaynak kodun tekrar indirilmesi anlamına gelebilir ve eksik görevleri tamamladığı gösterilmedi. PvPers başlık aramasında görev sorgusu ağırlıklı olarak başka oyunun içeriklerini getirdi; bunlar Knight Online adayı sayılmadı. Forumlara mesaj/yorum gönderilmedi ve hesap oluşturulmadı.

## Sonraki somut adım

İndirilen adaylarda doğru sürümler seçilip kullanılacak tek bir sunucu/veritabanı/istemci tabanında görev akışı ve ödüller doğrulanmalı. Başlangıç yönlendirmesi içeren 180 yeni dosyanın gerekli olayları incelenmeli; otomatik üretilmiş kodlar uyarlanmadan kullanılmamalı. SQL prosedürü ayrı test edilerek kurulabilir. Ko-Yardım erişimi artık bu adayları incelemek için zorunlu değil. Kuruluma hazır olduğu doğrulanmış birleşik bir görev paketi henüz oluşturulmadı.
