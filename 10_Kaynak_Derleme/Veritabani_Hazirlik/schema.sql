-- Lab database only. Authored reference schema; no imported player accounts.

CREATE TABLE dbo.[hacktool_check_list] (
  [sindex] int NOT NULL,
  [checking] nvarchar(max) NULL
);

ALTER TABLE dbo.[hacktool_check_list] ADD CONSTRAINT [PK_LAB_hacktool_check_list] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[_articles] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [title] nvarchar(max) NULL,
  [articles] nvarchar(max) NULL,
  [date] nvarchar(max) NULL,
  [views] int NULL,
  [type] nvarchar(max) NULL
);

CREATE TABLE dbo.[_bankalar] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [banka] nvarchar(250) NULL,
  [sube] nvarchar(250) NULL,
  [hesap] nvarchar(250) NULL,
  [isim] nvarchar(50) NULL,
  [iban] nvarchar(250) NULL
);

CREATE TABLE dbo.[_baslangic_itemleri] (
  [warrior] nvarchar(255) NULL,
  [rogue] nvarchar(255) NULL,
  [mage] nvarchar(255) NULL,
  [priest] nvarchar(255) NULL,
  [durum] int NULL DEFAULT 0,
  [inventory] int NULL DEFAULT 0
);

CREATE TABLE dbo.[_block] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [titletr] nvarchar(200) NULL,
  [titleen] nvarchar(200) NULL,
  [contenttr] nvarchar(4000) NULL,
  [contenten] nvarchar(4000) NULL
);

CREATE TABLE dbo.[_cashpaketi] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [cashpaketi] nvarchar(50) NULL,
  [fiyati] nvarchar(50) NULL
);

CREATE TABLE dbo.[_chat] (
  [strchatcode] nvarchar(max) NULL
);

CREATE TABLE dbo.[_codehistory] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [esn] nvarchar(50) NULL,
  [pass] nvarchar(50) NULL,
  [straccountid] nvarchar(50) NULL
);

CREATE TABLE dbo.[_destek] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [struserid] nvarchar(80) NULL,
  [strtitle] nvarchar(80) NULL,
  [strsoru] nvarchar(1500) NULL,
  [strcevap] nvarchar(1500) NULL,
  [strcatid] nvarchar(50) NULL,
  [strdurum] nvarchar(50) NULL DEFAULT '0'
);

CREATE TABLE dbo.[_downloads] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [titletr] nvarchar(250) NULL,
  [titleen] nvarchar(250) NULL,
  [url] nvarchar(250) NULL,
  [tarih] nvarchar(250) NULL,
  [tip] nvarchar(max) NULL
);

CREATE TABLE dbo.[_event] (
  [eventname] nvarchar(max) NULL,
  [eventday] int NULL,
  [eventstarthour] nvarchar(max) NULL,
  [eventstartminute] nvarchar(max) NULL,
  [eventfinishhour] nvarchar(max) NULL,
  [eventfinishminute] nvarchar(max) NULL,
  [date] nvarchar(max) NULL
);

CREATE TABLE dbo.[_kesn] (
  [esn] nvarchar(40) NULL,
  [passwd] nvarchar(9) NULL,
  [cash] int NULL,
  [durum] int NULL DEFAULT 0,
  [kullanan] nvarchar(21) NULL
);

CREATE TABLE dbo.[_links] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [title] nvarchar(200) NULL,
  [url] nvarchar(200) NULL
);

CREATE TABLE dbo.[_log_halit] (
  [straccountid] nvarchar(max) NULL,
  [struserid] nvarchar(max) NULL,
  [eskinick] nvarchar(max) NULL,
  [yeninick] nvarchar(max) NULL,
  [eskiirk] nvarchar(max) NULL,
  [yeniirk] nvarchar(max) NULL,
  [eskijob] nvarchar(max) NULL,
  [yenijob] nvarchar(max) NULL,
  [halittime] datetime NULL
);

CREATE TABLE dbo.[_mykol] (
  [straccountid] nvarchar(21) NULL,
  [mykolsoru] nvarchar(500) NULL,
  [mykolcevap] nvarchar(500) NULL,
  [mykolmail] nvarchar(250) NULL,
  [mykoltelefon] nvarchar(max) NULL,
  [mykolipadress] nvarchar(max) NULL,
  [mykolregdate] nvarchar(max) NULL,
  [mykollastlogin] nvarchar(max) NULL,
  [mykollastipadress] nvarchar(max) NULL
);

CREATE TABLE dbo.[_news] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [titletr] nvarchar(200) NULL,
  [titleen] nvarchar(200) NULL,
  [newstr] nvarchar(4000) NULL,
  [newsen] nvarchar(4000) NULL,
  [tip] nvarchar(max) NULL,
  [tarih] date NULL,
  [sef] nvarchar(200) NULL,
  [views] nvarchar(max) NULL,
  [img] nvarchar(250) NULL,
  [titlees] nvarchar(max) NULL,
  [newses] nvarchar(max) NULL
);

CREATE TABLE dbo.[_panelsettings] (
  [userdetay] int NOT NULL,
  [girisyap] nvarchar(50) NOT NULL,
  [kayitol] nvarchar(50) NOT NULL,
  [sifredegistir] nvarchar(50) NOT NULL,
  [siralama_turu] int NOT NULL DEFAULT 1,
  [paypal] nvarchar(50) NULL,
  [client_url] nvarchar(500) NULL
);

CREATE TABLE dbo.[_paymentnotice] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [straccountid] nvarchar(50) NULL,
  [siparisno] nvarchar(50) NULL,
  [bankahesabi] nvarchar(100) NULL,
  [notunuz] nvarchar(250) NULL,
  [durumu] nvarchar(50) NULL DEFAULT '0'
);

CREATE TABLE dbo.[_premium] (
  [premiumname] nvarchar(max) NULL,
  [premiumcode] int NULL,
  [premiumday] nvarchar(max) NULL,
  [premiumimg] nvarchar(max) NULL,
  [premiumcash] int NULL
);

CREATE TABLE dbo.[_pus_code] (
  [charid] nvarchar(max) NULL,
  [accountid] nvarchar(max) NULL,
  [serialcode] nvarchar(max) NULL,
  [descaption] nvarchar(max) NULL,
  [amount] int NULL,
  [used] smallint NULL,
  [usedtime] nvarchar(max) NULL,
  [usedip] nvarchar(max) NULL
);

CREATE TABLE dbo.[_pusayarlari] (
  [ncscash] int NULL,
  [ntscash] int NULL,
  [pusstatus] int NULL,
  [ncsstatus] int NULL,
  [ntsstatus] int NULL,
  [classcash] int NULL,
  [classstatus] int NULL
);

CREATE TABLE dbo.[_pussettings] (
  [ncscash] int NULL,
  [ntscash] int NULL,
  [pusstatus] int NULL,
  [ncsstatus] int NULL,
  [ntsstatus] int NULL,
  [classcash] int NULL,
  [classstatus] int NULL,
  [pus_turu] int NOT NULL DEFAULT 1,
  [pus_sure] bigint NOT NULL DEFAULT '86400',
  [market] int NOT NULL DEFAULT 1,
  [vote_sure] bigint NOT NULL DEFAULT '86400',
  [vote_sure_server] int NULL
);

CREATE TABLE dbo.[_siparisler] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [siparisno] nvarchar(50) NOT NULL,
  [urunadi] nvarchar(50) NULL,
  [adeti] nvarchar(50) NULL,
  [fiyati] nvarchar(50) NULL,
  [durumu] nvarchar(50) NULL DEFAULT '0',
  [gonderen] nvarchar(50) NULL
);

CREATE TABLE dbo.[_site_admin_accounts] (
  [straccountid] nvarchar(max) NULL,
  [strpassword] nvarchar(max) NULL,
  [strname] nvarchar(max) NULL,
  [strsurname] nvarchar(max) NULL,
  [strauthority] int NULL,
  [lastlogintime] nvarchar(max) NULL,
  [lastloginip] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_articles] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [title] nvarchar(max) NULL,
  [articles] nvarchar(max) NULL,
  [date] nvarchar(max) NULL,
  [views] int NULL,
  [type] nvarchar(max) NULL,
  [mykolvotetime1] nvarchar(max) NULL,
  [mykolvotetime2] nvarchar(max) NULL,
  [mykolvotetime3] nvarchar(max) NULL,
  [mykolvotetime4] nvarchar(max) NULL,
  [mykolvotetime6] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_banks] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [banka] nvarchar(max) NULL,
  [sube] nvarchar(max) NULL,
  [hesap] nvarchar(max) NULL,
  [isim] nvarchar(max) NULL,
  [iban] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_block] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [titletr] nvarchar(max) NULL,
  [titleen] nvarchar(max) NULL,
  [contenttr] nvarchar(max) NULL,
  [contenten] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_cash_packets] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [cashpaketi] nvarchar(max) NULL,
  [fiyati] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_code_history] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [esn] nvarchar(max) NULL,
  [pass] nvarchar(max) NULL,
  [straccountid] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_downloads] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [titletr] nvarchar(max) NULL,
  [titleen] nvarchar(max) NULL,
  [url] nvarchar(max) NULL,
  [tarih] nvarchar(max) NULL,
  [tip] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_events] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [eventname] nvarchar(max) NULL,
  [eventday] int NULL,
  [eventstarthour] nvarchar(max) NULL,
  [eventstartminute] nvarchar(max) NULL,
  [eventfinishhour] nvarchar(max) NULL,
  [eventfinishminute] nvarchar(max) NULL,
  [rewardnp] nvarchar(max) NULL,
  [rewardxp] nvarchar(max) NULL,
  [rewarditem1] nvarchar(max) NULL,
  [rewarditemcount1] int NULL,
  [rewarditem2] nvarchar(max) NULL,
  [rewarditemcount2] int NULL,
  [rewarditem3] nvarchar(max) NULL,
  [rewarditemcount3] int NULL
);

CREATE TABLE dbo.[_site_kesn_codes] (
  [esn] nvarchar(max) NULL,
  [passwd] nvarchar(max) NULL,
  [cash] int NULL,
  [durum] int NULL,
  [kullanan] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_links] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [title] nvarchar(max) NULL,
  [url] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_mail_settings] (
  [mail_user] nvarchar(max) NULL,
  [mail_password] nvarchar(max) NULL,
  [host] nvarchar(max) NULL,
  [port] nvarchar(max) NULL,
  [smtpsecure] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_mykol] (
  [straccountid] nvarchar(max) NULL,
  [mykolsoru] nvarchar(max) NULL,
  [mykolcevap] nvarchar(max) NULL,
  [mykolmail] nvarchar(max) NULL,
  [mykoltelefon] nvarchar(max) NULL,
  [mykolipadress] nvarchar(max) NULL,
  [mykolregdate] nvarchar(max) NULL,
  [mykollastlogin] nvarchar(max) NULL,
  [mykollastipadress] nvarchar(max) NULL,
  [strpasswd] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_news] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [titletr] nvarchar(max) NULL,
  [titleen] nvarchar(max) NULL,
  [newstr] nvarchar(max) NULL,
  [newsen] nvarchar(max) NULL,
  [tip] nvarchar(max) NULL,
  [tarih] nvarchar(max) NULL,
  [sef] nvarchar(max) NULL,
  [views] nvarchar(max) NULL,
  [img] nvarchar(max) NULL,
  [titlees] nvarchar(max) NULL,
  [newses] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_orders] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [siparisno] nvarchar(max) NOT NULL,
  [urunadi] nvarchar(max) NULL,
  [adeti] nvarchar(max) NULL,
  [fiyati] nvarchar(max) NULL,
  [durumu] nvarchar(max) NULL,
  [gonderen] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_panel_settings] (
  [userdetay] int NOT NULL DEFAULT 1,
  [girisyap] nvarchar(max) NOT NULL DEFAULT 'acik',
  [kayitol] nvarchar(max) NOT NULL DEFAULT 'acik',
  [sifredegistir] nvarchar(max) NOT NULL,
  [siralama_turu] int NOT NULL,
  [paypal] nvarchar(max) NULL,
  [client_url] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_payment_notice] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [straccountid] nvarchar(max) NULL,
  [siparisno] nvarchar(max) NULL,
  [bankahesabi] nvarchar(max) NULL,
  [notunuz] nvarchar(max) NULL,
  [durumu] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_pincode] (
  [pinid] bigint IDENTITY(1,1) NOT NULL,
  [pincode] nvarchar(max) NOT NULL,
  [accountid] nvarchar(max) NULL,
  [kc] int NOT NULL,
  [gift] int NULL,
  [maketime] datetime NULL,
  [used] int NULL,
  [dealer] nvarchar(max) NULL,
  [usedtime] nvarchar(max) NULL
);

ALTER TABLE dbo.[_site_pincode] ADD CONSTRAINT [PK_LAB__site_pincode] PRIMARY KEY NONCLUSTERED ([pinid]);

CREATE TABLE dbo.[_site_pus_settings] (
  [ncscash] int NULL,
  [ntscash] int NULL,
  [pusstatus] int NULL,
  [ncsstatus] int NULL,
  [ntsstatus] int NULL,
  [classcash] int NULL,
  [classstatus] int NULL,
  [pus_turu] int NOT NULL,
  [pus_sure] bigint NOT NULL,
  [market] int NOT NULL,
  [vote_sure] bigint NOT NULL,
  [vote_sure_server] int NULL
);

CREATE TABLE dbo.[_site_sliders] (
  [header] nvarchar(max) NULL,
  [main] nvarchar(max) NULL,
  [link] nvarchar(max) NULL,
  [image] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_social_links] (
  [youtube] nvarchar(max) NULL,
  [discord] nvarchar(max) NULL,
  [instagram] nvarchar(max) NULL,
  [facebook] nvarchar(max) NULL,
  [forum] nvarchar(max) NULL,
  [twitch] nvarchar(max) NULL,
  [pus] nvarchar(max) NULL,
  [knightcash] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_support] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [struserid] nvarchar(max) NULL,
  [strtitle] nvarchar(max) NULL,
  [strsoru] nvarchar(max) NULL,
  [strcevap] nvarchar(max) NULL,
  [strcatid] nvarchar(max) NULL,
  [strdurum] nvarchar(max) NULL,
  [strtime] nvarchar(max) NULL,
  [strtimecevap] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_uploads] (
  [imgname] nvarchar(max) NULL
);

CREATE TABLE dbo.[_site_vote_rewards] (
  [itemname] nvarchar(max) NULL,
  [itemcode] nvarchar(max) NULL,
  [itemcount] int NULL
);

CREATE TABLE dbo.[_site_web_settings] (
  [title] nvarchar(max) NOT NULL,
  [description] nvarchar(max) NOT NULL,
  [keywords] nvarchar(max) NOT NULL,
  [site_path] nvarchar(max) NOT NULL,
  [logo_text] nvarchar(max) NOT NULL,
  [cache_mode] nvarchar(max) NOT NULL,
  [cache_time] int NOT NULL,
  [lang] nvarchar(max) NULL,
  [online_bugu] int NOT NULL,
  [server_name] nvarchar(max) NULL,
  [theme_name] nvarchar(max) NULL
);

CREATE TABLE dbo.[_social] (
  [id] int NOT NULL,
  [youtube] nvarchar(250) NULL,
  [discord] nvarchar(max) NULL,
  [instagram] nvarchar(max) NULL,
  [facebook] nvarchar(250) NULL
);

CREATE TABLE dbo.[_ticket] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [ticket_type] nvarchar(max) NULL,
  [aciliyet] nvarchar(max) NULL,
  [ticket] nvarchar(max) NULL,
  [kim] nvarchar(max) NULL,
  [tarih] datetime NULL,
  [durum] int NULL DEFAULT 1
);

CREATE TABLE dbo.[_ticket_cevap] (
  [ticket_id] int NULL,
  [cevaplayan] nvarchar(max) NULL,
  [cevap] nvarchar(max) NULL,
  [tarih] datetime NULL
);

CREATE TABLE dbo.[_ucretsizlog] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [straccountid] nvarchar(50) NOT NULL,
  [seventime] nvarchar(50) NOT NULL,
  [strstatus] nvarchar(50) NOT NULL,
  [eskinick] nvarchar(50) NULL,
  [yeninick] nvarchar(50) NULL,
  [eskiirk] nvarchar(50) NULL,
  [yeniirk] nvarchar(50) NULL,
  [eskijob] nvarchar(50) NULL,
  [yenijob] nvarchar(50) NULL,
  [struserid] nvarchar(max) NULL
);

CREATE TABLE dbo.[_uploads] (
  [imgname] nvarchar(max) NULL
);

CREATE TABLE dbo.[_vote] (
  [straccountid] nvarchar(max) NULL,
  [count] int NULL,
  [time] datetime NULL
);

CREATE TABLE dbo.[_votelogs] (
  [straccountid] nvarchar(50) NULL,
  [votetime] nvarchar(max) NULL
);

CREATE TABLE dbo.[_wartimes] (
  [lunarwartr] nvarchar(50) NULL,
  [lunarwaren] nvarchar(50) NULL,
  [deloswartr] nvarchar(50) NULL,
  [deloswaren] nvarchar(50) NULL
);

CREATE TABLE dbo.[_websettings] (
  [title] nvarchar(250) NOT NULL,
  [description] nvarchar(200) NOT NULL,
  [keywords] nvarchar(200) NOT NULL,
  [site_path] nvarchar(200) NOT NULL,
  [logo_text] nvarchar(50) NOT NULL,
  [cache_mode] nvarchar(50) NOT NULL,
  [cache_time] int NOT NULL,
  [lang] nvarchar(50) NULL,
  [online_bugu] int NOT NULL DEFAULT 1,
  [server_name] nvarchar(max) NULL
);

CREATE TABLE dbo.[account_char] (
  [straccountid] nvarchar(21) NOT NULL,
  [bnation] smallint NOT NULL,
  [bcharnum] smallint NOT NULL,
  [strcharid1] nvarchar(21) NULL,
  [strcharid2] nvarchar(21) NULL,
  [strcharid3] nvarchar(21) NULL,
  [strcharid4] nvarchar(21) NULL,
  [lifeskillwarexp] bigint NOT NULL DEFAULT '0',
  [lifeskillhuntingexp] bigint NOT NULL DEFAULT '0',
  [lifeskillsmitheryexp] bigint NOT NULL DEFAULT '0',
  [lifeskillkarmaexp] bigint NOT NULL DEFAULT '0'
);

CREATE TABLE dbo.[account_login_control] (
  [straccountid] nvarchar(128) NOT NULL,
  [bangamemastername] nvarchar(max) NOT NULL,
  [isauthority] smallint NOT NULL,
  [banreason] nvarchar(max) NULL,
  [bancount] int NOT NULL,
  [opencount] int NOT NULL,
  [updatetime] datetime NULL
);

ALTER TABLE dbo.[account_login_control] ADD CONSTRAINT [PK_LAB_account_login_control] PRIMARY KEY NONCLUSTERED ([straccountid]);

CREATE TABLE dbo.[account_premium_data] (
  [straccountid] nvarchar(21) NOT NULL,
  [strpremium] varbinary(max) NULL,
  [spremiumcount] smallint NULL,
  [spremiuminuse] smallint NULL,
  [spremiumtime] int NULL DEFAULT 0
);

CREATE TABLE dbo.[achieve_com] (
  [sindex] int NOT NULL DEFAULT 0,
  [type] smallint NOT NULL,
  [req1] smallint NOT NULL DEFAULT '0',
  [req2] smallint NOT NULL DEFAULT '0'
);

CREATE TABLE dbo.[achieve_main] (
  [sindex] int NOT NULL DEFAULT 0,
  [type] smallint NOT NULL,
  [titleid] smallint NOT NULL DEFAULT '0',
  [point] smallint NOT NULL DEFAULT '0',
  [itemnum] int NOT NULL DEFAULT 0,
  [count] int NOT NULL DEFAULT 0,
  [zoneid] smallint NOT NULL,
  [unknown2] smallint NOT NULL,
  [achievetype] smallint NOT NULL,
  [reqtime] smallint NOT NULL DEFAULT '0',
  [strname] nvarchar(200) NULL,
  [strdesc] nvarchar(200) NULL,
  [byte1] smallint NOT NULL,
  [byte2] smallint NOT NULL
);

