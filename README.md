# Minako GM paneli

GM panelinin kaynakları `14_GM_Admin_Paneli` klasöründedir. Sunucu, istemci, SQL ve diğer proje dosyalarının tamamı `main` dalına yüklenmektedir.

Yerel kullanım: SQL Server `KNIGHTLOCAL` / `KNIGHT_TEMU_2239`, Python 3, ODBC Driver 18 ve `fastapi`, `uvicorn`, `pyodbc` gerekir. `14_GM_Admin_Paneli/Baslat-Panel.bat` paneli `http://127.0.0.1:8080` adresinde açar.

Oyuncu/eşya/para yönetimi, drop/spawn/upgrade düzenleme ve karakter stat yönetimi bulunur. Stat değişiklikleri çevrimdışı kaydedilir. Yerel hesap şifreleri bu dalda yoktur.