ALTER TABLE dbo.[achieve_main] ADD CONSTRAINT [PK_LAB_achieve_main] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[achieve_mon] (
  [sindex] int NOT NULL DEFAULT 0,
  [type] smallint NOT NULL,
  [byte] smallint NOT NULL,
  [monster1_1] int NOT NULL DEFAULT 0,
  [monster1_2] int NOT NULL DEFAULT 0,
  [monster1_3] int NOT NULL DEFAULT 0,
  [monster1_4] int NOT NULL DEFAULT 0,
  [moncount1] int NOT NULL DEFAULT 0,
  [monster2_1] int NOT NULL DEFAULT 0,
  [monster2_2] int NOT NULL DEFAULT 0,
  [monster2_3] int NOT NULL DEFAULT 0,
  [monster2_4] int NOT NULL DEFAULT 0,
  [moncount2] int NOT NULL DEFAULT 0
);

CREATE TABLE dbo.[achieve_normal] (
  [sindex] int NOT NULL DEFAULT 0,
  [type] smallint NOT NULL DEFAULT '0',
  [count] int NOT NULL DEFAULT 0
);

CREATE TABLE dbo.[achieve_title] (
  [sindex] int NOT NULL DEFAULT 0,
  [strname] nvarchar(200) NULL,
  [str] smallint NOT NULL DEFAULT '0',
  [hp] smallint NOT NULL DEFAULT '0',
  [dex] smallint NOT NULL DEFAULT '0',
  [int] smallint NOT NULL DEFAULT '0',
  [mp] smallint NOT NULL DEFAULT '0',
  [attack] smallint NOT NULL DEFAULT '0',
  [defence] smallint NOT NULL DEFAULT '0',
  [sloyaltybonus] smallint NOT NULL DEFAULT '0',
  [sexpbonus] smallint NOT NULL DEFAULT '0',
  [sshortswordac] smallint NOT NULL DEFAULT '0',
  [sjamadarac] smallint NOT NULL DEFAULT '0',
  [sswordac] smallint NOT NULL DEFAULT '0',
  [sblowac] smallint NOT NULL DEFAULT '0',
  [saxeac] smallint NOT NULL DEFAULT '0',
  [sspearac] smallint NOT NULL DEFAULT '0',
  [sarrowac] smallint NOT NULL DEFAULT '0',
  [sfirebonus] smallint NOT NULL DEFAULT '0',
  [sicebonus] smallint NOT NULL DEFAULT '0',
  [slightbonus] smallint NOT NULL DEFAULT '0',
  [sfireresist] smallint NOT NULL DEFAULT '0',
  [siceresist] smallint NOT NULL DEFAULT '0',
  [slightresist] smallint NOT NULL DEFAULT '0',
  [smagicresist] smallint NOT NULL DEFAULT '0',
  [scurseresist] smallint NOT NULL DEFAULT '0',
  [spoisonresist] smallint NOT NULL DEFAULT '0'
);

CREATE TABLE dbo.[achieve_war] (
  [sindex] int NOT NULL DEFAULT 0,
  [type] smallint NOT NULL,
  [scount] int NOT NULL DEFAULT 0
);

CREATE TABLE dbo.[banish_of_winner] (
  [nindex] int NOT NULL,
  [ssid] smallint NOT NULL,
  [snationid] smallint NULL,
  [szoneid] smallint NOT NULL,
  [sposx] smallint NOT NULL,
  [sposz] smallint NOT NULL,
  [scount] smallint NOT NULL,
  [sradius] smallint NULL,
  [sdeadtime] smallint NOT NULL
);

CREATE TABLE dbo.[battle] (
  [sindex] smallint NOT NULL,
  [bynation] smallint NOT NULL,
  [strusername] nvarchar(30) NULL
);

CREATE TABLE dbo.[beginner_items] (
  [iclass] smallint NULL,
  [strclass] nvarchar(max) NULL,
  [gold] bigint NULL,
  [stritem] varbinary(max) NULL
);

CREATE TABLE dbo.[chaos_stone_spawn] (
  [sindex] smallint NOT NULL,
  [szoneid] smallint NOT NULL,
  [isopen] smallint NULL,
  [srank] smallint NOT NULL,
  [schaosid] smallint NOT NULL,
  [scount] smallint NOT NULL,
  [sspawnx] smallint NOT NULL,
  [sspawnz] smallint NOT NULL,
  [sspawntime] smallint NOT NULL,
  [sdirection] smallint NOT NULL,
  [sradiusrange] smallint NOT NULL
);

CREATE TABLE dbo.[chaos_stone_summon_list] (
  [nindex] int NOT NULL,
  [zoneid] smallint NOT NULL,
  [ssid] smallint NOT NULL,
  [strname] nvarchar(max) NULL,
  [monsterspawnfamily] smallint NOT NULL
);

ALTER TABLE dbo.[chaos_stone_summon_list] ADD CONSTRAINT [PK_LAB_chaos_stone_summon_list] PRIMARY KEY NONCLUSTERED ([nindex]);

CREATE TABLE dbo.[chaos_stone_summon_stage] (
  [nindex] smallint NOT NULL,
  [zoneid] smallint NOT NULL,
  [nindexfamily] smallint NOT NULL
);

ALTER TABLE dbo.[chaos_stone_summon_stage] ADD CONSTRAINT [PK_LAB_chaos_stone_summon_stage] PRIMARY KEY NONCLUSTERED ([nindex]);

CREATE TABLE dbo.[character_valids] (
  [classindex] int IDENTITY(1,1) NOT NULL,
  [classname] nvarchar(100) NOT NULL,
  [nationvalue] smallint NOT NULL,
  [racevalue] smallint NOT NULL,
  [classvalue] smallint NOT NULL,
  [racename] nvarchar(100) NOT NULL
);

ALTER TABLE dbo.[character_valids] ADD CONSTRAINT [PK_LAB_character_valids] PRIMARY KEY NONCLUSTERED ([classindex]);

CREATE TABLE dbo.[coefficient] (
  [sclass] smallint NOT NULL,
  [shortsword] float NOT NULL,
  [jamadar] float NOT NULL,
  [sword] float NOT NULL,
  [axe] float NOT NULL,
  [club] float NOT NULL,
  [spear] float NOT NULL,
  [pole] float NOT NULL,
  [staff] float NOT NULL,
  [bow] float NOT NULL,
  [hp] float NOT NULL,
  [mp] float NOT NULL,
  [sp] float NOT NULL,
  [ac] float NOT NULL,
  [hitrate] float NOT NULL,
  [evasionrate] float NOT NULL
);

CREATE TABLE dbo.[concurrent] (
  [serverid] smallint NOT NULL,
  [zone1_count] smallint NOT NULL,
  [zone2_count] smallint NOT NULL,
  [zone3_count] smallint NOT NULL
);

CREATE TABLE dbo.[create_new_char_set] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [classtype] smallint NULL,
  [slotid] int NOT NULL,
  [itemid] int NOT NULL DEFAULT 0,
  [itemduration] smallint NOT NULL DEFAULT '0',
  [itemcount] smallint NOT NULL DEFAULT '0',
  [itemflag] smallint NOT NULL,
  [itemexpiretime] int NOT NULL DEFAULT 0
);

ALTER TABLE dbo.[create_new_char_set] ADD CONSTRAINT [PK_LAB_create_new_char_set] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[create_new_char_value] (
  [nindex] bigint IDENTITY(1,1) NOT NULL,
  [classtype] smallint NOT NULL,
  [jobtype] smallint NOT NULL,
  [level] smallint NOT NULL,
  [exp] bigint NOT NULL DEFAULT '0',
  [strength] smallint NOT NULL,
  [health] smallint NOT NULL,
  [dexterity] smallint NOT NULL,
  [intelligence] smallint NOT NULL,
  [magicpower] smallint NOT NULL,
  [freepoints] smallint NOT NULL DEFAULT '0',
  [skillpointfree] smallint NOT NULL,
  [skillpointcat1] smallint NOT NULL,
  [skillpointcat2] smallint NOT NULL,
  [skillpointcat3] smallint NOT NULL,
  [skillpointmaster] smallint NOT NULL,
  [gold] int NULL
);

ALTER TABLE dbo.[create_new_char_value] ADD CONSTRAINT [PK_LAB_create_new_char_value] PRIMARY KEY NONCLUSTERED ([nindex]);

CREATE TABLE dbo.[currentuser] (
  [straccountid] nvarchar(50) NOT NULL,
  [strcharid] nvarchar(50) NOT NULL,
  [nserverno] smallint NOT NULL,
  [strserverip] nvarchar(50) NOT NULL,
  [strclientip] nvarchar(50) NOT NULL
);

CREATE TABLE dbo.[deathmatch_items] (
  [slotid] smallint NULL,
  [itemid] int NULL,
  [itemduration] smallint NULL,
  [itemcount] smallint NULL
);

CREATE TABLE dbo.[df_monster_list] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [diffuculty] smallint NULL,
  [monsterid] smallint NOT NULL,
  [ismonster] smallint NOT NULL,
  [posx] smallint NOT NULL,
  [posz] smallint NOT NULL,
  [scount] smallint NULL,
  [sdirection] smallint NOT NULL,
  [sradiusrange] smallint NULL
);

ALTER TABLE dbo.[df_monster_list] ADD CONSTRAINT [PK_LAB_df_monster_list] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[df_stage_list] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [difficulty] smallint NOT NULL,
  [difficultyname] nvarchar(15) NULL,
  [sstageid] smallint NOT NULL
);

ALTER TABLE dbo.[df_stage_list] ADD CONSTRAINT [PK_LAB_df_stage_list] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[dkm_monster_dead_gift] (
  [inum] smallint NULL,
  [ngiveitemnum] int NULL,
  [ngiveitemname] nvarchar(max) NULL,
  [ngiveitemcount] smallint NULL,
  [ngivespercent] int NULL
);

CREATE TABLE dbo.[draki_monster_list] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [stageid] smallint NOT NULL,
  [monsterid] smallint NOT NULL,
  [posx] smallint NOT NULL,
  [posz] smallint NOT NULL,
  [sdirection] smallint NOT NULL,
  [ismonster] smallint NOT NULL
);

ALTER TABLE dbo.[draki_monster_list] ADD CONSTRAINT [PK_LAB_draki_monster_list] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[draki_tower_rift_rank] (
  [sindex] int NOT NULL,
  [class] int NULL,
  [classname] nvarchar(50) NULL,
  [rankid] int NOT NULL,
  [struserid] nvarchar(21) NOT NULL,
  [bstage] smallint NOT NULL,
  [finishtime] int NOT NULL
);

ALTER TABLE dbo.[draki_tower_rift_rank] ADD CONSTRAINT [PK_LAB_draki_tower_rift_rank] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[draki_tower_stages] (
  [id] int IDENTITY(1,1) NOT NULL,
  [drakistage] smallint NOT NULL,
  [drakisubstage] smallint NOT NULL,
  [drakitowernpcstate] smallint NOT NULL
);

ALTER TABLE dbo.[draki_tower_stages] ADD CONSTRAINT [PK_LAB_draki_tower_stages] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[dtproperties] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [objectid] int NULL,
  [property] nvarchar(64) NOT NULL,
  [value] nvarchar(255) NULL,
  [uvalue] nvarchar(255) NULL,
  [lvalue] varbinary(max) NULL,
  [version] int NOT NULL DEFAULT 0
);

ALTER TABLE dbo.[dtproperties] ADD CONSTRAINT [PK_LAB_dtproperties] PRIMARY KEY NONCLUSTERED ([id], [property]);

CREATE TABLE dbo.[event] (
  [zonenum] smallint NOT NULL,
  [eventnum] smallint NOT NULL,
  [type] smallint NOT NULL,
  [cond1] nvarchar(128) NULL,
  [cond2] nvarchar(128) NULL,
  [cond3] nvarchar(128) NULL,
  [cond4] nvarchar(128) NULL,
  [cond5] nvarchar(128) NULL,
  [exec1] nvarchar(128) NULL,
  [exec2] nvarchar(128) NULL,
  [exec3] nvarchar(128) NULL,
  [exec4] nvarchar(128) NULL,
  [exec5] nvarchar(128) NULL
);

CREATE TABLE dbo.[event_beef_play_timer] (
  [eventlocalid] smallint NOT NULL,
  [eventzoneid] smallint NOT NULL,
  [eventname] nvarchar(50) NOT NULL,
  [monumenttime] int NOT NULL,
  [losersigntime] int NOT NULL,
  [farmingtime] int NOT NULL
);

ALTER TABLE dbo.[event_beef_play_timer] ADD CONSTRAINT [PK_LAB_event_beef_play_timer] PRIMARY KEY NONCLUSTERED ([eventlocalid]);

CREATE TABLE dbo.[event_csw_play_timer] (
  [eventlocalid] smallint NULL,
  [eventzoneid] smallint NULL,
  [eventname] nvarchar(max) NULL,
  [barrackcreatedtime] int NULL,
  [deathmatchtime] int NULL,
  [preaparingtime] int NULL,
  [castellantime] int NULL,
  [ownerdelosmonumentfinish] int NULL,
  [monumentfinishtime] int NULL
);

CREATE TABLE dbo.[event_room_play_timer] (
  [eventlocalid] smallint NOT NULL,
  [eventzoneid] smallint NOT NULL,
  [eventname] nvarchar(50) NOT NULL,
  [eventsigntime] int NOT NULL,
  [eventplaytime] int NOT NULL,
  [eventattackopentime] int NOT NULL,
  [eventattackclosetime] int NOT NULL,
  [eventfinishtime] int NOT NULL
);

ALTER TABLE dbo.[event_room_play_timer] ADD CONSTRAINT [PK_LAB_event_room_play_timer] PRIMARY KEY NONCLUSTERED ([eventlocalid]);

CREATE TABLE dbo.[event_royale_play_timer] (
  [eventlocalid] smallint NOT NULL,
  [eventzoneid] smallint NOT NULL,
  [eventname] nvarchar(max) NOT NULL,
  [eventsigntime] int NOT NULL,
  [eventmanuelclosetime] int NOT NULL,
  [eventgassteptimer1] int NOT NULL,
  [eventgassteptimer2] int NOT NULL,
  [eventgassteptimer3] int NOT NULL,
  [eventgassteptimer4] int NOT NULL,
  [eventgassteptimer5] int NOT NULL
);

ALTER TABLE dbo.[event_royale_play_timer] ADD CONSTRAINT [PK_LAB_event_royale_play_timer] PRIMARY KEY NONCLUSTERED ([eventlocalid]);

CREATE TABLE dbo.[event_start_schedule] (
  [eventlocalid] smallint NOT NULL,
  [eventtype] smallint NOT NULL,
  [eventzoneid] smallint NOT NULL,
  [eventname] nvarchar(50) NOT NULL,
  [startdays] nvarchar(20) NOT NULL,
  [eventstatus] smallint NOT NULL,
  [starthour1] int NOT NULL,
  [startminute1] int NOT NULL,
  [timeactive1] smallint NOT NULL,
  [starthour2] int NOT NULL,
  [startminute2] int NOT NULL,
  [timeactive2] smallint NOT NULL,
  [starthour3] int NOT NULL,
  [startminute3] int NOT NULL,
  [timeactive3] smallint NOT NULL,
  [starthour4] int NOT NULL,
  [startminute4] int NOT NULL,
  [timeactive4] smallint NOT NULL,
  [starthour5] int NOT NULL,
  [startminute5] int NOT NULL,
  [timeactive5] smallint NOT NULL
);

ALTER TABLE dbo.[event_start_schedule] ADD CONSTRAINT [PK_LAB_event_start_schedule] PRIMARY KEY NONCLUSTERED ([eventlocalid]);

CREATE TABLE dbo.[event_start_schedule_orj] (
  [eventid] int NOT NULL,
  [eventtype] smallint NOT NULL,
  [eventlocaltype] smallint NOT NULL,
  [eventzoneid] smallint NOT NULL,
  [eventname] nvarchar(max) NOT NULL,
  [startdays] nvarchar(max) NOT NULL,
  [eventstatus] smallint NOT NULL,
  [starthour1] int NOT NULL,
  [startminute1] int NOT NULL,
  [startsecond1] int NOT NULL,
  [timeactive1] smallint NOT NULL,
  [starthour2] int NOT NULL,
  [startminute2] int NOT NULL,
  [startsecond2] int NOT NULL,
  [timeactive2] smallint NOT NULL,
  [starthour3] int NOT NULL,
  [startminute3] int NOT NULL,
  [startsecond3] int NOT NULL,
  [timeactive3] smallint NOT NULL,
  [starthour4] int NOT NULL,
  [startminute4] int NOT NULL,
  [startsecond4] int NOT NULL,
  [timeactive4] smallint NOT NULL,
  [starthour5] int NOT NULL,
  [startminute5] int NOT NULL,
  [startsecond5] int NOT NULL,
  [timeactive5] smallint NOT NULL
);

ALTER TABLE dbo.[event_start_schedule_orj] ADD CONSTRAINT [PK_LAB_event_start_schedule_orj] PRIMARY KEY NONCLUSTERED ([eventid]);

CREATE TABLE dbo.[event_trigger] (
  [nindex] int NULL,
  [bnpctype] smallint NULL,
  [snpcid] int NULL,
  [ntriggernum] int NULL
);

CREATE TABLE dbo.[friend_list] (
  [struserid] nvarchar(21) NOT NULL,
  [strfriend1] nvarchar(21) NULL,
  [strfriend2] nvarchar(21) NULL,
  [strfriend3] nvarchar(21) NULL,
  [strfriend4] nvarchar(21) NULL,
  [strfriend5] nvarchar(21) NULL,
  [strfriend6] nvarchar(21) NULL,
  [strfriend7] nvarchar(21) NULL,
  [strfriend8] nvarchar(21) NULL,
  [strfriend9] nvarchar(21) NULL,
  [strfriend10] nvarchar(21) NULL,
  [strfriend11] nvarchar(21) NULL,
  [strfriend12] nvarchar(21) NULL,
  [strfriend13] nvarchar(21) NULL,
  [strfriend14] nvarchar(21) NULL,
  [strfriend15] nvarchar(21) NULL,
  [strfriend16] nvarchar(21) NULL,
  [strfriend17] nvarchar(21) NULL,
  [strfriend18] nvarchar(21) NULL,
  [strfriend19] nvarchar(21) NULL,
  [strfriend20] nvarchar(21) NULL,
  [strfriend21] nvarchar(21) NULL,
  [strfriend22] nvarchar(21) NULL,
  [strfriend23] nvarchar(21) NULL,
  [strfriend24] nvarchar(21) NULL
);

CREATE TABLE dbo.[game_server_list] (
  [sserverid] smallint NOT NULL,
  [sgroupid] smallint NOT NULL,
  [strservername] nvarchar(40) NOT NULL,
  [strserverip] nvarchar(30) NOT NULL,
  [strlanip] nvarchar(30) NOT NULL,
  [splayercap] smallint NOT NULL,
  [sfreeplayercap] smallint NOT NULL,
  [strkaruskingname] nvarchar(21) NULL,
  [strkarusnotice] nvarchar(100) NULL,
  [strelmoradkingname] nvarchar(21) NULL,
  [strelmoradnotice] nvarchar(100) NULL
);

CREATE TABLE dbo.[home] (
  [nation] smallint NOT NULL,
  [elmozonex] int NOT NULL,
  [elmozonez] int NOT NULL,
  [elmozonelx] smallint NOT NULL,
  [elmozonelz] smallint NOT NULL,
  [karuszonex] int NOT NULL,
  [karuszonez] int NOT NULL,
  [karuszonelx] smallint NOT NULL,
  [karuszonelz] smallint NOT NULL,
  [freezonex] int NOT NULL,
  [freezonez] int NOT NULL,
  [freezonelx] smallint NOT NULL,
  [freezonelz] smallint NOT NULL,
  [battlezonex] int NOT NULL,
  [battlezonez] int NOT NULL,
  [battlezonelx] smallint NOT NULL,
  [battlezonelz] smallint NOT NULL,
  [battlezone2x] int NOT NULL,
  [battlezone2z] int NOT NULL,
  [battlezone2lx] smallint NOT NULL,
  [battlezone2lz] smallint NOT NULL,
  [battlezone3x] int NOT NULL DEFAULT 0,
  [battlezone3z] int NOT NULL DEFAULT 0,
  [battlezone3lx] smallint NOT NULL,
  [battlezone3lz] smallint NOT NULL,
  [battlezone4x] int NOT NULL DEFAULT 0,
  [battlezone4z] int NOT NULL DEFAULT 0,
  [battlezone4lx] smallint NOT NULL,
  [battlezone4lz] smallint NOT NULL,
  [battlezone5x] int NOT NULL DEFAULT 0,
  [battlezone5z] int NOT NULL DEFAULT 0,
  [battlezone5lx] smallint NOT NULL,
  [battlezone5lz] smallint NOT NULL,
  [battlezone6x] int NOT NULL DEFAULT 0,
  [battlezone6z] int NOT NULL DEFAULT 0,
  [battlezone6lx] smallint NOT NULL,
  [battlezone6lz] smallint NOT NULL
);

CREATE TABLE dbo.[hook_collectionrace_hunt_list] (
  [id] int NOT NULL,
  [monsternum1] smallint NOT NULL,
  [monstername1] nvarchar(max) NULL,
  [monsterkillcount1] int NOT NULL,
  [monsternum2] smallint NOT NULL,
  [monstername2] nvarchar(max) NULL,
  [monsterkillcount2] int NOT NULL,
  [monsternum3] smallint NOT NULL,
  [monstername3] nvarchar(max) NULL,
  [monsterkillcount3] int NOT NULL,
  [monsternum4] smallint NOT NULL,
  [monstername4] nvarchar(max) NULL,
  [monsterkillcount4] int NOT NULL,
  [eventzone] int NOT NULL
);

CREATE TABLE dbo.[hook_collectionrace_settings] (
  [id] int NOT NULL,
  [maxuser] int NOT NULL,
  [maxlevel] smallint NOT NULL,
  [minlevel] smallint NOT NULL,
  [numreward1] int NOT NULL,
  [numreward2] int NOT NULL,
  [strname1] nvarchar(max) NULL,
  [strname2] nvarchar(max) NULL,
  [count1] int NOT NULL,
  [count2] int NOT NULL,
  [expirationtime1] smallint NOT NULL,
  [expirationtime2] smallint NOT NULL,
  [gold] int NOT NULL,
  [exp] int NOT NULL,
  [kc] int NOT NULL,
  [np] int NOT NULL
);

CREATE TABLE dbo.[hook_pus_items] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [itemid] int NOT NULL,
  [stritemname] nvarchar(max) NULL,
  [stritemtitle] nvarchar(max) NULL,
  [price] int NULL,
  [sendtype] int NULL,
  [buycount] int NOT NULL,
  [stritemdesc] nvarchar(max) NOT NULL,
  [category] smallint NOT NULL DEFAULT '1'
);

ALTER TABLE dbo.[hook_pus_items] ADD CONSTRAINT [PK_LAB_hook_pus_items] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[hook_settings] (
  [acs_validation] smallint NOT NULL,
  [button_facebook] smallint NOT NULL,
  [button_discord] smallint NOT NULL,
  [button_live] smallint NOT NULL,
  [button_support] smallint NOT NULL,
  [url_facebook] nvarchar(max) NOT NULL DEFAULT 'http://www.hshieldsoftware.com/',
  [url_discord] nvarchar(max) NOT NULL DEFAULT 'http://www.hshieldsoftware.com/',
  [url_live] nvarchar(max) NOT NULL DEFAULT 'http://www.hshieldsoftware.com/',
  [url_kcbayi] nvarchar(max) NOT NULL DEFAULT 'http://www.hshieldsoftware.com/',
  [kcmerchant_minprice] smallint NOT NULL,
  [kcmerchant_maxprice] smallint NOT NULL,
  [state_tempitemlist] smallint NOT NULL,
  [state_statreset] smallint NOT NULL,
  [state_skillreset] smallint NOT NULL,
  [state_pus] smallint NOT NULL
);

CREATE TABLE dbo.[item] (
  [num] int NULL,
  [extension] smallint NULL,
  [strname] nvarchar(50) NULL,
  [description] nvarchar(512) NULL,
  [itemiconid1] int NULL,
  [itemiconid2] int NULL,
  [kind] smallint NULL,
  [slot] smallint NULL,
  [race] smallint NULL,
  [class] smallint NULL,
  [damage] smallint NULL,
  [delay] smallint NULL,
  [range] smallint NULL,
  [weight] smallint NULL,
  [duration] smallint NULL,
  [buyprice] int NULL,
  [sellprice] int NULL,
  [ac] smallint NULL,
  [countable] smallint NULL,
  [effect1] int NULL,
  [effect2] int NULL,
  [reqlevel] smallint NULL,
  [reqlevelmax] smallint NULL,
  [reqrank] smallint NULL,
  [reqtitle] smallint NULL,
  [reqstr] smallint NULL,
  [reqsta] smallint NULL,
  [reqdex] smallint NULL,
  [reqintel] smallint NULL,
  [reqcha] smallint NULL,
  [sellinggroup] smallint NULL,
  [itemtype] smallint NULL,
  [hitrate] smallint NULL,
  [evasionrate] smallint NULL,
  [daggerac] smallint NULL,
  [jamadarac] smallint NULL,
  [swordac] smallint NULL,
  [maceac] smallint NULL,
  [axeac] smallint NULL,
  [spearac] smallint NULL,
  [bowac] smallint NULL,
  [firedamage] smallint NULL,
  [icedamage] smallint NULL,
  [lightningdamage] smallint NULL,
  [poisondamage] smallint NULL,
  [hpdrain] smallint NULL,
  [mpdamage] smallint NULL,
  [mpdrain] smallint NULL,
  [mirrordamage] smallint NULL,
  [droprate] smallint NULL,
  [strb] smallint NULL,
  [stab] smallint NULL,
  [dexb] smallint NULL,
  [intelb] smallint NULL,
  [chab] smallint NULL,
  [maxhpb] smallint NULL,
  [maxmpb] smallint NULL,
  [firer] smallint NULL,
  [coldr] smallint NULL,
  [lightningr] smallint NULL,
  [magicr] smallint NULL,
  [poisonr] smallint NULL,
  [curser] smallint NULL,
  [itemclass] smallint NULL,
  [npbuyprice] int NULL,
  [bound] smallint NULL
);

CREATE TABLE dbo.[item_exchange] (
  [nindex] int NOT NULL,
  [brandomflag] smallint NOT NULL,
  [noriginitemnum1] int NOT NULL,
  [noriginitemcount1] int NOT NULL,
  [noriginitemnum2] int NOT NULL,
  [noriginitemcount2] int NOT NULL,
  [noriginitemnum3] int NOT NULL,
  [noriginitemcount3] int NOT NULL,
  [noriginitemnum4] int NOT NULL,
  [noriginitemcount4] int NOT NULL,
  [noriginitemnum5] int NOT NULL,
  [noriginitemcount5] int NOT NULL,
  [nexchangeitemnum1] int NOT NULL,
  [nexchangeitemcount1] int NOT NULL,
  [nexchangeitemnum2] int NOT NULL,
  [nexchangeitemcount2] int NOT NULL,
  [nexchangeitemnum3] int NOT NULL,
  [nexchangeitemcount3] int NOT NULL,
  [nexchangeitemnum4] int NOT NULL,
  [nexchangeitemcount4] int NOT NULL,
  [nexchangeitemnum5] int NOT NULL,
  [nexchangeitemcount5] int NOT NULL
);

CREATE TABLE dbo.[item_exchange_exp] (
  [nindex] int NOT NULL,
  [brandomflag] int NOT NULL,
  [nexchangeitemnum1] int NOT NULL,
  [nexchangeitemcount1] int NOT NULL,
  [nexchangeitemnum2] int NOT NULL,
  [nexchangeitemcount2] int NOT NULL,
  [nexchangeitemnum3] int NOT NULL,
  [nexchangeitemcount3] int NOT NULL,
  [nexchangeitemnum4] int NOT NULL,
  [nexchangeitemcount4] int NOT NULL,
  [nexchangeitemnum5] int NOT NULL,
  [nexchangeitemcount5] int NOT NULL
);

CREATE TABLE dbo.[item_exchangeorj] (
  [nindex] int NOT NULL,
  [brandomflag] smallint NOT NULL,
  [noriginitemnum1] int NOT NULL,
  [noriginitemcount1] int NOT NULL,
  [noriginitemnum2] int NOT NULL,
  [noriginitemcount2] int NOT NULL,
  [noriginitemnum3] int NOT NULL,
  [noriginitemcount3] int NOT NULL,
  [noriginitemnum4] int NOT NULL,
  [noriginitemcount4] int NOT NULL,
  [noriginitemnum5] int NOT NULL,
  [noriginitemcount5] int NOT NULL,
  [nexchangeitemnum1] int NOT NULL,
  [nexchangeitemcount1] int NOT NULL,
  [nexchangeitemnum2] int NOT NULL,
  [nexchangeitemcount2] int NOT NULL,
  [nexchangeitemnum3] int NOT NULL,
  [nexchangeitemcount3] int NOT NULL,
  [nexchangeitemnum4] int NOT NULL,
  [nexchangeitemcount4] int NOT NULL,
  [nexchangeitemnum5] int NOT NULL,
  [nexchangeitemcount5] int NOT NULL
);

ALTER TABLE dbo.[item_exchangeorj] ADD CONSTRAINT [PK_LAB_item_exchangeorj] PRIMARY KEY NONCLUSTERED ([nindex]);

CREATE TABLE dbo.[item_expiration] (
  [id] int NOT NULL,
  [num] int NULL,
  [strname] nvarchar(max) NULL,
  [expirationtime] smallint NULL
);

CREATE TABLE dbo.[item_give_exchange] (
  [nexchangeindex] int NOT NULL,
  [nrobitemid1] int NOT NULL DEFAULT 0,
  [nrobitemid2] int NOT NULL DEFAULT 0,
  [nrobitemid3] int NOT NULL DEFAULT 0,
  [nrobitemid4] int NOT NULL DEFAULT 0,
  [nrobitemid5] int NOT NULL DEFAULT 0,
  [nrobitemid6] int NOT NULL DEFAULT 0,
  [nrobitemid7] int NOT NULL DEFAULT 0,
  [nrobitemid8] int NOT NULL DEFAULT 0,
  [nrobitemid9] int NOT NULL DEFAULT 0,
  [nrobitemid10] int NOT NULL DEFAULT 0,
  [nrobitemcount1] int NOT NULL DEFAULT 0,
  [nrobitemcount2] int NOT NULL DEFAULT 0,
  [nrobitemcount3] int NOT NULL DEFAULT 0,
  [nrobitemcount4] int NOT NULL DEFAULT 0,
  [nrobitemcount5] int NOT NULL DEFAULT 0,
  [nrobitemcount6] int NOT NULL DEFAULT 0,
  [nrobitemcount7] int NOT NULL DEFAULT 0,
  [nrobitemcount8] int NOT NULL DEFAULT 0,
  [nrobitemcount9] int NOT NULL DEFAULT 0,
  [nrobitemcount10] int NOT NULL DEFAULT 0,
  [ngiveitemid1] int NOT NULL DEFAULT 0,
  [ngiveitemid2] int NOT NULL DEFAULT 0,
  [ngiveitemid3] int NOT NULL DEFAULT 0,
  [ngiveitemid4] int NOT NULL DEFAULT 0,
  [ngiveitemid5] int NOT NULL DEFAULT 0,
  [ngiveitemid6] int NOT NULL DEFAULT 0,
  [ngiveitemid7] int NOT NULL DEFAULT 0,
  [ngiveitemid8] int NOT NULL DEFAULT 0,
  [ngiveitemid9] int NOT NULL DEFAULT 0,
  [ngiveitemid10] int NOT NULL DEFAULT 0,
  [ngiveitemcount1] int NOT NULL DEFAULT 0,
  [ngiveitemcount2] int NOT NULL DEFAULT 0,
  [ngiveitemcount3] int NOT NULL DEFAULT 0,
  [ngiveitemcount4] int NOT NULL DEFAULT 0,
  [ngiveitemcount5] int NOT NULL DEFAULT 0,
  [ngiveitemcount6] int NOT NULL DEFAULT 0,
  [ngiveitemcount7] int NOT NULL DEFAULT 0,
  [ngiveitemcount8] int NOT NULL DEFAULT 0,
  [ngiveitemcount9] int NOT NULL DEFAULT 0,
  [ngiveitemcount10] int NOT NULL DEFAULT 0,
  [ngiveitemtime1] int NOT NULL DEFAULT 0,
  [ngiveitemtime2] int NOT NULL DEFAULT 0,
  [ngiveitemtime3] int NOT NULL DEFAULT 0,
  [ngiveitemtime4] int NOT NULL DEFAULT 0,
  [ngiveitemtime5] int NOT NULL DEFAULT 0,
  [ngiveitemtime6] int NOT NULL DEFAULT 0,
  [ngiveitemtime7] int NOT NULL DEFAULT 0,
  [ngiveitemtime8] int NOT NULL DEFAULT 0,
  [ngiveitemtime9] int NOT NULL DEFAULT 0,
  [ngiveitemtime10] int NOT NULL DEFAULT 0
);

ALTER TABLE dbo.[item_give_exchange] ADD CONSTRAINT [PK_LAB_item_give_exchange] PRIMARY KEY NONCLUSTERED ([nexchangeindex]);

CREATE TABLE dbo.[item_group] (
  [group] smallint NOT NULL,
  [name] nvarchar(30) NULL,
  [item1] int NOT NULL,
  [item2] int NOT NULL,
  [item3] int NOT NULL,
  [item4] int NOT NULL,
  [item5] int NOT NULL,
  [item6] int NOT NULL,
  [item7] int NOT NULL,
  [item8] int NOT NULL,
  [item9] int NOT NULL,
  [item10] int NOT NULL,
  [item11] int NOT NULL,
  [item12] int NOT NULL,
  [item13] int NOT NULL,
  [item14] int NOT NULL,
  [item15] int NOT NULL,
  [item16] int NOT NULL,
  [item17] int NOT NULL,
  [item18] int NOT NULL,
  [item19] int NOT NULL,
  [item20] int NOT NULL,
  [item21] int NOT NULL,
  [item22] int NOT NULL,
  [item23] int NOT NULL,
  [item24] int NOT NULL,
  [item25] int NOT NULL,
  [item26] int NOT NULL,
  [item27] int NOT NULL,
  [item28] int NOT NULL,
  [item29] int NOT NULL,
  [item30] int NOT NULL
);

CREATE TABLE dbo.[item_op] (
  [nitemid] int NOT NULL,
  [btriggertype] smallint NOT NULL,
  [nskillid] int NOT NULL,
  [btriggerrate] smallint NOT NULL
);

CREATE TABLE dbo.[item_org] (
  [num] int NULL,
  [extension] smallint NULL,
  [strname] nvarchar(max) NULL,
  [description] nvarchar(max) NULL,
  [itemiconid1] int NULL,
  [itemiconid2] int NULL,
  [kind] smallint NULL,
  [slot] smallint NULL,
  [race] smallint NULL,
  [class] smallint NULL,
  [damage] smallint NULL,
  [delay] smallint NULL,
  [range] smallint NULL,
  [weight] smallint NULL,
  [duration] smallint NULL,
  [buyprice] int NULL,
  [sellprice] int NULL,
  [ac] smallint NULL,
  [countable] smallint NULL,
  [effect1] int NULL,
  [effect2] int NULL,
  [reqlevel] smallint NULL,
  [reqlevelmax] smallint NULL,
  [reqrank] smallint NULL,
  [reqtitle] smallint NULL,
  [reqstr] smallint NULL,
  [reqsta] smallint NULL,
  [reqdex] smallint NULL,
  [reqintel] smallint NULL,
  [reqcha] smallint NULL,
  [sellinggroup] smallint NULL,
  [itemtype] smallint NULL,
  [hitrate] smallint NULL,
  [evasionrate] smallint NULL,
  [daggerac] smallint NULL,
  [jamadarac] smallint NULL,
  [swordac] smallint NULL,
  [maceac] smallint NULL,
  [axeac] smallint NULL,
  [spearac] smallint NULL,
  [bowac] smallint NULL,
  [firedamage] smallint NULL,
  [icedamage] smallint NULL,
  [lightningdamage] smallint NULL,
  [poisondamage] smallint NULL,
  [hpdrain] smallint NULL,
  [mpdamage] smallint NULL,
  [mpdrain] smallint NULL,
  [mirrordamage] smallint NULL,
  [droprate] smallint NULL,
  [strb] smallint NULL,
  [stab] smallint NULL,
  [dexb] smallint NULL,
  [intelb] smallint NULL,
  [chab] smallint NULL,
  [maxhpb] smallint NULL,
  [maxmpb] smallint NULL,
  [firer] smallint NULL,
  [coldr] smallint NULL,
  [lightningr] smallint NULL,
  [magicr] smallint NULL,
  [poisonr] smallint NULL,
  [curser] smallint NULL,
  [itemclass] smallint NULL,
  [npbuyprice] int NULL,
  [bound] smallint NULL
);

CREATE TABLE dbo.[item_orj] (
  [num] int NULL,
  [extension] smallint NULL,
  [strname] nvarchar(max) NULL,
  [description] nvarchar(max) NULL,
  [itemiconid1] int NULL,
  [itemiconid2] int NULL,
  [kind] smallint NULL,
  [slot] smallint NULL,
  [race] smallint NULL,
  [class] smallint NULL,
  [damage] smallint NULL,
  [delay] smallint NULL,
  [range] smallint NULL,
  [weight] smallint NULL,
  [duration] smallint NULL,
  [buyprice] int NULL,
  [sellprice] int NULL,
  [ac] smallint NULL,
  [countable] smallint NULL,
  [effect1] int NULL,
  [effect2] int NULL,
  [reqlevel] smallint NULL,
  [reqlevelmax] smallint NULL,
  [reqrank] smallint NULL,
  [reqtitle] smallint NULL,
  [reqstr] smallint NULL,
  [reqsta] smallint NULL,
  [reqdex] smallint NULL,
  [reqintel] smallint NULL,
  [reqcha] smallint NULL,
  [sellinggroup] smallint NULL,
  [itemtype] smallint NULL,
  [hitrate] smallint NULL,
  [evasionrate] smallint NULL,
  [daggerac] smallint NULL,
  [jamadarac] smallint NULL,
  [swordac] smallint NULL,
  [maceac] smallint NULL,
  [axeac] smallint NULL,
  [spearac] smallint NULL,
  [bowac] smallint NULL,
  [firedamage] smallint NULL,
  [icedamage] smallint NULL,
  [lightningdamage] smallint NULL,
  [poisondamage] smallint NULL,
  [hpdrain] smallint NULL,
  [mpdamage] smallint NULL,
  [mpdrain] smallint NULL,
  [mirrordamage] smallint NULL,
  [droprate] smallint NULL,
  [strb] smallint NULL,
  [stab] smallint NULL,
  [dexb] smallint NULL,
  [intelb] smallint NULL,
  [chab] smallint NULL,
  [maxhpb] smallint NULL,
  [maxmpb] smallint NULL,
  [firer] smallint NULL,
  [coldr] smallint NULL,
  [lightningr] smallint NULL,
  [magicr] smallint NULL,
  [poisonr] smallint NULL,
  [curser] smallint NULL,
  [itemclass] smallint NULL,
  [npbuyprice] int NULL,
  [bound] smallint NULL
);

CREATE TABLE dbo.[item_selltable] (
  [nindex] int NOT NULL,
  [isellinggroup] int NULL,
  [item1] int NULL,
  [item2] int NULL,
  [item3] int NULL,
  [item4] int NULL,
  [item5] int NULL,
  [item6] int NULL,
  [item7] int NULL,
  [item8] int NULL,
  [item9] int NULL,
  [item10] int NULL,
  [item11] int NULL,
  [item12] int NULL,
  [item13] int NULL,
  [item14] int NULL,
  [item15] int NULL,
  [item16] int NULL,
  [item17] int NULL,
  [item18] int NULL,
  [item19] int NULL,
  [item20] int NULL,
  [item21] int NULL,
  [item22] int NULL,
  [item23] int NULL,
  [item24] int NULL
);

CREATE TABLE dbo.[item_selltable_farm] (
  [nindex] int NOT NULL,
  [isellinggroup] int NULL,
  [item1] int NULL,
  [item2] int NULL,
  [item3] int NULL,
  [item4] int NULL,
  [item5] int NULL,
  [item6] int NULL,
  [item7] int NULL,
  [item8] int NULL,
  [item9] int NULL,
  [item10] int NULL,
  [item11] int NULL,
  [item12] int NULL,
  [item13] int NULL,
  [item14] int NULL,
  [item15] int NULL,
  [item16] int NULL,
  [item17] int NULL,
  [item18] int NULL,
  [item19] int NULL,
  [item20] int NULL,
  [item21] int NULL,
  [item22] int NULL,
  [item23] int NULL,
  [item24] int NULL
);

CREATE TABLE dbo.[item_smash] (
  [nindex] int NOT NULL,
  [nitemid] int NOT NULL,
  [ncount] smallint NOT NULL,
  [nrate] smallint NOT NULL
);

ALTER TABLE dbo.[item_smash] ADD CONSTRAINT [PK_LAB_item_smash] PRIMARY KEY NONCLUSTERED ([nindex]);

CREATE TABLE dbo.[item_special_sewing] (
  [nindex] int NOT NULL,
  [nreqitemid1] int NOT NULL,
  [nreqitemcount1] int NOT NULL,
  [nreqitemid2] int NOT NULL,
  [nreqitemcount2] int NOT NULL,
  [nreqitemid3] int NOT NULL,
  [nreqitemcount3] int NOT NULL,
  [nreqitemid4] int NOT NULL,
  [nreqitemcount4] int NOT NULL,
  [nreqitemid5] int NOT NULL,
  [nreqitemcount5] int NOT NULL,
  [nreqitemid6] int NOT NULL,
  [nreqitemcount6] int NOT NULL,
  [nreqitemid7] int NOT NULL,
  [nreqitemcount7] int NOT NULL,
  [nreqitemid8] int NOT NULL,
  [nreqitemcount8] int NOT NULL,
  [nreqitemid9] int NOT NULL,
  [nreqitemcount9] int NOT NULL,
  [nreqitemid10] int NOT NULL,
  [nreqitemcount10] int NOT NULL,
  [ngiveitemid] int NOT NULL,
  [ngiveitemcount] int NOT NULL,
  [successrate] int NOT NULL,
  [snpcid] smallint NOT NULL,
  [isnotice] smallint NOT NULL,
  [isshadowsucces] smallint NULL,
  [description] nvarchar(max) NULL
);

CREATE TABLE dbo.[item_upgrade] (
  [nindex] bigint IDENTITY(1,1) NOT NULL,
  [nnpcnum] smallint NOT NULL,
  [itemname] nvarchar(max) NOT NULL,
  [upgradenote] nvarchar(max) NOT NULL,
  [scrollname] nvarchar(max) NOT NULL,
  [itemtype] int NOT NULL,
  [isunique] int NOT NULL,
  [conversion] int NOT NULL,
  [norigintype] smallint NOT NULL,
  [noriginitem] int NOT NULL,
  [nreqitem1] int NOT NULL,
  [nreqitem2] int NOT NULL,
  [nreqitem3] int NOT NULL,
  [nreqitem4] int NOT NULL,
  [nreqitem5] int NOT NULL,
  [nreqitem6] int NOT NULL,
  [nreqitem7] int NOT NULL,
  [nreqitem8] int NOT NULL,
  [nreqnoah] int NOT NULL,
  [bratetype] smallint NOT NULL,
  [ngenrate] smallint NOT NULL,
  [ngiveitem] int NOT NULL
);

ALTER TABLE dbo.[item_upgrade] ADD CONSTRAINT [PK_LAB_item_upgrade] PRIMARY KEY NONCLUSTERED ([nindex]);

CREATE TABLE dbo.[item_upgradebizim] (
  [nindex] int NOT NULL,
  [nnpcnum] smallint NOT NULL,
  [itemname] nvarchar(max) NOT NULL,
  [upgradenote] nvarchar(max) NOT NULL,
  [scrollname] nvarchar(max) NOT NULL,
  [itemtype] int NOT NULL,
  [isunique] int NOT NULL,
  [conversion] int NOT NULL,
  [norigintype] smallint NOT NULL,
  [noriginitem] int NOT NULL,
  [nreqitem1] int NOT NULL,
  [nreqitem2] int NOT NULL,
  [nreqitem3] int NOT NULL,
  [nreqitem4] int NOT NULL,
  [nreqitem5] int NOT NULL,
  [nreqitem6] int NOT NULL,
  [nreqitem7] int NOT NULL,
  [nreqitem8] int NOT NULL,
  [nreqnoah] int NOT NULL,
  [bratetype] smallint NOT NULL,
  [ngenrate] smallint NOT NULL,
  [ngiveitem] int NOT NULL
);

CREATE TABLE dbo.[item_wheel_of_fun_log] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [date] nvarchar(max) NULL,
  [itemname] nvarchar(max) NULL,
  [npoints] nvarchar(max) NULL,
  [username] nvarchar(max) NULL
);

CREATE TABLE dbo.[item_whell_of_fun] (
  [id] smallint NULL,
  [name] nvarchar(max) NULL,
  [num] int NULL,
  [count] smallint NULL,
  [percent] smallint NULL,
  [days] int NULL
);

CREATE TABLE dbo.[itemler] (
  [dwid] int NULL,
  [stacksize] smallint NULL,
  [durability] smallint NULL,
  [struserid] nvarchar(50) NULL,
  [sira] int NULL,
  [itembasicname] nvarchar(100) NULL,
  [extname] nvarchar(100) NULL
);

CREATE TABLE dbo.[itemorj] (
  [num] int NULL,
  [extension] smallint NULL,
  [strname] nvarchar(max) NULL,
  [description] nvarchar(max) NULL,
  [itemiconid1] int NULL,
  [itemiconid2] int NULL,
  [kind] smallint NULL,
  [slot] smallint NULL,
  [race] smallint NULL,
  [class] smallint NULL,
  [damage] smallint NULL,
  [delay] smallint NULL,
  [range] smallint NULL,
  [weight] smallint NULL,
  [duration] smallint NULL,
  [buyprice] int NULL,
  [sellprice] int NULL,
  [ac] smallint NULL,
  [countable] smallint NULL,
  [effect1] int NULL,
  [effect2] int NULL,
  [reqlevel] smallint NULL,
  [reqlevelmax] smallint NULL,
  [reqrank] smallint NULL,
  [reqtitle] smallint NULL,
  [reqstr] smallint NULL,
  [reqsta] smallint NULL,
  [reqdex] smallint NULL,
  [reqintel] smallint NULL,
  [reqcha] smallint NULL,
  [sellinggroup] smallint NULL,
  [itemtype] smallint NULL,
  [hitrate] smallint NULL,
  [evasionrate] smallint NULL,
  [daggerac] smallint NULL,
  [jamadarac] smallint NULL,
  [swordac] smallint NULL,
  [maceac] smallint NULL,
  [axeac] smallint NULL,
  [spearac] smallint NULL,
  [bowac] smallint NULL,
  [firedamage] smallint NULL,
  [icedamage] smallint NULL,
  [lightningdamage] smallint NULL,
  [poisondamage] smallint NULL,
  [hpdrain] smallint NULL,
  [mpdamage] smallint NULL,
  [mpdrain] smallint NULL,
  [mirrordamage] smallint NULL,
  [droprate] smallint NULL,
  [strb] smallint NULL,
  [stab] smallint NULL,
  [dexb] smallint NULL,
  [intelb] smallint NULL,
  [chab] smallint NULL,
  [maxhpb] smallint NULL,
  [maxmpb] smallint NULL,
  [firer] smallint NULL,
  [coldr] smallint NULL,
  [lightningr] smallint NULL,
  [magicr] smallint NULL,
  [poisonr] smallint NULL,
  [curser] smallint NULL,
  [itemclass] smallint NULL,
  [npbuyprice] int NULL,
  [bound] smallint NULL
);

CREATE TABLE dbo.[itemup_probability] (
  [btype] smallint NOT NULL,
  [nmaxsuccess] smallint NOT NULL,
  [nmaxfail] smallint NOT NULL,
  [ncursuccess] smallint NOT NULL,
  [ncurfail] smallint NOT NULL
);

CREATE TABLE dbo.[k_monster] (
  [ssid] smallint NOT NULL,
  [strname] nvarchar(100) NULL,
  [spid] smallint NOT NULL,
  [ssize] smallint NOT NULL,
  [iweapon1] int NOT NULL,
  [iweapon2] int NOT NULL,
  [bygroup] smallint NOT NULL,
  [byacttype] smallint NOT NULL,
  [bytype] smallint NOT NULL,
  [byfamily] smallint NOT NULL,
  [byrank] smallint NOT NULL,
  [bytitle] smallint NOT NULL,
  [isellinggroup] int NOT NULL,
  [slevel] smallint NOT NULL,
  [iexp] int NOT NULL,
  [iloyalty] int NOT NULL,
  [ihppoint] int NOT NULL,
  [smppoint] smallint NOT NULL,
  [satk] smallint NOT NULL,
  [sac] smallint NOT NULL,
  [shitrate] smallint NOT NULL,
  [sevaderate] smallint NOT NULL,
  [sdamage] smallint NOT NULL,
  [sattackdelay] smallint NOT NULL,
  [byspeed1] smallint NOT NULL,
  [byspeed2] smallint NOT NULL,
  [sstandtime] smallint NOT NULL,
  [sitem] smallint NOT NULL,
  [imagic1] int NOT NULL,
  [imagic2] int NOT NULL,
  [imagic3] int NOT NULL,
  [sfirer] smallint NOT NULL,
  [scoldr] smallint NOT NULL,
  [slightningr] smallint NOT NULL,
  [smagicr] smallint NOT NULL,
  [sdiseaser] smallint NOT NULL,
  [spoisonr] smallint NOT NULL,
  [sbulk] smallint NOT NULL,
  [byattackrange] smallint NOT NULL,
  [bysearchrange] smallint NOT NULL,
  [bytracingrange] smallint NOT NULL,
  [imoney] int NOT NULL,
  [bydirectattack] smallint NOT NULL,
  [bymagicattack] smallint NOT NULL
);

CREATE TABLE dbo.[k_monster_item] (
  [sindex] smallint NOT NULL,
  [iitem01] int NULL,
  [spersent01] smallint NULL,
  [iitem02] int NULL,
  [spersent02] smallint NULL,
  [iitem03] int NULL,
  [spersent03] smallint NULL,
  [iitem04] int NULL,
  [spersent04] smallint NULL,
  [iitem05] int NULL,
  [spersent05] smallint NULL,
  [iitem06] int NULL,
  [spersent06] smallint NULL,
  [iitem07] int NULL,
  [spersent07] smallint NULL
);

CREATE TABLE dbo.[k_npc] (
  [ssid] smallint NULL,
  [strname] nvarchar(100) NULL,
  [spid] smallint NULL,
  [ssize] smallint NULL,
  [iweapon1] int NULL,
  [iweapon2] int NULL,
  [bygroup] smallint NULL,
  [byacttype] smallint NULL,
  [bytype] smallint NULL,
  [byfamily] smallint NULL,
  [byrank] smallint NULL,
  [bytitle] smallint NULL,
  [isellinggroup] int NULL,
  [slevel] smallint NULL,
  [iexp] int NULL,
  [iloyalty] int NULL,
  [ihppoint] int NULL,
  [smppoint] smallint NULL,
  [satk] smallint NULL,
  [sac] smallint NULL,
  [shitrate] smallint NULL,
  [sevaderate] smallint NULL,
  [sdamage] smallint NULL,
  [sattackdelay] smallint NULL,
  [byspeed1] smallint NULL,
  [byspeed2] smallint NULL,
  [sstandtime] smallint NULL,
  [sitem] smallint NULL,
  [imagic1] int NULL,
  [imagic2] int NULL,
  [imagic3] int NULL,
  [sfirer] smallint NULL,
  [scoldr] smallint NULL,
  [slightningr] smallint NULL,
  [smagicr] smallint NULL,
  [sdiseaser] smallint NULL,
  [spoisonr] smallint NULL,
  [sbulk] smallint NULL,
  [byattackrange] smallint NULL,
  [bysearchrange] smallint NULL,
  [bytracingrange] smallint NULL,
  [imoney] int NULL,
  [bydirectattack] smallint NULL,
  [bymagicattack] smallint NULL
);

CREATE TABLE dbo.[k_npc_item] (
  [sindex] smallint NOT NULL,
  [iitem01] int NULL,
  [spersent01] smallint NULL,
  [iitem02] int NULL,
  [spersent02] smallint NULL,
  [iitem03] int NULL,
  [spersent03] smallint NULL,
  [iitem04] int NULL,
  [spersent04] smallint NULL,
  [iitem05] int NULL,
  [spersent05] smallint NULL,
  [iitem06] int NULL,
  [spersent06] smallint NULL,
  [iitem07] int NULL,
  [spersent07] smallint NULL
);

CREATE TABLE dbo.[k_npcorj] (
  [ssid] smallint NOT NULL,
  [strname] nvarchar(max) NULL,
  [spid] smallint NOT NULL,
  [ssize] smallint NOT NULL,
  [iweapon1] int NOT NULL,
  [iweapon2] int NOT NULL,
  [bygroup] smallint NOT NULL,
  [byacttype] smallint NOT NULL,
  [bytype] smallint NOT NULL,
  [byfamily] smallint NOT NULL,
  [byrank] smallint NOT NULL,
  [bytitle] smallint NOT NULL,
  [isellinggroup] int NOT NULL,
  [slevel] smallint NOT NULL,
  [iexp] int NOT NULL,
  [iloyalty] int NOT NULL,
  [ihppoint] int NOT NULL,
  [smppoint] smallint NOT NULL,
  [satk] smallint NOT NULL,
  [sac] smallint NOT NULL,
  [shitrate] smallint NOT NULL,
  [sevaderate] smallint NOT NULL,
  [sdamage] smallint NOT NULL,
  [sattackdelay] smallint NOT NULL,
  [byspeed1] smallint NOT NULL,
  [byspeed2] smallint NOT NULL,
  [sstandtime] smallint NOT NULL,
  [sitem] smallint NOT NULL,
  [imagic1] int NOT NULL,
  [imagic2] int NOT NULL,
  [imagic3] int NOT NULL,
  [sfirer] smallint NOT NULL,
  [scoldr] smallint NOT NULL,
  [slightningr] smallint NOT NULL,
  [smagicr] smallint NOT NULL,
  [sdiseaser] smallint NOT NULL,
  [spoisonr] smallint NOT NULL,
  [sbulk] smallint NOT NULL,
  [byattackrange] smallint NOT NULL,
  [bysearchrange] smallint NOT NULL,
  [bytracingrange] smallint NOT NULL,
  [imoney] int NOT NULL,
  [bydirectattack] smallint NOT NULL,
  [bymagicattack] smallint NOT NULL
);

CREATE TABLE dbo.[k_npcpos] (
  [zoneid] smallint NULL,
  [npcid] int NULL,
  [acttype] smallint NULL,
  [regentype] smallint NULL,
  [dungeonfamily] smallint NULL,
  [specialtype] smallint NULL,
  [trapnumber] smallint NULL,
  [limitminx] int NULL,
  [leftx] int NULL,
  [limitmaxx] int NULL,
  [rightx] int NULL,
  [limitminz] int NULL,
  [topz] int NULL,
  [limitmaxz] int NULL,
  [bottomz] int NULL,
  [numnpc] smallint NULL,
  [regtime] smallint NULL,
  [bydirection] int NULL,
  [dotcnt] smallint NULL,
  [path] nvarchar(4000) NULL,
  [room] smallint NULL
);

CREATE TABLE dbo.[k_objectpos] (
  [zoneid] smallint NOT NULL,
  [belong] smallint NOT NULL,
  [sindex] smallint NOT NULL,
  [type] smallint NOT NULL,
  [controlnpcid] smallint NOT NULL,
  [status] smallint NOT NULL,
  [posx] float NOT NULL,
  [posy] float NOT NULL,
  [posz] float NOT NULL,
  [bylife] smallint NOT NULL
);

CREATE TABLE dbo.[kill_random_item] (
  [number] int NOT NULL,
  [strname] nvarchar(max) NULL,
  [itemid] int NOT NULL,
  [percent] int NOT NULL,
  [days] int NULL,
  [coin] int NULL,
  [count] int NULL
);

CREATE TABLE dbo.[king_ballot_box] (
  [nation] smallint NULL,
  [straccountid] nvarchar(20) NULL,
  [struserid] nvarchar(20) NULL,
  [strcandidatename] nvarchar(20) NULL,
  [logtime] datetime NULL
);

CREATE TABLE dbo.[king_candidacy_notice_board] (
  [bynation] smallint NOT NULL,
  [struserid] nvarchar(21) NOT NULL,
  [strnotice] nvarchar(500) NOT NULL
);

CREATE TABLE dbo.[king_election_list] (
  [bynation] smallint NOT NULL,
  [bytype] smallint NOT NULL,
  [strname] nvarchar(21) NULL,
  [nknights] smallint NULL,
  [nmoney] int NOT NULL
);

CREATE TABLE dbo.[king_nomination_list] (
  [nation] smallint NOT NULL,
  [strnominator] nvarchar(21) NOT NULL,
  [strnominee] nvarchar(21) NOT NULL
);

CREATE TABLE dbo.[king_nomination_result] (
  [bynation] smallint NULL,
  [struserid] nvarchar(21) NULL,
  [brank] smallint NULL,
  [sclanid] smallint NULL,
  [bmonth] smallint NULL,
  [syear] smallint NULL,
  [kingvotes] int NULL,
  [totalvotes] int NULL
);

CREATE TABLE dbo.[king_system] (
  [bynation] smallint NOT NULL,
  [bytype] smallint NOT NULL,
  [syear] smallint NOT NULL,
  [bymonth] smallint NOT NULL,
  [byday] smallint NOT NULL,
  [byhour] smallint NOT NULL,
  [byminute] smallint NOT NULL,
  [byimtype] smallint NOT NULL,
  [simyear] smallint NOT NULL,
  [byimmonth] smallint NOT NULL,
  [byimday] smallint NOT NULL,
  [byimhour] smallint NOT NULL,
  [byimminute] smallint NOT NULL,
  [bynoahevent] smallint NOT NULL,
  [bynoahevent_day] smallint NOT NULL,
  [bynoahevent_hour] smallint NOT NULL,
  [bynoahevent_minute] smallint NOT NULL,
  [snoahevent_duration] smallint NOT NULL,
  [byexpevent] smallint NOT NULL,
  [byexpevent_day] smallint NOT NULL,
  [byexpevent_hour] smallint NOT NULL,
  [byexpevent_minute] smallint NOT NULL,
  [sexpevent_duration] smallint NOT NULL,
  [ntribute] int NOT NULL,
  [byterritorytariff] smallint NOT NULL,
  [nterritorytax] int NOT NULL,
  [nnationaltreasury] int NOT NULL,
  [strkingname] nvarchar(21) NULL,
  [skingclanid] smallint NULL,
  [strimrequestid] nvarchar(21) NULL
);

CREATE TABLE dbo.[knight_royale_beginner_item] (
  [id] smallint NOT NULL,
  [itempos] smallint NOT NULL,
  [nitemid] int NOT NULL,
  [ncount] smallint NOT NULL,
  [ndurability] smallint NOT NULL,
  [nflag] smallint NOT NULL
);

ALTER TABLE dbo.[knight_royale_beginner_item] ADD CONSTRAINT [PK_LAB_knight_royale_beginner_item] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[knight_royale_chest_list] (
  [treasurechestid] smallint NOT NULL,
  [treasurechestssid] smallint NOT NULL,
  [treasurechestposx] smallint NOT NULL,
  [treasurechestposz] smallint NOT NULL,
  [treasurechestspawntimer] int NOT NULL
);

ALTER TABLE dbo.[knight_royale_chest_list] ADD CONSTRAINT [PK_LAB_knight_royale_chest_list] PRIMARY KEY NONCLUSTERED ([treasurechestid]);

CREATE TABLE dbo.[knight_royale_start_position] (
  [nindex] int NULL,
  [posx] smallint NULL,
  [posz] smallint NULL,
  [gasstep] smallint NULL
);

CREATE TABLE dbo.[knight_royale_stats] (
  [slevel] smallint NOT NULL,
  [srequiredexperience] int NOT NULL,
  [stotalhit] smallint NOT NULL,
  [stotalac] smallint NOT NULL,
  [imaxhp] smallint NOT NULL,
  [imaxmp] smallint NOT NULL,
  [sfirer] smallint NOT NULL,
  [scoldr] smallint NOT NULL,
  [slightningr] smallint NOT NULL,
  [smagicr] smallint NOT NULL,
  [sdiseaser] smallint NOT NULL,
  [spoisonr] smallint NOT NULL
);

ALTER TABLE dbo.[knight_royale_stats] ADD CONSTRAINT [PK_LAB_knight_royale_stats] PRIMARY KEY NONCLUSTERED ([slevel]);

CREATE TABLE dbo.[knights] (
  [idnum] smallint NOT NULL,
  [flag] smallint NOT NULL,
  [nation] smallint NOT NULL,
  [ranking] smallint NOT NULL,
  [idname] nvarchar(21) NOT NULL,
  [members] smallint NOT NULL DEFAULT '1',
  [chief] nvarchar(21) NOT NULL,
  [vicechief_1] nvarchar(21) NULL,
  [vicechief_2] nvarchar(21) NULL,
  [vicechief_3] nvarchar(21) NULL,
  [gold] bigint NOT NULL DEFAULT '0',
  [domination] smallint NOT NULL DEFAULT '0',
  [points] int NOT NULL DEFAULT 0,
  [mark] varbinary(max) NULL,
  [smarkversion] smallint NULL DEFAULT '0',
  [smarklen] smallint NULL DEFAULT '0',
  [scape] smallint NOT NULL DEFAULT '-1',
  [bcaper] smallint NOT NULL,
  [bcapeg] smallint NOT NULL,
  [bcapeb] smallint NOT NULL,
  [sallianceknights] smallint NOT NULL DEFAULT '0',
  [clanpointfund] int NOT NULL DEFAULT 0,
  [strclannotice] nvarchar(128) NULL,
  [bysiegeflag] smallint NOT NULL,
  [nlose] smallint NOT NULL DEFAULT '0',
  [nvictory] smallint NOT NULL DEFAULT '0',
  [clanpointmethod] smallint NOT NULL,
  [spremiuminuse] smallint NULL,
  [spremiumtime] int NULL DEFAULT 0,
  [nmoney] int NULL DEFAULT 0,
  [warehousedata] varbinary(max) NULL,
  [strserial] varbinary(max) NULL,
  [warehousedatatime] varbinary(max) NULL
);

CREATE TABLE dbo.[knights_alliance] (
  [smainallianceknights] smallint NOT NULL,
  [ssuballianceknights] smallint NOT NULL DEFAULT '0',
  [smercenaryclan_1] smallint NOT NULL DEFAULT '0',
  [smercenaryclan_2] smallint NOT NULL DEFAULT '0',
  [stralliancenotice] nvarchar(128) NULL
);

CREATE TABLE dbo.[knights_cape] (
  [scapeindex] smallint NOT NULL,
  [strname] nvarchar(30) NOT NULL,
  [nbuyprice] int NOT NULL,
  [nduration] int NOT NULL,
  [bygrade] smallint NOT NULL,
  [nbuyloyalty] int NOT NULL,
  [byranking] smallint NOT NULL,
  [description] nvarchar(max) NULL,
  [btype] smallint NOT NULL,
  [bticket] smallint NOT NULL
);

CREATE TABLE dbo.[knights_castellan] (
  [idnum] smallint NOT NULL,
  [scape] smallint NOT NULL DEFAULT '-1',
  [bcaper] smallint NOT NULL,
  [bcapeg] smallint NOT NULL,
  [bcapeb] smallint NOT NULL,
  [isactive] smallint NOT NULL,
  [remainingtime] bigint NOT NULL
);

CREATE TABLE dbo.[knights_rating] (
  [nrank] int NOT NULL,
  [shindex] smallint NOT NULL,
  [strname] nvarchar(20) NOT NULL,
  [npoints] int NOT NULL,
  [nclanpointfund] int NOT NULL
);

CREATE TABLE dbo.[knights_siege_warfare] (
  [scastleindex] smallint NOT NULL,
  [smasterknights] smallint NOT NULL,
  [bysiegetype] smallint NOT NULL,
  [bywarday] smallint NOT NULL,
  [bywartime] smallint NOT NULL,
  [bywarminute] smallint NOT NULL,
  [schallengelist_1] smallint NOT NULL,
  [schallengelist_2] smallint NOT NULL,
  [schallengelist_3] smallint NOT NULL,
  [schallengelist_4] smallint NOT NULL,
  [schallengelist_5] smallint NOT NULL,
  [schallengelist_6] smallint NOT NULL,
  [schallengelist_7] smallint NOT NULL DEFAULT '0',
  [schallengelist_8] smallint NOT NULL DEFAULT '0',
  [schallengelist_9] smallint NOT NULL DEFAULT '0',
  [schallengelist_10] smallint NOT NULL DEFAULT '0',
  [bywarrequestday] smallint NOT NULL,
  [bywarrequesttime] smallint NOT NULL,
  [bywarrequestminute] smallint NOT NULL,
  [byguerrillawarday] smallint NOT NULL,
  [byguerrillawartime] smallint NOT NULL,
  [byguerrillawarminute] smallint NOT NULL,
  [strchallengelist] nvarchar(50) NULL,
  [smoradontariff] smallint NOT NULL DEFAULT '0',
  [sdellostariff] smallint NOT NULL DEFAULT '0',
  [ndungeoncharge] int NOT NULL DEFAULT 0,
  [nmoradontax] int NOT NULL DEFAULT 0,
  [ndellostax] int NOT NULL DEFAULT 0,
  [srequestlist_1] smallint NOT NULL DEFAULT '0',
  [srequestlist_2] smallint NOT NULL DEFAULT '0',
  [srequestlist_3] smallint NOT NULL DEFAULT '0',
  [srequestlist_4] smallint NOT NULL DEFAULT '0',
  [srequestlist_5] smallint NOT NULL DEFAULT '0',
  [srequestlist_6] smallint NOT NULL DEFAULT '0',
  [srequestlist_7] smallint NOT NULL DEFAULT '0',
  [srequestlist_8] smallint NOT NULL DEFAULT '0',
  [srequestlist_9] smallint NOT NULL DEFAULT '0',
  [srequestlist_10] smallint NOT NULL DEFAULT '0'
);

ALTER TABLE dbo.[knights_siege_warfare] ADD CONSTRAINT [PK_LAB_knights_siege_warfare] PRIMARY KEY NONCLUSTERED ([scastleindex]);

CREATE TABLE dbo.[knights_siege_warfare_barrack] (
  [sindex] bigint IDENTITY(1,1) NOT NULL,
  [baseclanid] smallint NULL,
  [baseposx] smallint NULL,
  [baseposz] smallint NULL
);

ALTER TABLE dbo.[knights_siege_warfare_barrack] ADD CONSTRAINT [PK_LAB_knights_siege_warfare_barrack] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[knights_siege_warfare_rank] (
  [sindex] bigint IDENTITY(1,1) NOT NULL,
  [sbaseclannum] smallint NOT NULL,
  [sbaseclancommander] nvarchar(max) NOT NULL,
  [swarkillcount] smallint NOT NULL,
  [swarbasekillcount] smallint NOT NULL,
  [swarclanbaseremaincount] smallint NOT NULL
);

ALTER TABLE dbo.[knights_siege_warfare_rank] ADD CONSTRAINT [PK_LAB_knights_siege_warfare_rank] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[knights_siege_warfare_rank_result] (
  [sranknumber] int NOT NULL,
  [sbaseclannum] smallint NOT NULL,
  [swarkillcount] smallint NOT NULL,
  [swarbasekillcount] smallint NOT NULL,
  [swarclanbaseremaincount] smallint NOT NULL
);

CREATE TABLE dbo.[knights_siege_warfare_register] (
  [sindex] bigint IDENTITY(1,1) NOT NULL,
  [sbaseclannum] smallint NOT NULL,
  [sbaseclancommander] nvarchar(max) NOT NULL
);

ALTER TABLE dbo.[knights_siege_warfare_register] ADD CONSTRAINT [PK_LAB_knights_siege_warfare_register] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[letter_gift] (
  [gifttype] smallint NOT NULL,
  [senderid] nvarchar(20) NOT NULL,
  [itemname] nvarchar(50) NOT NULL,
  [itemdescription] nvarchar(300) NOT NULL,
  [lettertype] smallint NOT NULL,
  [itemid] int NOT NULL,
  [itemcount] smallint NOT NULL,
  [itemduration] smallint NOT NULL,
  [sendingstatus] smallint NOT NULL,
  [itemtime] int NOT NULL
);

CREATE TABLE dbo.[letter_giftx] (
  [gifttype] smallint NOT NULL,
  [senderid] nvarchar(max) NOT NULL,
  [itemname] nvarchar(max) NOT NULL,
  [itemdescription] nvarchar(max) NOT NULL,
  [lettertype] smallint NOT NULL,
  [itemid] int NOT NULL,
  [itemcount] smallint NOT NULL,
  [itemduration] smallint NOT NULL,
  [sendingstatus] smallint NOT NULL,
  [itemtime] int NOT NULL DEFAULT 0
);

CREATE TABLE dbo.[level_up] (
  [id] int IDENTITY(1,1) NOT NULL,
  [level] smallint NOT NULL,
  [exp] bigint NOT NULL,
  [rebithlevel] smallint NOT NULL
);

ALTER TABLE dbo.[level_up] ADD CONSTRAINT [PK_LAB_level_up] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[magic] (
  [magicnum] int NOT NULL,
  [enname] nvarchar(200) NOT NULL,
  [krname] nvarchar(200) NOT NULL,
  [description] nvarchar(200) NOT NULL,
  [beforeaction] int NOT NULL,
  [targetaction] smallint NOT NULL,
  [selfeffect] smallint NOT NULL,
  [flyingeffect] smallint NOT NULL,
  [targeteffect] smallint NOT NULL,
  [moral] smallint NOT NULL,
  [skilllevel] smallint NOT NULL,
  [skill] smallint NOT NULL,
  [msp] smallint NOT NULL,
  [hp] smallint NOT NULL,
  [ssp] smallint NOT NULL,
  [itemgroup] smallint NOT NULL,
  [useitem] int NOT NULL,
  [casttime] smallint NOT NULL,
  [recasttime] smallint NOT NULL,
  [successrate] smallint NOT NULL,
  [type1] smallint NOT NULL,
  [type2] smallint NOT NULL,
  [range] smallint NOT NULL,
  [etc] smallint NOT NULL,
  [usestanding] smallint NOT NULL
);

CREATE TABLE dbo.[magic_type1] (
  [inum] int NOT NULL,
  [type] smallint NOT NULL,
  [hitrate] smallint NOT NULL,
  [hit] smallint NOT NULL,
  [adddamage] smallint NOT NULL,
  [combotype] smallint NOT NULL,
  [combocount] smallint NOT NULL,
  [combodamage] smallint NOT NULL,
  [range] smallint NOT NULL,
  [delay] smallint NOT NULL
);

CREATE TABLE dbo.[magic_type2] (
  [inum] int NOT NULL,
  [hittype] smallint NOT NULL,
  [hitrate] smallint NOT NULL,
  [adddamage] smallint NOT NULL,
  [addrange] smallint NOT NULL,
  [needarrow] smallint NOT NULL
);

CREATE TABLE dbo.[magic_type3] (
  [inum] int NOT NULL,
  [radius] smallint NOT NULL,
  [directtype] smallint NOT NULL,
  [firstdamage] smallint NOT NULL,
  [timedamage] smallint NOT NULL,
  [duration] smallint NOT NULL,
  [attribute] smallint NOT NULL
);

CREATE TABLE dbo.[magic_type4] (
  [inum] int NOT NULL,
  [bufftype] smallint NOT NULL,
  [radius] smallint NOT NULL,
  [duration] smallint NOT NULL,
  [attackspeed] smallint NOT NULL,
  [speed] smallint NOT NULL,
  [ac] smallint NOT NULL,
  [acpct] smallint NOT NULL,
  [attack] smallint NOT NULL,
  [magicattack] smallint NOT NULL,
  [maxhp] smallint NOT NULL,
  [maxhppct] smallint NOT NULL,
  [maxmp] smallint NOT NULL,
  [maxmppct] smallint NOT NULL,
  [str] smallint NOT NULL,
  [sta] smallint NOT NULL,
  [dex] smallint NOT NULL,
  [intel] smallint NOT NULL,
  [cha] smallint NOT NULL,
  [firer] smallint NOT NULL,
  [coldr] smallint NOT NULL,
  [lightningr] smallint NOT NULL,
  [magicr] smallint NOT NULL,
  [diseaser] smallint NOT NULL,
  [poisonr] smallint NOT NULL,
  [exppct] smallint NOT NULL,
  [specialamount] smallint NOT NULL,
  [hitrate] smallint NOT NULL,
  [avoidrate] smallint NOT NULL
);

CREATE TABLE dbo.[magic_type5] (
  [inum] int NOT NULL,
  [type] smallint NOT NULL,
  [exprecover] smallint NOT NULL,
  [needstone] smallint NOT NULL
);

CREATE TABLE dbo.[magic_type6] (
  [inum] int NOT NULL,
  [name] nvarchar(max) NULL,
  [description] nvarchar(max) NULL,
  [size] smallint NOT NULL,
  [transformid] smallint NOT NULL,
  [duration] smallint NOT NULL,
  [maxhp] smallint NOT NULL,
  [maxmp] smallint NOT NULL,
  [speed] smallint NOT NULL,
  [attackspeed] smallint NOT NULL,
  [totalhit] smallint NOT NULL,
  [totalac] smallint NOT NULL,
  [totalhitrate] smallint NOT NULL,
  [totalevasionrate] smallint NOT NULL,
  [totalfirer] smallint NOT NULL,
  [totalcoldr] smallint NOT NULL,
  [totallightningr] smallint NOT NULL,
  [totalmagicr] smallint NOT NULL,
  [totaldiseaser] smallint NOT NULL,
  [totalpoisonr] smallint NOT NULL,
  [class] smallint NOT NULL,
  [userskilluse] smallint NOT NULL,
  [needitem] smallint NOT NULL,
  [skillsuccessrate] smallint NOT NULL,
  [monsterfriendly] smallint NOT NULL,
  [nation] smallint NOT NULL
);

CREATE TABLE dbo.[magic_type7] (
  [nindex] int NOT NULL,
  [strname] nvarchar(30) NULL,
  [strnote] nvarchar(100) NULL,
  [byvalidgroup] smallint NOT NULL,
  [bynatoinchange] smallint NOT NULL,
  [shmonsternum] smallint NOT NULL,
  [bytargetchange] smallint NOT NULL,
  [bystatechange] smallint NOT NULL,
  [byradius] smallint NOT NULL,
  [shhitrate] smallint NOT NULL,
  [shduration] smallint NOT NULL,
  [shdamage] smallint NOT NULL,
  [byvisoin] smallint NOT NULL,
  [nneeditem] int NOT NULL
);

CREATE TABLE dbo.[magic_type8] (
  [inum] int NOT NULL,
  [name] nvarchar(30) NULL,
  [description] nvarchar(100) NULL,
  [target] smallint NOT NULL,
  [radius] smallint NOT NULL,
  [warptype] smallint NOT NULL,
  [exprecover] smallint NOT NULL,
  [kickdistance] smallint NOT NULL
);

CREATE TABLE dbo.[magic_type9] (
  [inum] int NOT NULL,
  [name] nvarchar(max) NULL,
  [description] nvarchar(max) NULL,
  [validgroup] smallint NOT NULL,
  [nationchange] smallint NOT NULL,
  [monsternum] smallint NOT NULL,
  [targetchange] smallint NOT NULL,
  [statechange] smallint NOT NULL,
  [radius] smallint NOT NULL,
  [hitrate] smallint NOT NULL,
  [duration] smallint NOT NULL,
  [adddamage] smallint NOT NULL,
  [vision] smallint NOT NULL,
  [needitem] int NOT NULL
);

CREATE TABLE dbo.[mail_box] (
  [nletterid] bigint IDENTITY(1,1) NOT NULL,
  [dtsenddate] datetime NULL,
  [dtreaddate] datetime NULL,
  [bstatus] smallint NOT NULL,
  [strsenderid] nvarchar(50) NOT NULL,
  [strrecipientid] nvarchar(50) NOT NULL,
  [strsubject] nvarchar(50) NOT NULL,
  [strmessage] nvarchar(128) NOT NULL,
  [btype] smallint NOT NULL,
  [nitemid] int NOT NULL DEFAULT 0,
  [scount] smallint NOT NULL DEFAULT '0',
  [sdurability] smallint NOT NULL DEFAULT '0',
  [nserialnum] bigint NOT NULL DEFAULT '0',
  [ncoins] int NOT NULL DEFAULT 0,
  [nitemtime] int NOT NULL DEFAULT 0,
  [bdeleted] bit NOT NULL DEFAULT 0
);

ALTER TABLE dbo.[mail_box] ADD CONSTRAINT [PK_LAB_mail_box] PRIMARY KEY NONCLUSTERED ([nletterid]);

CREATE TABLE dbo.[make_defensive] (
  [bylevel] smallint NOT NULL,
  [sclass_1] smallint NULL,
  [sclass_2] smallint NULL,
  [sclass_3] smallint NULL,
  [sclass_4] smallint NULL,
  [sclass_5] smallint NULL,
  [sclass_6] smallint NULL,
  [sclass_7] smallint NULL
);

CREATE TABLE dbo.[make_item] (
  [sindex] smallint NOT NULL,
  [striteminfo] nvarchar(20) NULL,
  [iitemcode] int NOT NULL,
  [byitemlevel] smallint NOT NULL
);

CREATE TABLE dbo.[make_item_gradecode] (
  [byitemindex] smallint NOT NULL,
  [bygrade_1] smallint NOT NULL,
  [bygrade_2] smallint NULL,
  [bygrade_3] smallint NULL,
  [bygrade_4] smallint NULL,
  [bygrade_5] smallint NULL,
  [bygrade_6] smallint NULL,
  [bygrade_7] smallint NULL,
  [bygrade_8] smallint NULL,
  [bygrade_9] smallint NULL
);

CREATE TABLE dbo.[make_item_group] (
  [desc] nvarchar(75) NULL,
  [iitemgroupnum] int NOT NULL,
  [iitem_1] int NOT NULL,
  [iitem_2] int NOT NULL,
  [iitem_3] int NOT NULL,
  [iitem_4] int NOT NULL,
  [iitem_5] int NOT NULL,
  [iitem_6] int NOT NULL,
  [iitem_7] int NOT NULL,
  [iitem_8] int NOT NULL,
  [iitem_9] int NOT NULL,
  [iitem_10] int NOT NULL,
  [iitem_11] int NOT NULL,
  [iitem_12] int NOT NULL,
  [iitem_13] int NOT NULL,
  [iitem_14] int NOT NULL,
  [iitem_15] int NOT NULL,
  [iitem_16] int NOT NULL,
  [iitem_17] int NOT NULL,
  [iitem_18] int NOT NULL,
  [iitem_19] int NOT NULL,
  [iitem_20] int NOT NULL,
  [iitem_21] int NOT NULL,
  [iitem_22] int NOT NULL,
  [iitem_23] int NOT NULL,
  [iitem_24] int NOT NULL,
  [iitem_25] int NOT NULL,
  [iitem_26] int NOT NULL,
  [iitem_27] int NOT NULL,
  [iitem_28] int NOT NULL,
  [iitem_29] int NOT NULL,
  [iitem_30] int NOT NULL,
  [iitem_31] int NOT NULL,
  [iitem_32] int NOT NULL,
  [iitem_33] int NOT NULL,
  [iitem_34] int NOT NULL,
  [iitem_35] int NOT NULL,
  [iitem_36] int NOT NULL,
  [iitem_37] int NOT NULL,
  [iitem_38] int NOT NULL,
  [iitem_39] int NOT NULL,
  [iitem_40] int NOT NULL,
  [iitem_41] int NOT NULL,
  [iitem_42] int NOT NULL,
  [iitem_43] int NOT NULL,
  [iitem_44] int NOT NULL,
  [iitem_45] int NOT NULL,
  [iitem_46] int NOT NULL,
  [iitem_47] int NOT NULL,
  [iitem_48] int NOT NULL,
  [iitem_49] int NOT NULL,
  [iitem_50] int NOT NULL,
  [iitem_51] int NOT NULL,
  [iitem_52] int NOT NULL,
  [iitem_53] int NOT NULL,
  [iitem_54] int NOT NULL,
  [iitem_55] int NOT NULL,
  [iitem_56] int NOT NULL,
  [iitem_57] int NOT NULL,
  [iitem_58] int NOT NULL,
  [iitem_59] int NOT NULL,
  [iitem_60] int NOT NULL,
  [iitem_61] int NOT NULL,
  [iitem_62] int NOT NULL,
  [iitem_63] int NOT NULL,
  [iitem_64] int NOT NULL,
  [iitem_65] int NOT NULL,
  [iitem_66] int NOT NULL,
  [iitem_67] int NOT NULL,
  [iitem_68] int NOT NULL,
  [iitem_69] int NOT NULL,
  [iitem_70] int NOT NULL,
  [iitem_71] int NOT NULL,
  [iitem_72] int NOT NULL,
  [iitem_73] int NOT NULL,
  [iitem_74] int NOT NULL,
  [iitem_75] int NOT NULL,
  [iitem_76] int NOT NULL,
  [iitem_77] int NOT NULL,
  [iitem_78] int NOT NULL,
  [iitem_79] int NOT NULL,
  [iitem_80] int NOT NULL,
  [iitem_81] int NOT NULL,
  [iitem_82] int NOT NULL,
  [iitem_83] int NOT NULL,
  [iitem_84] int NOT NULL,
  [iitem_85] int NOT NULL,
  [iitem_86] int NOT NULL,
  [iitem_87] int NOT NULL,
  [iitem_88] int NOT NULL,
  [iitem_89] int NOT NULL,
  [iitem_90] int NOT NULL,
  [iitem_91] int NOT NULL,
  [iitem_92] int NOT NULL,
  [iitem_93] int NOT NULL,
  [iitem_94] int NOT NULL,
  [iitem_95] int NOT NULL,
  [iitem_96] int NOT NULL,
  [iitem_97] int NOT NULL,
  [iitem_98] int NOT NULL,
  [iitem_99] int NOT NULL,
  [iitem_100] int NOT NULL,
  [iitem_101] int NOT NULL,
  [iitem_102] int NOT NULL,
  [iitem_103] int NOT NULL,
  [iitem_104] int NOT NULL,
  [iitem_105] int NOT NULL,
  [iitem_106] int NOT NULL,
  [iitem_107] int NOT NULL,
  [iitem_108] int NOT NULL,
  [iitem_109] int NOT NULL,
  [iitem_110] int NOT NULL,
  [iitem_111] int NOT NULL,
  [iitem_112] int NOT NULL,
  [iitem_113] int NOT NULL,
  [iitem_114] int NOT NULL,
  [iitem_115] int NOT NULL,
  [iitem_116] int NOT NULL,
  [iitem_117] int NOT NULL,
  [iitem_118] int NOT NULL,
  [iitem_119] int NOT NULL,
  [iitem_120] int NOT NULL,
  [iitem_121] int NOT NULL,
  [iitem_122] int NOT NULL,
  [iitem_123] int NOT NULL,
  [iitem_124] int NOT NULL,
  [iitem_125] int NOT NULL,
  [iitem_126] int NOT NULL,
  [iitem_127] int NOT NULL,
  [iitem_128] int NOT NULL,
  [iitem_129] int NOT NULL,
  [iitem_130] int NOT NULL,
  [iitem_131] int NOT NULL,
  [iitem_132] int NOT NULL,
  [iitem_133] int NOT NULL,
  [iitem_134] int NOT NULL,
  [iitem_135] int NOT NULL,
  [iitem_136] int NOT NULL,
  [iitem_137] int NOT NULL,
  [iitem_138] int NOT NULL,
  [iitem_139] int NOT NULL,
  [iitem_140] int NOT NULL,
  [iitem_141] int NOT NULL,
  [iitem_142] int NOT NULL,
  [iitem_143] int NOT NULL,
  [iitem_144] int NOT NULL,
  [iitem_145] int NOT NULL,
  [iitem_146] int NOT NULL,
  [iitem_147] int NOT NULL,
  [iitem_148] int NOT NULL,
  [iitem_149] int NOT NULL,
  [iitem_150] int NOT NULL,
  [iitem_151] int NOT NULL,
  [iitem_152] int NOT NULL,
  [iitem_153] int NOT NULL,
  [iitem_154] int NOT NULL,
  [iitem_155] int NOT NULL,
  [iitem_156] int NOT NULL,
  [iitem_157] int NOT NULL,
  [iitem_158] int NOT NULL,
  [iitem_159] int NOT NULL,
  [iitem_160] int NOT NULL,
  [iitem_161] int NOT NULL,
  [iitem_162] int NOT NULL,
  [iitem_163] int NOT NULL,
  [iitem_164] int NOT NULL,
  [iitem_165] int NOT NULL,
  [iitem_166] int NOT NULL,
  [iitem_167] int NOT NULL,
  [iitem_168] int NOT NULL,
  [iitem_169] int NOT NULL,
  [iitem_170] int NOT NULL,
  [iitem_171] int NOT NULL,
  [iitem_172] int NOT NULL,
  [iitem_173] int NOT NULL,
  [iitem_174] int NOT NULL,
  [iitem_175] int NOT NULL,
  [iitem_176] int NOT NULL,
  [iitem_177] int NOT NULL,
  [iitem_178] int NOT NULL,
  [iitem_179] int NOT NULL,
  [iitem_180] int NOT NULL,
  [iitem_181] int NOT NULL,
  [iitem_182] int NOT NULL,
  [iitem_183] int NOT NULL,
  [iitem_184] int NOT NULL,
  [iitem_185] int NOT NULL,
  [iitem_186] int NOT NULL,
  [iitem_187] int NOT NULL,
  [iitem_188] int NOT NULL,
  [iitem_189] int NOT NULL,
  [iitem_190] int NOT NULL,
  [iitem_191] int NOT NULL,
  [iitem_192] int NOT NULL,
  [iitem_193] int NOT NULL,
  [iitem_194] int NOT NULL,
  [iitem_195] int NOT NULL,
  [iitem_196] int NOT NULL,
  [iitem_197] int NOT NULL,
  [iitem_198] int NOT NULL,
  [iitem_199] int NOT NULL,
  [iitem_200] int NOT NULL
);

CREATE TABLE dbo.[make_item_group_old] (
  [desc] nvarchar(max) NULL,
  [iitemgroupnum] int NOT NULL,
  [iitem_1] int NOT NULL,
  [iitem_2] int NOT NULL,
  [iitem_3] int NOT NULL,
  [iitem_4] int NOT NULL,
  [iitem_5] int NOT NULL,
  [iitem_6] int NOT NULL,
  [iitem_7] int NOT NULL,
  [iitem_8] int NOT NULL,
  [iitem_9] int NOT NULL,
  [iitem_10] int NOT NULL,
  [iitem_11] int NOT NULL,
  [iitem_12] int NOT NULL,
  [iitem_13] int NOT NULL,
  [iitem_14] int NOT NULL,
  [iitem_15] int NOT NULL,
  [iitem_16] int NOT NULL,
  [iitem_17] int NOT NULL,
  [iitem_18] int NOT NULL,
  [iitem_19] int NOT NULL,
  [iitem_20] int NOT NULL,
  [iitem_21] int NOT NULL,
  [iitem_22] int NOT NULL,
  [iitem_23] int NOT NULL,
  [iitem_24] int NOT NULL,
  [iitem_25] int NOT NULL,
  [iitem_26] int NOT NULL,
  [iitem_27] int NOT NULL,
  [iitem_28] int NOT NULL,
  [iitem_29] int NOT NULL,
  [iitem_30] int NOT NULL,
  [iitem_31] int NOT NULL,
  [iitem_32] int NOT NULL,
  [iitem_33] int NOT NULL,
  [iitem_34] int NOT NULL,
  [iitem_35] int NOT NULL,
  [iitem_36] int NOT NULL,
  [iitem_37] int NOT NULL,
  [iitem_38] int NOT NULL,
  [iitem_39] int NOT NULL,
  [iitem_40] int NOT NULL,
  [iitem_41] int NOT NULL,
  [iitem_42] int NOT NULL,
  [iitem_43] int NOT NULL,
  [iitem_44] int NOT NULL,
  [iitem_45] int NOT NULL,
  [iitem_46] int NOT NULL,
  [iitem_47] int NOT NULL,
  [iitem_48] int NOT NULL,
  [iitem_49] int NOT NULL,
  [iitem_50] int NOT NULL,
  [iitem_51] int NOT NULL,
  [iitem_52] int NOT NULL,
  [iitem_53] int NOT NULL,
  [iitem_54] int NOT NULL,
  [iitem_55] int NOT NULL,
  [iitem_56] int NOT NULL,
  [iitem_57] int NOT NULL,
  [iitem_58] int NOT NULL,
  [iitem_59] int NOT NULL,
  [iitem_60] int NOT NULL,
  [iitem_61] int NOT NULL,
  [iitem_62] int NOT NULL,
  [iitem_63] int NOT NULL,
  [iitem_64] int NOT NULL,
  [iitem_65] int NOT NULL,
  [iitem_66] int NOT NULL,
  [iitem_67] int NOT NULL,
  [iitem_68] int NOT NULL,
  [iitem_69] int NOT NULL,
  [iitem_70] int NOT NULL,
  [iitem_71] int NOT NULL,
  [iitem_72] int NOT NULL,
  [iitem_73] int NOT NULL,
  [iitem_74] int NOT NULL,
  [iitem_75] int NOT NULL,
  [iitem_76] int NOT NULL,
  [iitem_77] int NOT NULL,
  [iitem_78] int NOT NULL,
  [iitem_79] int NOT NULL,
  [iitem_80] int NOT NULL,
  [iitem_81] int NOT NULL,
  [iitem_82] int NOT NULL,
  [iitem_83] int NOT NULL,
  [iitem_84] int NOT NULL,
  [iitem_85] int NOT NULL,
  [iitem_86] int NOT NULL,
  [iitem_87] int NOT NULL,
  [iitem_88] int NOT NULL,
  [iitem_89] int NOT NULL,
  [iitem_90] int NOT NULL,
  [iitem_91] int NOT NULL,
  [iitem_92] int NOT NULL,
  [iitem_93] int NOT NULL,
  [iitem_94] int NOT NULL,
  [iitem_95] int NOT NULL,
  [iitem_96] int NOT NULL,
  [iitem_97] int NOT NULL,
  [iitem_98] int NOT NULL,
  [iitem_99] int NOT NULL,
  [iitem_100] int NOT NULL,
  [iitem_101] int NOT NULL,
  [iitem_102] int NOT NULL,
  [iitem_103] int NOT NULL,
  [iitem_104] int NOT NULL,
  [iitem_105] int NOT NULL,
  [iitem_106] int NOT NULL,
  [iitem_107] int NOT NULL,
  [iitem_108] int NOT NULL,
  [iitem_109] int NOT NULL,
  [iitem_110] int NOT NULL,
  [iitem_111] int NOT NULL,
  [iitem_112] int NOT NULL,
  [iitem_113] int NOT NULL,
  [iitem_114] int NOT NULL,
  [iitem_115] int NOT NULL,
  [iitem_116] int NOT NULL,
  [iitem_117] int NOT NULL,
  [iitem_118] int NOT NULL,
  [iitem_119] int NOT NULL,
  [iitem_120] int NOT NULL,
  [iitem_121] int NOT NULL,
  [iitem_122] int NOT NULL,
  [iitem_123] int NOT NULL,
  [iitem_124] int NOT NULL,
  [iitem_125] int NOT NULL,
  [iitem_126] int NOT NULL,
  [iitem_127] int NOT NULL,
  [iitem_128] int NOT NULL,
  [iitem_129] int NOT NULL,
  [iitem_130] int NOT NULL,
  [iitem_131] int NOT NULL,
  [iitem_132] int NOT NULL,
  [iitem_133] int NOT NULL,
  [iitem_134] int NOT NULL,
  [iitem_135] int NOT NULL,
  [iitem_136] int NOT NULL,
  [iitem_137] int NOT NULL,
  [iitem_138] int NOT NULL,
  [iitem_139] int NOT NULL,
  [iitem_140] int NOT NULL,
  [iitem_141] int NOT NULL,
  [iitem_142] int NOT NULL,
  [iitem_143] int NOT NULL,
  [iitem_144] int NOT NULL,
  [iitem_145] int NOT NULL,
  [iitem_146] int NOT NULL,
  [iitem_147] int NOT NULL,
  [iitem_148] int NOT NULL,
  [iitem_149] int NOT NULL,
  [iitem_150] int NOT NULL,
  [iitem_151] int NOT NULL,
  [iitem_152] int NOT NULL,
  [iitem_153] int NOT NULL,
  [iitem_154] int NOT NULL,
  [iitem_155] int NOT NULL,
  [iitem_156] int NOT NULL,
  [iitem_157] int NOT NULL,
  [iitem_158] int NOT NULL,
  [iitem_159] int NOT NULL,
  [iitem_160] int NOT NULL,
  [iitem_161] int NOT NULL,
  [iitem_162] int NOT NULL,
  [iitem_163] int NOT NULL,
  [iitem_164] int NOT NULL,
  [iitem_165] int NOT NULL,
  [iitem_166] int NOT NULL,
  [iitem_167] int NOT NULL,
  [iitem_168] int NOT NULL,
  [iitem_169] int NOT NULL,
  [iitem_170] int NOT NULL,
  [iitem_171] int NOT NULL,
  [iitem_172] int NOT NULL,
  [iitem_173] int NOT NULL,
  [iitem_174] int NOT NULL,
  [iitem_175] int NOT NULL,
  [iitem_176] int NOT NULL,
  [iitem_177] int NOT NULL,
  [iitem_178] int NOT NULL,
  [iitem_179] int NOT NULL,
  [iitem_180] int NOT NULL,
  [iitem_181] int NOT NULL,
  [iitem_182] int NOT NULL,
  [iitem_183] int NOT NULL,
  [iitem_184] int NOT NULL,
  [iitem_185] int NOT NULL,
  [iitem_186] int NOT NULL,
  [iitem_187] int NOT NULL,
  [iitem_188] int NOT NULL,
  [iitem_189] int NOT NULL,
  [iitem_190] int NOT NULL,
  [iitem_191] int NOT NULL,
  [iitem_192] int NOT NULL,
  [iitem_193] int NOT NULL,
  [iitem_194] int NOT NULL,
  [iitem_195] int NOT NULL,
  [iitem_196] int NOT NULL,
  [iitem_197] int NOT NULL,
  [iitem_198] int NOT NULL,
  [iitem_199] int NOT NULL,
  [iitem_200] int NOT NULL
);

CREATE TABLE dbo.[make_item_larecode] (
  [bylevelgrade] smallint NOT NULL,
  [supgradeitem] smallint NOT NULL,
  [slareitem] smallint NOT NULL,
  [smagicitem] smallint NOT NULL,
  [sgereralitem] smallint NOT NULL
);

CREATE TABLE dbo.[make_weapon] (
  [bylevel] smallint NOT NULL,
  [sclass_1] smallint NULL,
  [sclass_2] smallint NULL,
  [sclass_3] smallint NULL,
  [sclass_4] smallint NULL,
  [sclass_5] smallint NULL,
  [sclass_6] smallint NULL,
  [sclass_7] smallint NULL,
  [sclass_8] smallint NULL,
  [sclass_9] smallint NULL,
  [sclass_10] smallint NULL,
  [sclass_11] smallint NULL,
  [sclass_12] smallint NULL
);

CREATE TABLE dbo.[mining_exchange] (
  [nindex] smallint NOT NULL,
  [snpcid] smallint NULL,
  [giveeffect] smallint NULL,
  [oretype] smallint NULL,
  [noriginitemname] nvarchar(50) NULL,
  [noriginitemnum] int NULL,
  [ngiveitemname] nvarchar(50) NULL,
  [ngiveitemnum] int NULL,
  [ngiveitemcount] smallint NULL,
  [succesrate] int NULL
);

CREATE TABLE dbo.[mining_fishing_item] (
  [nindex] bigint IDENTITY(1,1) NOT NULL,
  [ntabletype] int NOT NULL,
  [nwarstatus] int NOT NULL,
  [useitemtype] smallint NOT NULL,
  [ngiveitemname] nvarchar(50) NOT NULL,
  [ngiveitemid] int NOT NULL,
  [ngiveitemcount] int NOT NULL,
  [successrate] int NOT NULL
);

ALTER TABLE dbo.[mining_fishing_item] ADD CONSTRAINT [PK_LAB_mining_fishing_item] PRIMARY KEY NONCLUSTERED ([nindex]);

CREATE TABLE dbo.[monster_challenge] (
  [sindex] smallint NOT NULL,
  [bstarttime1] smallint NOT NULL,
  [bstarttime2] smallint NOT NULL,
  [bstarttime3] smallint NOT NULL,
  [blevelmin] smallint NOT NULL,
  [blevelmax] smallint NOT NULL
);

CREATE TABLE dbo.[monster_challenge_summon_list] (
  [sindex] smallint NOT NULL,
  [blevel] smallint NOT NULL,
  [bstage] smallint NOT NULL,
  [bstagelevel] smallint NOT NULL,
  [stime] smallint NOT NULL,
  [ssid] smallint NOT NULL,
  [strname] nvarchar(50) NULL,
  [scount] smallint NOT NULL,
  [sposx] smallint NOT NULL,
  [sposz] smallint NOT NULL,
  [brange] smallint NOT NULL
);

CREATE TABLE dbo.[monster_juraid_mountain_respawn_list] (
  [sindex] smallint NOT NULL,
  [ssid] smallint NOT NULL,
  [btype] smallint NOT NULL,
  [strname] nvarchar(30) NOT NULL,
  [spid] smallint NOT NULL,
  [zoneid] smallint NOT NULL,
  [family] smallint NOT NULL DEFAULT '0',
  [scount] smallint NOT NULL,
  [x] smallint NOT NULL,
  [y] smallint NOT NULL,
  [z] smallint NOT NULL,
  [bydirection] smallint NULL,
  [bradius] smallint NULL
);

CREATE TABLE dbo.[monster_resource] (
  [ssid] smallint NOT NULL,
  [strsidname] nvarchar(30) NOT NULL,
  [strresource] nvarchar(250) NOT NULL,
  [snoticezone] smallint NOT NULL,
  [snoticetype] smallint NOT NULL
);

CREATE TABLE dbo.[monster_respawn_stable_list] (
  [sindex] smallint NOT NULL,
  [groupnumber] smallint NOT NULL,
  [ssid] smallint NOT NULL,
  [isnpc] smallint NOT NULL,
  [szoneid] smallint NOT NULL,
  [scount] smallint NOT NULL,
  [sradius] smallint NOT NULL,
  [isdeadtime] int NOT NULL
);

ALTER TABLE dbo.[monster_respawn_stable_list] ADD CONSTRAINT [PK_LAB_monster_respawn_stable_list] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[monster_respawn_variable_list] (
  [sindex] smallint NOT NULL,
  [ssid] smallint NOT NULL,
  [stype] smallint NOT NULL,
  [szoneid] smallint NULL,
  [scount] smallint NOT NULL,
  [sradius] smallint NOT NULL,
  [isdeadtime] int NULL
);

ALTER TABLE dbo.[monster_respawn_variable_list] ADD CONSTRAINT [PK_LAB_monster_respawn_variable_list] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[monster_stone_respawn_list] (
  [sindex] smallint NOT NULL,
  [ssid] smallint NOT NULL,
  [btype] smallint NOT NULL,
  [strname] nvarchar(110) NOT NULL,
  [spid] smallint NOT NULL,
  [zoneid] smallint NOT NULL,
  [isboss] smallint NOT NULL,
  [family] smallint NOT NULL DEFAULT '0',
  [scount] smallint NOT NULL,
  [bydirection] smallint NULL,
  [x] smallint NOT NULL,
  [y] smallint NOT NULL,
  [z] smallint NOT NULL
);

ALTER TABLE dbo.[monster_stone_respawn_list] ADD CONSTRAINT [PK_LAB_monster_stone_respawn_list] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[monster_summon_list] (
  [ssid] smallint NOT NULL,
  [strname] nvarchar(30) NOT NULL,
  [slevel] smallint NOT NULL,
  [sprobability] smallint NOT NULL,
  [btype] smallint NOT NULL
);

CREATE TABLE dbo.[monster_under_the_castle] (
  [sindex] smallint NOT NULL,
  [ssid] smallint NULL,
  [strname] nvarchar(50) NULL,
  [btype] smallint NULL,
  [trapnumber] smallint NULL,
  [x] smallint NULL,
  [y] smallint NULL,
  [z] smallint NULL,
  [bydirection] smallint NULL,
  [scount] smallint NULL,
  [bradius] smallint NULL
);

ALTER TABLE dbo.[monster_under_the_castle] ADD CONSTRAINT [PK_LAB_monster_under_the_castle] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[new_char_value] (
  [classtype] smallint NULL,
  [jobtype] smallint NULL,
  [level] smallint NULL,
  [exp] bigint NULL,
  [strength] smallint NULL,
  [health] smallint NULL,
  [dexterity] smallint NULL,
  [intelligence] smallint NULL,
  [magicpower] smallint NULL,
  [freepoints] smallint NULL,
  [skillpointfree] smallint NULL,
  [skillpointcat1] smallint NULL,
  [skillpointcat2] smallint NULL,
  [skillpointcat3] smallint NULL,
  [skillpointmaster] smallint NULL,
  [gold] int NULL,
  [hp] smallint NULL,
  [mp] smallint NULL
);

CREATE TABLE dbo.[pet_image_change] (
  [sindex] bigint IDENTITY(1,1) NOT NULL,
  [nreqitem0] int NULL,
  [nreqitem1] int NULL,
  [nreqitem2] int NULL,
  [nreplaceitem] int NULL,
  [sreplacespid] smallint NULL,
  [sreplacesize] smallint NULL,
  [strname] nvarchar(50) NULL,
  [spercent] smallint NULL
);

ALTER TABLE dbo.[pet_image_change] ADD CONSTRAINT [PK_LAB_pet_image_change] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[pet_stats_info] (
  [petlevel] smallint NULL,
  [petmaxhp] smallint NULL,
  [petmaxsp] smallint NULL,
  [petattack] smallint NULL,
  [petdefence] smallint NULL,
  [petres] smallint NULL,
  [petexp] int NULL
);

CREATE TABLE dbo.[pet_talk] (
  [sindex] bigint IDENTITY(1,1) NOT NULL,
  [strword] nvarchar(20) NULL,
  [strmessage] nvarchar(100) NULL,
  [stremo] nvarchar(50) NULL,
  [srand] smallint NULL
);

ALTER TABLE dbo.[pet_talk] ADD CONSTRAINT [PK_LAB_pet_talk] PRIMARY KEY NONCLUSTERED ([sindex]);

CREATE TABLE dbo.[pet_user_data] (
  [nserialid] bigint NULL,
  [spetname] nvarchar(15) NULL,
  [blevel] smallint NULL,
  [shp] smallint NULL,
  [smp] smallint NULL,
  [sitems] varbinary(max) NULL,
  [nindex] int NULL,
  [ssatisfaction] smallint NULL,
  [nexp] int NULL,
  [spid] smallint NULL,
  [ssize] smallint NULL
);

CREATE TABLE dbo.[ppcard_list] (
  [ppkeycode] nvarchar(20) NULL,
  [knightcash] int NULL,
  [status] smallint NULL,
  [updatedate] datetime NULL,
  [straccountid] nvarchar(21) NULL
);

CREATE TABLE dbo.[premium_gift_item] (
  [bpremiumtype] smallint NULL,
  [ibonusitemnum] int NULL,
  [scount] smallint NULL,
  [strsender] nvarchar(21) NULL,
  [strsubject] nvarchar(50) NULL,
  [strmessage] nvarchar(128) NULL
);

CREATE TABLE dbo.[premium_item] (
  [type] smallint NOT NULL,
  [strname] nvarchar(50) NULL,
  [exprestorepercent] smallint NOT NULL,
  [noahpercent] smallint NOT NULL,
  [droppercent] smallint NOT NULL,
  [bonusloyalty] int NOT NULL,
  [repairdiscountpercent] smallint NOT NULL,
  [itemsellpercent] smallint NOT NULL
);

ALTER TABLE dbo.[premium_item] ADD CONSTRAINT [PK_LAB_premium_item] PRIMARY KEY NONCLUSTERED ([type]);

CREATE TABLE dbo.[premium_item_exp] (
  [nindex] smallint NOT NULL,
  [type] smallint NOT NULL,
  [minlevel] smallint NOT NULL,
  [maxlevel] smallint NOT NULL,
  [spercent] smallint NOT NULL
);

ALTER TABLE dbo.[premium_item_exp] ADD CONSTRAINT [PK_LAB_premium_item_exp] PRIMARY KEY NONCLUSTERED ([nindex]);

CREATE TABLE dbo.[pus_banner] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [bannerimage] nvarchar(max) NOT NULL
);

ALTER TABLE dbo.[pus_banner] ADD CONSTRAINT [PK_LAB_pus_banner] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[pus_cash] (
  [cashid] bigint IDENTITY(1,1) NOT NULL,
  [total] int NOT NULL,
  [cash] int NOT NULL,
  [aciklama] nvarchar(max) NOT NULL,
  [pid] int NOT NULL
);

ALTER TABLE dbo.[pus_cash] ADD CONSTRAINT [PK_LAB_pus_cash] PRIMARY KEY NONCLUSTERED ([cashid]);

CREATE TABLE dbo.[pus_esn_code] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [serial1] nvarchar(max) NOT NULL,
  [serial2] nvarchar(max) NOT NULL,
  [serial3] nvarchar(max) NOT NULL,
  [serial4] nvarchar(max) NOT NULL,
  [byused] int NOT NULL,
  [cashpoint] int NOT NULL,
  [bonuscashpoint] int NOT NULL
);

ALTER TABLE dbo.[pus_esn_code] ADD CONSTRAINT [PK_LAB_pus_esn_code] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[pus_items] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [itemid] int NOT NULL,
  [stritemname] nvarchar(max) NULL,
  [stritemtitle] nvarchar(max) NULL,
  [price] int NULL,
  [dcprice] int NULL,
  [image] nvarchar(max) NULL,
  [sendtype] int NULL,
  [itemtype] int NULL,
  [buycount] int NOT NULL,
  [bannerimage] nvarchar(max) NULL,
  [stritemdesc] nvarchar(max) NOT NULL,
  [expirationtime] int NOT NULL
);

ALTER TABLE dbo.[pus_items] ADD CONSTRAINT [PK_LAB_pus_items] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[pus_menu] (
  [id] int NOT NULL,
  [strid] nvarchar(max) NULL,
  [strmenutype] nvarchar(max) NULL
);

ALTER TABLE dbo.[pus_menu] ADD CONSTRAINT [PK_LAB_pus_menu] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[pus_session] (
  [straccountid] nvarchar(max) NULL,
  [struserid] nvarchar(max) NULL,
  [strclass] nvarchar(max) NULL,
  [strlevel] nvarchar(max) NULL,
  [strparam] nvarchar(max) NULL,
  [strdata] datetime NULL,
  [id] bigint IDENTITY(1,1) NOT NULL
);

ALTER TABLE dbo.[pus_session] ADD CONSTRAINT [PK_LAB_pus_session] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[quest_helper] (
  [nindex] int NOT NULL,
  [bmessagetype] smallint NOT NULL,
  [blevel] smallint NOT NULL,
  [nexp] int NOT NULL,
  [bclass] smallint NOT NULL,
  [bnation] smallint NOT NULL,
  [bquesttype] smallint NOT NULL,
  [bzone] smallint NOT NULL,
  [snpcid] smallint NOT NULL,
  [seventdataindex] smallint NOT NULL,
  [beventstatus] smallint NOT NULL,
  [neventtriggerindex] int NOT NULL,
  [neventcompleteindex] int NOT NULL,
  [nexchangeindex] int NOT NULL,
  [neventtalkindex] int NOT NULL,
  [strluafilename] nvarchar(40) NOT NULL,
  [squestmenu] int NOT NULL,
  [snpcmain] int NOT NULL,
  [squestsolo] smallint NOT NULL
);

CREATE TABLE dbo.[quest_menu_us] (
  [inum] int NOT NULL,
  [strmenu] nvarchar(100) NOT NULL
);

CREATE TABLE dbo.[quest_monster] (
  [squestnum] smallint NOT NULL,
  [snum1a] smallint NOT NULL,
  [snum1b] smallint NOT NULL,
  [snum1c] smallint NOT NULL,
  [snum1d] smallint NOT NULL,
  [scount1] smallint NOT NULL,
  [snum2a] smallint NOT NULL,
  [snum2b] smallint NOT NULL,
  [snum2c] smallint NOT NULL,
  [snum2d] smallint NOT NULL,
  [scount2] smallint NOT NULL,
  [snum3a] smallint NOT NULL,
  [snum3b] smallint NOT NULL,
  [snum3c] smallint NOT NULL,
  [snum3d] smallint NOT NULL,
  [scount3] smallint NOT NULL,
  [snum4a] smallint NOT NULL,
  [snum4b] smallint NOT NULL,
  [snum4c] smallint NOT NULL,
  [snum4d] smallint NOT NULL,
  [scount4] smallint NOT NULL
);

CREATE TABLE dbo.[quest_skills_closed_check] (
  [nindex] bigint IDENTITY(1,1) NOT NULL,
  [seventdataindex] smallint NOT NULL,
  [nnation] smallint NULL
);

ALTER TABLE dbo.[quest_skills_closed_check] ADD CONSTRAINT [PK_LAB_quest_skills_closed_check] PRIMARY KEY NONCLUSTERED ([seventdataindex]);

CREATE TABLE dbo.[quest_skills_closed_data] (
  [struserid] nvarchar(21) NULL,
  [strquestskill] varbinary(max) NULL,
  [strquestskillcount] smallint NULL,
  [strcheck] smallint NULL
);

CREATE TABLE dbo.[quest_skills_open_set_up] (
  [nindex] bigint IDENTITY(1,1) NOT NULL,
  [neventdataindex] smallint NOT NULL
);

ALTER TABLE dbo.[quest_skills_open_set_up] ADD CONSTRAINT [PK_LAB_quest_skills_open_set_up] PRIMARY KEY NONCLUSTERED ([neventdataindex]);

CREATE TABLE dbo.[quest_talk_us] (
  [inum] int NOT NULL,
  [strtalk] nvarchar(1000) NOT NULL
);

CREATE TABLE dbo.[rental_item] (
  [nrentalindex] int NOT NULL,
  [nitemindex] int NULL,
  [sdurability] smallint NULL DEFAULT '0',
  [nserialnumber] bigint NULL,
  [byregtype] smallint NULL,
  [byitemtype] smallint NULL,
  [byclass] smallint NULL,
  [srentaltime] smallint NULL,
  [nrentalmoney] int NULL,
  [strlendercharid] nvarchar(21) NULL,
  [strlenderacid] nvarchar(21) NULL,
  [strborrowercharid] nvarchar(21) NULL,
  [strborroweracid] nvarchar(21) NULL,
  [timelender] datetime NULL,
  [timeregister] datetime NULL
);

ALTER TABLE dbo.[rental_item] ADD CONSTRAINT [PK_LAB_rental_item] PRIMARY KEY NONCLUSTERED ([nrentalindex]);

CREATE TABLE dbo.[rental_item_list] (
  [nrentalindex] int NOT NULL,
  [nitemindex] int NULL,
  [sdurability] smallint NULL,
  [nserialnumber] bigint NULL,
  [byregtype] smallint NULL,
  [byitemtype] smallint NULL,
  [byclass] smallint NULL,
  [srentaltime] smallint NULL,
  [nrentalmoney] int NULL,
  [strlendercharid] nvarchar(21) NULL,
  [strlenderacid] nvarchar(21) NULL,
  [strborrowercharid] nvarchar(21) NULL,
  [strborroweracid] nvarchar(21) NULL,
  [timelender] datetime NULL,
  [timeregister] datetime NULL
);

ALTER TABLE dbo.[rental_item_list] ADD CONSTRAINT [PK_LAB_rental_item_list] PRIMARY KEY NONCLUSTERED ([nrentalindex]);

CREATE TABLE dbo.[return_is_letter_item] (
  [id] smallint NOT NULL,
  [nitemid] int NULL,
  [scount] smallint NULL,
  [strsender] nvarchar(21) NULL,
  [strsubject] nvarchar(50) NULL,
  [strmessage] nvarchar(128) NULL
);

ALTER TABLE dbo.[return_is_letter_item] ADD CONSTRAINT [PK_LAB_return_is_letter_item] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[sealed_items] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [straccountid] nvarchar(21) NOT NULL,
  [struserid] nvarchar(21) NOT NULL,
  [nitemserial] bigint NOT NULL,
  [nitemid] int NOT NULL,
  [bsealtype] smallint NOT NULL
);

ALTER TABLE dbo.[sealed_items] ADD CONSTRAINT [PK_LAB_sealed_items] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[server_resource] (
  [nresourceid] int NOT NULL,
  [strresource] nvarchar(250) NOT NULL
);

ALTER TABLE dbo.[server_resource] ADD CONSTRAINT [PK_LAB_server_resource] PRIMARY KEY NONCLUSTERED ([nresourceid]);

CREATE TABLE dbo.[set_item] (
  [setindex] int NOT NULL,
  [setname] nvarchar(50) NULL,
  [acbonus] smallint NOT NULL,
  [hpbonus] smallint NOT NULL,
  [mpbonus] smallint NOT NULL,
  [strengthbonus] smallint NOT NULL,
  [staminabonus] smallint NOT NULL,
  [dexteritybonus] smallint NOT NULL,
  [intelbonus] smallint NOT NULL,
  [charismabonus] smallint NOT NULL,
  [flameresistance] smallint NOT NULL,
  [glacierresistance] smallint NOT NULL,
  [lightningresistance] smallint NOT NULL,
  [poisonresistance] smallint NOT NULL,
  [magicresistance] smallint NOT NULL,
  [curseresistance] smallint NOT NULL,
  [xpbonuspercent] smallint NOT NULL,
  [coinbonuspercent] smallint NOT NULL,
  [apbonuspercent] smallint NOT NULL,
  [apbonusclasstype] smallint NOT NULL,
  [apbonusclasspercent] smallint NOT NULL,
  [acbonusclasstype] smallint NOT NULL,
  [acbonusclasspercent] smallint NOT NULL,
  [maxweightbonus] smallint NOT NULL,
  [npbonus] smallint NOT NULL
);

CREATE TABLE dbo.[set_itemorj] (
  [setindex] int NOT NULL,
  [setname] nvarchar(max) NULL,
  [acbonus] smallint NOT NULL,
  [hpbonus] smallint NOT NULL,
  [mpbonus] smallint NOT NULL,
  [strengthbonus] smallint NOT NULL,
  [staminabonus] smallint NOT NULL,
  [dexteritybonus] smallint NOT NULL,
  [intelbonus] smallint NOT NULL,
  [charismabonus] smallint NOT NULL,
  [flameresistance] smallint NOT NULL,
  [glacierresistance] smallint NOT NULL,
  [lightningresistance] smallint NOT NULL,
  [poisonresistance] smallint NOT NULL,
  [magicresistance] smallint NOT NULL,
  [curseresistance] smallint NOT NULL,
  [xpbonuspercent] smallint NOT NULL,
  [coinbonuspercent] smallint NOT NULL,
  [apbonuspercent] smallint NOT NULL,
  [apbonusclasstype] smallint NOT NULL,
  [apbonusclasspercent] smallint NOT NULL,
  [acbonusclasstype] smallint NOT NULL,
  [acbonusclasspercent] smallint NOT NULL,
  [maxweightbonus] smallint NOT NULL,
  [npbonus] smallint NOT NULL
);

CREATE TABLE dbo.[sheriff_reports] (
  [reportedname] nvarchar(21) NOT NULL,
  [reportedsheriffname] nvarchar(21) NOT NULL,
  [crime] nvarchar(128) NOT NULL,
  [yes] smallint NOT NULL,
  [sheriffyesa] nvarchar(21) NULL,
  [sheriffyesb] nvarchar(21) NULL DEFAULT '0',
  [sheriffyesc] nvarchar(21) NULL DEFAULT '0',
  [no] smallint NOT NULL,
  [sheriffnoa] nvarchar(21) NULL DEFAULT '0',
  [sheriffnob] nvarchar(21) NULL DEFAULT '0',
  [sheriffnoc] nvarchar(21) NULL DEFAULT '0',
  [reportdatetime] nvarchar(128) NOT NULL
);

CREATE TABLE dbo.[start_position] (
  [zoneid] smallint NOT NULL,
  [skarusx] smallint NOT NULL,
  [skarusz] smallint NOT NULL,
  [selmoradx] smallint NOT NULL,
  [selmoradz] smallint NOT NULL,
  [skarusgatex] smallint NULL,
  [skarusgatez] smallint NULL,
  [selmogatex] smallint NULL,
  [selmogatez] smallint NULL,
  [brangex] smallint NOT NULL,
  [brangez] smallint NOT NULL
);

ALTER TABLE dbo.[start_position] ADD CONSTRAINT [PK_LAB_start_position] PRIMARY KEY NONCLUSTERED ([zoneid]);

CREATE TABLE dbo.[start_position_random] (
  [zoneid] smallint NULL,
  [posx] smallint NULL,
  [posz] smallint NULL,
  [radius] smallint NULL
);

CREATE TABLE dbo.[tb_user] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [straccountid] nvarchar(21) NOT NULL,
  [strpasswd] nvarchar(28) NOT NULL,
  [strsealpasswd] nvarchar(8) NOT NULL DEFAULT '12345678',
  [otppassword] nvarchar(6) NOT NULL DEFAULT '123456',
  [strclientip] nvarchar(15) NULL,
  [bpremiumtype] smallint NOT NULL,
  [dtpremiumtime] datetime NULL,
  [shours] smallint NOT NULL DEFAULT '0',
  [dtcreatetime] datetime NULL,
  [cashpoint] int NOT NULL DEFAULT 0,
  [strauthority] smallint NOT NULL,
  [bonuscashpoint] int NOT NULL DEFAULT 0
);

ALTER TABLE dbo.[tb_user] ADD CONSTRAINT [PK_LAB_tb_user] PRIMARY KEY NONCLUSTERED ([id], [straccountid], [strsealpasswd], [bpremiumtype], [shours]);

CREATE TABLE dbo.[test_table] (
  [index] int NULL,
  [robıtem1] int NULL,
  [robıtem2] int NULL,
  [robıtem3] int NULL,
  [robıtem4] int NULL,
  [robıtem5] int NULL,
  [robıtem6] int NULL,
  [robıtem7] int NULL,
  [robıtem8] int NULL,
  [robıtem9] int NULL,
  [robıtem10] int NULL,
  [robıtemcount1] int NULL,
  [robıtemcount2] int NULL,
  [robıtemcount3] int NULL,
  [robıtemcount4] int NULL,
  [robıtemcount5] int NULL,
  [robıtemcount6] int NULL,
  [robıtemcount7] int NULL,
  [robıtemcount8] int NULL,
  [robıtemcount9] int NULL,
  [robıtemcount10] int NULL,
  [giveıtem1] int NULL,
  [giveıtem2] int NULL,
  [giveıtem3] int NULL,
  [giveıtem4] int NULL,
  [giveıtem5] int NULL,
  [giveıtem6] int NULL,
  [giveıtem7] int NULL,
  [giveıtem8] int NULL,
  [giveıtem9] int NULL,
  [giveıtem10] int NULL,
  [giveıtemcount1] int NULL,
  [giveıtemcount2] int NULL,
  [giveıtemcount3] int NULL,
  [giveıtemcount4] int NULL,
  [giveıtemcount5] int NULL,
  [giveıtemcount6] int NULL,
  [giveıtemcount7] int NULL,
  [giveıtemcount8] int NULL,
  [giveıtemcount9] int NULL,
  [giveıtemcount10] int NULL,
  [giveıtemtime1] int NULL,
  [giveıtemtime2] int NULL,
  [giveıtemtime3] int NULL,
  [giveıtemtime4] int NULL,
  [giveıtemtime5] int NULL,
  [giveıtemtime6] int NULL,
  [giveıtemtime7] int NULL,
  [giveıtemtime8] int NULL,
  [giveıtemtime9] int NULL,
  [giveıtemtime10] int NULL
);

CREATE TABLE dbo.[text_packets] (
  [id] int NULL,
  [text] nvarchar(2000) NULL
);

CREATE TABLE dbo.[uniqturk_ipban] (
  [numara] nvarchar(max) NULL
);

CREATE TABLE dbo.[user_achieve_data] (
  [struserid] nvarchar(21) NOT NULL,
  [scoverid] smallint NOT NULL DEFAULT '0',
  [sskillid] smallint NOT NULL DEFAULT '0',
  [sachievecount] smallint NOT NULL DEFAULT '0',
  [strachieve] varbinary(max) NULL
);

ALTER TABLE dbo.[user_achieve_data] ADD CONSTRAINT [PK_LAB_user_achieve_data] PRIMARY KEY NONCLUSTERED ([struserid]);

CREATE TABLE dbo.[user_achieve_load_data] (
  [sstatus] smallint NOT NULL,
  [snotice] nvarchar(100) NOT NULL,
  [scoverid] smallint NOT NULL,
  [sskillid] smallint NOT NULL,
  [sachievecount] smallint NOT NULL,
  [strachieve] varbinary(max) NOT NULL
);

CREATE TABLE dbo.[user_authorty_data] (
  [struserid] nvarchar(max) NOT NULL,
  [isblocked] smallint NOT NULL,
  [time] bigint NOT NULL DEFAULT '0'
);

CREATE TABLE dbo.[user_bots] (
  [struserid] nvarchar(max) NOT NULL,
  [nation] smallint NOT NULL,
  [race] smallint NOT NULL,
  [class] smallint NOT NULL,
  [hairrgb] int NOT NULL,
  [level] smallint NOT NULL,
  [face] smallint NOT NULL,
  [knights] smallint NOT NULL,
  [fame] smallint NOT NULL,
  [zone] smallint NOT NULL,
  [px] int NOT NULL,
  [pz] int NOT NULL,
  [py] int NOT NULL,
  [stritem] varbinary(max) NULL,
  [id] int NOT NULL,
  [covertitle] int NOT NULL,
  [reblevel] smallint NOT NULL,
  [strskill] varbinary(max) NULL,
  [gold] int NOT NULL,
  [points] smallint NOT NULL,
  [strong] smallint NOT NULL,
  [sta] smallint NOT NULL,
  [dex] smallint NOT NULL,
  [intel] smallint NOT NULL,
  [cha] smallint NOT NULL
);

CREATE TABLE dbo.[user_character_seal_items] (
  [struserid] nvarchar(21) NOT NULL,
  [straccountid] nvarchar(21) NOT NULL,
  [nitemserial] bigint NULL
);

CREATE TABLE dbo.[user_daily_op] (
  [struserid] nvarchar(21) NOT NULL,
  [chaosmaptime] int NOT NULL,
  [userrankrewardtime] int NOT NULL,
  [personalrankrewardtime] int NOT NULL,
  [kingwingtime] int NOT NULL,
  [warderkillertime1] int NOT NULL,
  [warderkillertime2] int NOT NULL,
  [keeperkillertime] int NOT NULL,
  [userloyaltywingrewardtime] int NOT NULL
);

CREATE TABLE dbo.[user_draki_tower_data] (
  [struserid] nvarchar(21) NOT NULL,
  [class] int NOT NULL,
  [classname] nvarchar(50) NULL,
  [idrakitime] int NOT NULL DEFAULT 0,
  [bdrakistage] smallint NOT NULL,
  [bdrakienterancelimit] smallint NOT NULL
);

CREATE TABLE dbo.[user_genie_data] (
  [struserid] nvarchar(21) NOT NULL,
  [sgenietime] smallint NOT NULL DEFAULT '0',
  [strgenieoptions] varbinary(max) NOT NULL,
  [sfirstusinggenie] smallint NOT NULL
);

CREATE TABLE dbo.[user_hdd_ban_list] (
  [userid] nvarchar(21) NULL,
  [hwidkey] nvarchar(max) NULL,
  [mackey] int NULL,
  [banned] smallint NULL
);

CREATE TABLE dbo.[user_items] (
  [nitemid] smallint NULL,
  [nitemserial] smallint NULL
);

CREATE TABLE dbo.[user_knightdata] (
  [sclanid] smallint NOT NULL DEFAULT '0',
  [struserid] nvarchar(21) NOT NULL,
  [ndonatednp] int NOT NULL DEFAULT 0,
  [strmemo] nvarchar(20) NOT NULL DEFAULT '',
  [fame] smallint NOT NULL,
  [sclass] smallint NOT NULL,
  [level] smallint NOT NULL,
  [lastlogin] int NOT NULL DEFAULT 0,
  [loyalty] int NOT NULL DEFAULT 0
);

CREATE TABLE dbo.[user_knights_rank] (
  [shindex] smallint NOT NULL,
  [strname] nvarchar(21) NOT NULL,
  [strelmouserid] nvarchar(21) NULL,
  [strelmoknightsname] nvarchar(21) NULL,
  [selmoknights] smallint NULL DEFAULT '0',
  [nelmoloyalty] int NULL,
  [strkarususerid] nvarchar(21) NULL,
  [strkarusknightsname] nvarchar(21) NULL,
  [skarusknights] smallint NULL DEFAULT '0',
  [nkarusloyalty] int NULL,
  [nmoney] int NULL
);

ALTER TABLE dbo.[user_knights_rank] ADD CONSTRAINT [PK_LAB_user_knights_rank] PRIMARY KEY NONCLUSTERED ([shindex]);

CREATE TABLE dbo.[user_personal_rank] (
  [nrank] smallint NOT NULL,
  [strrankname] nvarchar(21) NOT NULL,
  [nelmoup] smallint NOT NULL,
  [strelmouserid] nvarchar(21) NULL,
  [strelmoclanname] nvarchar(21) NULL,
  [selmoknights] smallint NULL,
  [nelmoloyaltymonthly] int NULL,
  [nelmocheck] int NOT NULL DEFAULT 0,
  [nkarusup] smallint NOT NULL,
  [strkarususerid] nvarchar(21) NULL,
  [strkarusclanname] nvarchar(21) NULL,
  [skarusknights] smallint NULL,
  [nkarusloyaltymonthly] int NULL,
  [nkaruscheck] int NOT NULL DEFAULT 0,
  [nsalary] int NOT NULL,
  [updatedate] datetime NULL
);

ALTER TABLE dbo.[user_personal_rank] ADD CONSTRAINT [PK_LAB_user_personal_rank] PRIMARY KEY NONCLUSTERED ([nrank]);

CREATE TABLE dbo.[user_quest_data] (
  [struserid] nvarchar(21) NOT NULL,
  [squestcount] smallint NOT NULL DEFAULT '0',
  [strquest] varbinary(max) NOT NULL
);

CREATE TABLE dbo.[user_rental_item] (
  [struserid] nvarchar(21) NOT NULL,
  [straccountid] nvarchar(21) NULL,
  [byrentaltype] smallint NULL,
  [byregtype] smallint NULL,
  [nrentalindex] int NULL,
  [nitemindex] int NULL,
  [sdurability] smallint NULL,
  [nserialnumber] bigint NULL,
  [nrentalmoney] int NULL,
  [srentaltime] smallint NULL,
  [sduringtime] smallint NULL,
  [timerental] datetime NULL,
  [timeregister] datetime NULL
);

ALTER TABLE dbo.[user_rental_item] ADD CONSTRAINT [PK_LAB_user_rental_item] PRIMARY KEY NONCLUSTERED ([struserid]);

CREATE TABLE dbo.[user_return_data] (
  [strcharid] nvarchar(21) NOT NULL,
  [returnsymbolisok] smallint NULL,
  [returnislogouttime] bigint NULL,
  [returnsymboltime] bigint NULL
);

CREATE TABLE dbo.[user_saved_magic] (
  [strcharid] nvarchar(21) NOT NULL,
  [nskill1] int NOT NULL DEFAULT 0,
  [nduring1] smallint NOT NULL DEFAULT '0',
  [nskill2] int NOT NULL DEFAULT 0,
  [nduring2] smallint NOT NULL DEFAULT '0',
  [nskill3] int NOT NULL DEFAULT 0,
  [nduring3] smallint NOT NULL DEFAULT '0',
  [nskill4] int NOT NULL DEFAULT 0,
  [nduring4] smallint NOT NULL DEFAULT '0',
  [nskill5] int NOT NULL DEFAULT 0,
  [nduring5] smallint NOT NULL DEFAULT '0',
  [nskill6] int NOT NULL DEFAULT 0,
  [nduring6] smallint NOT NULL DEFAULT '0',
  [nskill7] int NOT NULL DEFAULT 0,
  [nduring7] smallint NOT NULL DEFAULT '0',
  [nskill8] int NOT NULL DEFAULT 0,
  [nduring8] smallint NOT NULL DEFAULT '0',
  [nskill9] int NOT NULL DEFAULT 0,
  [nduring9] smallint NOT NULL DEFAULT '0',
  [nskill10] int NOT NULL DEFAULT 0,
  [nduring10] smallint NOT NULL DEFAULT '0'
);

CREATE TABLE dbo.[user_seal_exp] (
  [struserid] nvarchar(21) NOT NULL,
  [ssealedexp] int NOT NULL DEFAULT 0
);

CREATE TABLE dbo.[userdata] (
  [struserid] nvarchar(21) NOT NULL,
  [nation] smallint NOT NULL,
  [race] smallint NOT NULL,
  [class] smallint NOT NULL,
  [hairrgb] int NOT NULL,
  [rank] smallint NOT NULL,
  [title] smallint NOT NULL,
  [level] smallint NOT NULL,
  [brebirthlevel] smallint NOT NULL,
  [exp] bigint NOT NULL DEFAULT '0',
  [loyalty] int NOT NULL DEFAULT 100,
  [face] smallint NOT NULL,
  [city] smallint NOT NULL,
  [knights] smallint NOT NULL DEFAULT '0',
  [fame] smallint NOT NULL,
  [hp] smallint NOT NULL DEFAULT '100',
  [mp] smallint NOT NULL DEFAULT '100',
  [sp] smallint NOT NULL DEFAULT '100',
  [strong] smallint NOT NULL,
  [sta] smallint NOT NULL,
  [dex] smallint NOT NULL,
  [intel] smallint NOT NULL,
  [cha] smallint NOT NULL,
  [brebstr] smallint NOT NULL,
  [brebsta] smallint NOT NULL,
  [brebdex] smallint NOT NULL,
  [brebintel] smallint NOT NULL,
  [brebcha] smallint NOT NULL,
  [authority] smallint NOT NULL,
  [points] smallint NOT NULL DEFAULT '0',
  [gold] int NOT NULL DEFAULT 0,
  [zone] smallint NOT NULL,
  [bind] smallint NOT NULL DEFAULT '-1',
  [px] int NOT NULL DEFAULT 81200,
  [pz] int NOT NULL DEFAULT 53000,
  [py] int NOT NULL DEFAULT 0,
  [dwtime] int NOT NULL DEFAULT 0,
  [strskill] nvarchar(10) NULL,
  [stritem] varbinary(max) NOT NULL,
  [strdeleteditem] varbinary(max) NOT NULL,
  [strserial] varbinary(max) NOT NULL,
  [stritemtime] varbinary(max) NOT NULL,
  [mannerpoint] int NOT NULL DEFAULT 0,
  [loyaltymonthly] int NOT NULL DEFAULT 0,
  [isavedcont] int NOT NULL DEFAULT 0,
  [dtcreatetime] datetime NULL,
  [dtupdatetime] datetime NULL,
  [nlastlogin] int NOT NULL DEFAULT 0,
  [ndonatednp] int NOT NULL DEFAULT 0,
  [timepunishment] int NOT NULL DEFAULT 0,
  [ip] nvarchar(15) NULL
);

CREATE TABLE dbo.[userdata_skillshortcut] (
  [strcharid] nvarchar(21) NOT NULL,
  [ncount] smallint NOT NULL,
  [strskilldata] varbinary(max) NOT NULL
);

ALTER TABLE dbo.[userdata_skillshortcut] ADD CONSTRAINT [PK_LAB_userdata_skillshortcut] PRIMARY KEY NONCLUSTERED ([strcharid]);

CREATE TABLE dbo.[usko_mob_id_list] (
  [ssid] smallint NULL,
  [mobname] nvarchar(50) NULL,
  [spid] smallint NULL
);

CREATE TABLE dbo.[usko_npc_id_list] (
  [ssid] smallint NULL,
  [mobname] nvarchar(50) NULL,
  [spid] smallint NULL
);

CREATE TABLE dbo.[version] (
  [sversion] smallint NOT NULL,
  [shistoryversion] smallint NOT NULL,
  [strfilename] nvarchar(40) NOT NULL
);

ALTER TABLE dbo.[version] ADD CONSTRAINT [PK_LAB_version] PRIMARY KEY NONCLUSTERED ([sversion]);

CREATE TABLE dbo.[vip_warehouse] (
  [straccountid] nvarchar(21) NOT NULL,
  [strpassword] nvarchar(4) NOT NULL DEFAULT '0',
  [wippasswordrequest] smallint NOT NULL,
  [strexpirationdate] int NOT NULL DEFAULT 0,
  [vipwarehousedata] varbinary(max) NULL,
  [strserial] varbinary(max) NULL,
  [vipwarehousedatatime] varbinary(max) NULL
);

CREATE TABLE dbo.[vs_event_logs] (
  [winnerplayer] nvarchar(max) NULL,
  [loserplayer] nvarchar(max) NULL,
  [nationalpoint] nvarchar(max) NULL,
  [datetime] datetime NULL
);

CREATE TABLE dbo.[warehouse] (
  [straccountid] nvarchar(21) NOT NULL,
  [nmoney] int NOT NULL DEFAULT 0,
  [dwtime] int NOT NULL DEFAULT 0,
  [warehousedata] varbinary(max) NULL,
  [strserial] varbinary(max) NULL,
  [warehousedatatime] varbinary(max) NULL
);

ALTER TABLE dbo.[warehouse] ADD CONSTRAINT [PK_LAB_warehouse] PRIMARY KEY NONCLUSTERED ([straccountid]);

CREATE TABLE dbo.[warehouse_itemler] (
  [dwid] int NOT NULL,
  [stacksize] smallint NULL,
  [durability] smallint NULL,
  [struserid] nvarchar(50) NULL,
  [sira] int NULL,
  [itembasicname] nvarchar(100) NULL
);

CREATE TABLE dbo.[web_itemmall] (
  [id] bigint IDENTITY(1,1) NOT NULL,
  [straccountid] nvarchar(21) NOT NULL,
  [strcharid] nvarchar(21) NOT NULL,
  [serverno] smallint NOT NULL,
  [itemid] int NOT NULL,
  [itemcount] smallint NOT NULL,
  [buytime] datetime NULL,
  [img_file_name] nvarchar(50) NULL,
  [stritemname] nvarchar(100) NULL,
  [price] int NULL,
  [pay_type] int NULL,
  [itemtime] int NOT NULL DEFAULT 0
);

ALTER TABLE dbo.[web_itemmall] ADD CONSTRAINT [PK_LAB_web_itemmall] PRIMARY KEY NONCLUSTERED ([id]);

CREATE TABLE dbo.[zone_info] (
  [serverno] smallint NOT NULL,
  [zoneno] smallint NOT NULL,
  [strzonesmdname] nvarchar(max) NOT NULL,
  [strzonename] nvarchar(50) NOT NULL,
  [status] smallint NOT NULL,
  [zonetype] smallint NULL,
  [minlevel] smallint NULL,
  [maxlevel] smallint NULL,
  [tradeothernation] smallint NULL,
  [talkothernation] smallint NULL,
  [attackothernation] smallint NULL,
  [attacksamenation] smallint NULL,
  [friendlynpc] smallint NULL,
  [warzone] smallint NULL,
  [clanupdates] smallint NULL,
  [teleport] smallint NOT NULL,
  [gate] smallint NOT NULL,
  [escape] smallint NOT NULL,
  [callingfriend] smallint NOT NULL,
  [teleportfriend] smallint NOT NULL,
  [blink] smallint NOT NULL,
  [petspawn] smallint NOT NULL,
  [explost] smallint NOT NULL,
  [giveloyalty] smallint NOT NULL,
  [guardsummon] smallint NOT NULL,
  [blinkzone] smallint NOT NULL,
  [initx] int NOT NULL,
  [initz] int NOT NULL,
  [inity] int NOT NULL
);

ALTER TABLE dbo.[zone_info] ADD CONSTRAINT [PK_LAB_zone_info] PRIMARY KEY NONCLUSTERED ([zoneno]);

CREATE TABLE dbo.[beginner_settings] (
  [serverno] smallint NULL,
  [beginnertype] smallint NULL,
  [beginnerdesc] nvarchar(100) NULL
);

CREATE TABLE dbo.[game_master_settings] (
  [straccountid] nvarchar(max) NULL,
  [strcharid] nvarchar(21) NULL,
  [sserverno] smallint NOT NULL,
  [smute] smallint NOT NULL DEFAULT '0',
  [sunmute] smallint NOT NULL DEFAULT '0',
  [sunban] smallint NOT NULL DEFAULT '0',
  [sbanpermit] smallint NOT NULL DEFAULT '0',
  [sallowattack] smallint NOT NULL DEFAULT '0',
  [sdisabledattack] smallint NOT NULL DEFAULT '0',
  [snpadd] smallint NOT NULL DEFAULT '0',
  [sexpadd] smallint NOT NULL DEFAULT '0',
  [smoneyadd] smallint NOT NULL DEFAULT '0',
  [sloyaltychange] smallint NOT NULL DEFAULT '0',
  [sexpchange] smallint NOT NULL DEFAULT '0',
  [smoneychange] smallint NOT NULL DEFAULT '0',
  [sgiveitem] smallint NOT NULL DEFAULT '0',
  [sgiveitemself] smallint NOT NULL DEFAULT '0',
  [ssummonuser] smallint NOT NULL DEFAULT '0',
  [stponuser] smallint NOT NULL DEFAULT '0',
  [szonechange] smallint NOT NULL DEFAULT '0',
  [slocationchange] smallint NOT NULL DEFAULT '0',
  [smonstersummon] smallint NOT NULL DEFAULT '0',
  [snpcsummon] smallint NOT NULL DEFAULT '0',
  [smonkilled] smallint NOT NULL DEFAULT '0',
  [steleportalluser] smallint NOT NULL DEFAULT '0',
  [sclansummon] smallint NOT NULL DEFAULT '0',
  [sresetplayerranking] smallint NOT NULL DEFAULT '0',
  [schangeeventroom] smallint NOT NULL DEFAULT '0',
  [swaropen1] smallint NOT NULL DEFAULT '0',
  [swaropen2] smallint NOT NULL DEFAULT '0',
  [swaropen3] smallint NOT NULL DEFAULT '0',
  [swaropen4] smallint NOT NULL DEFAULT '0',
  [swaropen5] smallint NOT NULL DEFAULT '0',
  [swaropen6] smallint NOT NULL DEFAULT '0',
  [swaropen9] smallint NOT NULL DEFAULT '0',
  [swarsiegeopen] smallint NOT NULL DEFAULT '0',
  [swarclose] smallint NOT NULL DEFAULT '0',
  [scaptainelection] smallint NOT NULL DEFAULT '0',
  [swarsiegeclose] smallint NOT NULL DEFAULT '0',
  [ssendprsion] smallint NOT NULL DEFAULT '0'
);

CREATE TABLE dbo.[game_options] (
  [maintenancemode] smallint NOT NULL,
  [characterselectlogin] smallint NULL,
  [openotp] smallint NOT NULL,
  [autoregister] smallint NOT NULL,
  [freelimit] smallint NOT NULL,
  [totaluserlimit] smallint NOT NULL,
  [serveripaddress] nvarchar(15) NOT NULL
);

CREATE TABLE dbo.[gm_maintenance_login] (
  [gmloginid] nvarchar(21) NOT NULL
);

CREATE TABLE dbo.[server_clean] (
  [format] smallint NULL,
  [server001] smallint NULL,
  [server002] smallint NULL,
  [server003] smallint NULL,
  [server004] smallint NULL,
  [server005] smallint NULL,
  [server006] smallint NULL,
  [server007] smallint NULL,
  [server008] smallint NULL,
  [server009] smallint NULL,
  [server010] smallint NULL
);

CREATE TABLE dbo.[server_settings] (
  [nserverno] int NOT NULL DEFAULT 1,
  [maximumlevelchange] smallint NOT NULL DEFAULT '83',
  [dropnotice] smallint NOT NULL,
  [upgradenotice] smallint NOT NULL,
  [usermaxupgradecount] smallint NOT NULL DEFAULT '0',
  [openquestskill] smallint NOT NULL DEFAULT '0'
);