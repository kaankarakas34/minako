# Script to write the full index.html with all 3 major modes:
# 1. Oyuncu Yönetim Masası (Oyuncu seçimi, ceza, item verme, edit forge, para/kc)
# 2. Sunucu & Etkinlik Paneli (Boss spawner, savaşlar, boostlar, canlı duyuru, kuyruk)
# 3. Yaratık, Drop & Spawn Editörü (Tüm canavarlar, filtreleme, drop oranları, spawn oranları, canlı GameServer reload)

with open(r"14_GM_Admin_Paneli\static\index.html", "w", encoding="utf-8") as f:
    f.write('''<!DOCTYPE html>
<html lang="tr" class="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Knight Online - GM & Sunucu Yönetim Masası</title>
  <!-- Tailwind CSS & FontAwesome -->
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <script>
    tailwind.config = {
      darkMode: 'class',
      theme: {
        extend: {
          colors: {
            brand: {
              gold: '#d4af37',
              darkgold: '#997d26',
              dark: '#0a0d13',
              card: '#131924',
              border: '#232c3d'
            }
          }
        }
      }
    }
  </script>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; }
    ::-webkit-scrollbar { width: 6px; height: 6px; }
    ::-webkit-scrollbar-track { background: #080b10; }
    ::-webkit-scrollbar-thumb { background: #222d3e; border-radius: 4px; }
    ::-webkit-scrollbar-thumb:hover { background: #d4af37; }

    /* Classic Knight Online Inventory Slot Styling */
    .ko-slot {
      width: 52px;
      height: 52px;
      background: radial-gradient(circle at center, #1b2230 0%, #0d1118 100%);
      border: 2px solid #3b475d;
      box-shadow: inset 0 0 8px rgba(0,0,0,0.8), 0 2px 4px rgba(0,0,0,0.5);
      position: relative;
      border-radius: 6px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }
    .ko-slot:hover {
      border-color: #d4af37;
      box-shadow: inset 0 0 10px rgba(212, 175, 55, 0.3), 0 0 8px rgba(212, 175, 55, 0.4);
    }
    .ko-slot-large {
      width: 68px;
      height: 68px;
      background: radial-gradient(circle at center, #242e42 0%, #0d121a 100%);
      border: 2px solid #506180;
      box-shadow: inset 0 0 12px rgba(0,0,0,0.9), 0 4px 10px rgba(0,0,0,0.6);
      border-radius: 8px;
    }
    .grade-pill {
      font-size: 11px;
      padding: 2px 7px;
      border-radius: 4px;
      font-weight: bold;
      border: 1px solid #3b475d;
      background: #151c28;
      color: #94a3b8;
      transition: all 0.15s ease;
      cursor: pointer;
    }
    .grade-pill:hover {
      background: #253347;
      color: #f1f5f9;
      border-color: #64748b;
    }
    .grade-pill.active {
      background: #d97706;
      color: #000;
      border-color: #f59e0b;
      box-shadow: 0 0 6px rgba(245, 158, 11, 0.6);
    }
    .filter-btn {
      padding: 3px 8px;
      border-radius: 6px;
      font-size: 11px;
      font-weight: 600;
      transition: all 0.15s ease;
      cursor: pointer;
      border: 1px solid #243044;
      background: #151d2a;
      color: #94a3b8;
    }
    .filter-btn:hover {
      background: #1c2738;
      color: #e2e8f0;
      border-color: #3b4d6b;
    }
    .filter-btn.active {
      background: #d97706;
      color: #000;
      font-weight: 700;
      border-color: #f59e0b;
      box-shadow: 0 0 8px rgba(245, 158, 11, 0.4);
    }

    .main-nav-btn {
      padding: 7px 15px;
      border-radius: 10px;
      font-size: 12px;
      font-weight: 700;
      transition: all 0.2s ease;
      display: flex;
      align-items: center;
      gap: 7px;
      cursor: pointer;
      border: 1px solid transparent;
    }
    .main-nav-btn.active {
      background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
      color: #000;
      border-color: #fbbf24;
      box-shadow: 0 4px 14px rgba(217, 119, 6, 0.4);
    }
    .main-nav-btn:not(.active) {
      background: #151d2a;
      color: #cbd5e1;
      border-color: #273449;
    }
    .main-nav-btn:not(.active):hover {
      background: #1c2637;
      color: #f8fafc;
      border-color: #475569;
    }
    .player-card.active, .mob-card.active {
      border-color: #f59e0b !important;
      background: linear-gradient(90deg, #1f2736 0%, #171e2c 100%) !important;
      box-shadow: 0 0 12px rgba(245, 158, 11, 0.25);
    }
  </style>
</head>
<body class="bg-[#090c12] text-gray-200 min-h-screen flex flex-col overflow-x-hidden">

  <!-- ======================================================== -->
  <!-- HEADER: LOGO + 3 ANA MASAYA GEÇİŞ BUTONU                  -->
  <!-- ======================================================== -->
  <header class="bg-[#10151f] border-b border-[#212a3b] px-5 py-2.5 flex flex-wrap items-center justify-between gap-3 shadow-2xl sticky top-0 z-40">
    
    <!-- Brand Logo -->
    <div class="flex items-center space-x-3">
      <div class="w-9 h-9 rounded-xl bg-gradient-to-br from-amber-500 to-amber-700 flex items-center justify-center shadow-lg shadow-amber-500/20 text-black font-extrabold text-lg">
        <i class="fa-solid fa-shield-halved"></i>
      </div>
      <div>
        <h1 class="text-sm font-black tracking-wider text-amber-400 flex items-center gap-2">
          KNIGHT ONLINE <span class="text-[10px] px-2 py-0.5 rounded bg-amber-500/10 text-amber-400 border border-amber-500/30">GM MASASI</span>
        </h1>
        <p class="text-[11px] text-gray-400">TemuKO v2239 Yönetim & Operasyon Konsolu</p>
      </div>
    </div>

    <!-- 3 ANA MOD BUTONU -->
    <div class="flex items-center bg-[#090d14] p-1 rounded-xl border border-[#222c3e] shadow-inner space-x-1">
      <button onclick="setMainMode('players')" id="nav-mode-players" class="main-nav-btn active">
        <i class="fa-solid fa-user-gear"></i>
        <span>Oyuncu Masası</span>
      </button>
      <button onclick="setMainMode('server')" id="nav-mode-server" class="main-nav-btn">
        <i class="fa-solid fa-server"></i>
        <span>Sunucu & Etkinlik</span>
        <span class="text-[9px] bg-amber-500/20 text-amber-300 px-1 py-0.2 rounded font-mono">Boss/Savaş</span>
      </button>
      <button onclick="setMainMode('mobs')" id="nav-mode-mobs" class="main-nav-btn">
        <i class="fa-solid fa-dragon"></i>
        <span>Drop & Spawn Editörü</span>
        <span class="text-[9px] bg-red-500/20 text-red-300 px-1 py-0.2 rounded font-mono font-bold">Yeni</span>
      </button>
    </div>

    <!-- Status Indicators -->
    <div class="flex items-center space-x-3 text-xs">
      <div class="flex items-center space-x-2 bg-[#161e2b] px-3 py-1.5 rounded-full border border-gray-700/50">
        <span id="badge-game" class="w-2.5 h-2.5 rounded-full bg-gray-500 animate-pulse"></span>
        <span class="text-gray-300">GameServer: <b id="text-game" class="text-gray-400">...</b></span>
      </div>
      <div class="flex items-center space-x-2 bg-[#161e2b] px-3 py-1.5 rounded-full border border-gray-700/50">
        <span id="badge-login" class="w-2.5 h-2.5 rounded-full bg-gray-500 animate-pulse"></span>
        <span class="text-gray-300">LogIn: <b id="text-login" class="text-gray-400">...</b></span>
      </div>
      <button onclick="refreshData()" class="p-2 text-gray-400 hover:text-amber-400 transition" title="Yenile">
        <i class="fa-solid fa-rotate"></i>
      </button>
    </div>
  </header>

  <!-- Toast Notification Container -->
  <div id="toast" class="fixed bottom-5 right-5 z-50 transform transition-all duration-300 translate-y-20 opacity-0 bg-gray-900 border border-amber-500/50 text-white px-5 py-3 rounded-xl shadow-2xl flex items-center space-x-3">
    <i id="toast-icon" class="fa-solid fa-circle-check text-amber-400 text-lg"></i>
    <span id="toast-msg" class="text-sm font-medium">Bildirim</span>
  </div>

  <!-- ======================================================== -->
  <!-- MODAL: DROP İÇİN EŞYA KATALOĞUNDAN SEÇME PENCERESİ      -->
  <!-- ======================================================== -->
  <div id="item-picker-modal" class="hidden fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4">
    <div class="bg-[#121824] border border-[#2b384e] rounded-2xl w-full max-w-2xl max-h-[85vh] flex flex-col shadow-2xl overflow-hidden">
      
      <!-- Modal Header -->
      <div class="p-4 border-b border-gray-800 flex items-center justify-between bg-[#151c2a]">
        <div class="flex items-center space-x-2">
          <i class="fa-solid fa-magnifying-glass text-amber-400"></i>
          <h3 class="text-sm font-bold text-gray-200">Drop Slotu İçin Eşya Seçin (<span id="picker-slot-title" class="text-amber-400">Slot 1</span>)</h3>
        </div>
        <button onclick="closeItemPicker()" class="text-gray-400 hover:text-white text-lg">
          <i class="fa-solid fa-xmark"></i>
        </button>
      </div>

      <!-- Search Input -->
      <div class="p-4 border-b border-gray-800 space-y-2">
        <div class="relative">
          <i class="fa-solid fa-search absolute left-3 top-3 text-gray-500 text-xs"></i>
          <input type="text" id="picker-search-input" onkeydown="if(event.key==='Enter') searchPickerItems()" placeholder="Eşya adı veya ID girin (örn: Shard, Raptor, Iron Necklace, Gold Bar...)" class="w-full bg-[#0a0d14] border border-gray-700 rounded-lg pl-9 pr-4 py-2 text-xs text-gray-200 focus:outline-none focus:border-amber-500">
        </div>
        <div class="flex flex-wrap gap-1.5 text-[11px]">
          <span class="text-gray-500 font-semibold py-0.5">Hızlı:</span>
          <button onclick="quickPickerSearch('Shard')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-2 py-0.5 rounded">Shard</button>
          <button onclick="quickPickerSearch('Raptor')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-2 py-0.5 rounded">Raptor</button>
          <button onclick="quickPickerSearch('Iron Necklace')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-2 py-0.5 rounded">Iron Necklace</button>
          <button onclick="quickPickerSearch('Gold Bar')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-2 py-0.5 rounded">Gold Bar</button>
          <button onclick="quickPickerSearch('Silver Bar')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-2 py-0.5 rounded">Silver Bar</button>
          <button onclick="quickPickerSearch('Chitin Shield')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-2 py-0.5 rounded">Chitin Shield</button>
        </div>
      </div>

      <!-- Results Grid -->
      <div id="picker-results-container" class="flex-1 overflow-y-auto p-4 grid grid-cols-1 sm:grid-cols-2 gap-2.5 max-h-96">
        <div class="col-span-full text-center py-10 text-gray-500 text-xs">Aramak için yukarıya bir eşya ismi yazıp Enter'a basın.</div>
      </div>

      <!-- Modal Footer -->
      <div class="p-3 border-t border-gray-800 bg-[#10141d] flex justify-between items-center text-xs">
        <span class="text-gray-500">Seçtiğiniz eşya bu canavarın drop slotuna atanacaktır.</span>
        <button onclick="closeItemPicker()" class="bg-gray-800 hover:bg-gray-700 text-gray-300 px-4 py-1.5 rounded-lg transition font-semibold">Kapat</button>
      </div>

    </div>
  </div>

  <!-- ======================================================== -->
  <!-- VIEW 1: OYUNCU YÖNETİM MASASI                            -->
  <!-- ======================================================== -->
  <div id="view-players-mode" class="flex-1 flex flex-col lg:flex-row w-full max-w-[1920px] mx-auto overflow-hidden">

    <!-- SOL SIDEBAR: OYUNCU LİSTESİ & FİLTRELER -->
    <aside class="w-full lg:w-96 bg-[#0d121b] border-b lg:border-b-0 lg:border-r border-[#20293a] flex flex-col h-auto lg:h-[calc(100vh-57px)] flex-shrink-0">
      
      <div class="p-3.5 border-b border-[#20293a] bg-[#111723] space-y-2.5">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-2">
            <i class="fa-solid fa-users text-amber-400 text-sm"></i>
            <h2 class="text-xs font-black uppercase tracking-wider text-gray-200">Kayıtlı Karakterler</h2>
            <span id="sidebar-total-badge" class="text-[10px] bg-gray-800 text-gray-300 px-1.5 py-0.2 rounded font-mono font-bold">0</span>
          </div>
          <button onclick="loadCharactersList()" class="text-[11px] text-amber-400 hover:text-amber-300 flex items-center gap-1 transition">
            <i class="fa-solid fa-rotate-right"></i> Yenile
          </button>
        </div>

        <!-- Online / Offline Filter Pills -->
        <div class="grid grid-cols-3 gap-1.5">
          <button onclick="setStatusFilter('all')" id="filter-status-all" class="filter-btn active text-center">
            Tümü (<span id="count-status-all">0</span>)
          </button>
          <button onclick="setStatusFilter('online')" id="filter-status-online" class="filter-btn text-center text-green-400">
            🟢 Online (<span id="count-status-online">0</span>)
          </button>
          <button onclick="setStatusFilter('offline')" id="filter-status-offline" class="filter-btn text-center text-gray-400">
            ⚪ Offline (<span id="count-status-offline">0</span>)
          </button>
        </div>

        <!-- Search Bar -->
        <div class="relative">
          <i class="fa-solid fa-magnifying-glass absolute left-3 top-2.5 text-gray-500 text-xs"></i>
          <input type="text" id="sidebar-search-input" oninput="debouncePlayerFilter()" placeholder="Karakter veya hesap adı ara..." class="w-full bg-[#080c12] border border-gray-700/80 rounded-lg pl-8 pr-3 py-1.5 text-xs text-gray-200 placeholder-gray-500 focus:outline-none focus:border-amber-500">
        </div>

        <!-- Nation Filter Row -->
        <div class="flex items-center space-x-1.5 text-[11px]">
          <span class="text-[10px] text-gray-500 font-bold uppercase w-8">Irk:</span>
          <button onclick="setNationFilter('all')" id="filter-nation-all" class="filter-btn active">Tümü</button>
          <button onclick="setNationFilter('karus')" id="filter-nation-karus" class="filter-btn">🔴 Karus</button>
          <button onclick="setNationFilter('elmorad')" id="filter-nation-elmorad" class="filter-btn">🔵 El Morad</button>
        </div>

        <!-- Job Filter Row -->
        <div class="flex flex-wrap items-center gap-1 text-[11px]">
          <span class="text-[10px] text-gray-500 font-bold uppercase w-8">Job:</span>
          <button onclick="setJobFilter('all')" id="filter-job-all" class="filter-btn active">Tümü</button>
          <button onclick="setJobFilter('warrior')" id="filter-job-warrior" class="filter-btn">⚔️ Warrior</button>
          <button onclick="setJobFilter('rogue')" id="filter-job-rogue" class="filter-btn">🏹 Rogue</button>
          <button onclick="setJobFilter('mage')" id="filter-job-mage" class="filter-btn">🔥 Mage</button>
          <button onclick="setJobFilter('priest')" id="filter-job-priest" class="filter-btn">✨ Priest</button>
          <button onclick="setJobFilter('kurian')" id="filter-job-kurian" class="filter-btn">🦎 Kurian</button>
        </div>
      </div>

      <!-- Scrollable Player List -->
      <div id="sidebar-players-container" class="flex-1 overflow-y-auto p-2.5 space-y-2">
        <div class="text-xs text-center text-gray-500 py-10">Oyuncular yükleniyor...</div>
      </div>
    </aside>

    <!-- SAĞ ÇALIŞMA ALANI: SEÇİLİ OYUNCU DETAYI -->
    <main class="flex-1 flex flex-col h-auto lg:h-[calc(100vh-57px)] overflow-y-auto p-5 space-y-5">
      
      <!-- SEÇİLİ OYUNCU KARTI & HIZLI KONTROLLER -->
      <div id="selected-player-banner" class="bg-gradient-to-r from-[#121824] via-[#141d2c] to-[#101621] border border-[#232f44] rounded-xl p-4 shadow-xl">
        <div class="flex flex-wrap items-center justify-between gap-4">
          
          <!-- Identity Details -->
          <div class="flex items-center space-x-3.5">
            <div id="sel-avatar-box" class="w-14 h-14 rounded-xl bg-gradient-to-tr from-amber-600 to-amber-400 text-black flex items-center justify-center text-2xl font-black shadow-lg shadow-amber-500/20 p-2.5">
              <i id="sel-job-icon" class="fa-solid fa-user-shield"></i>
            </div>
            <div>
              <div class="flex items-center gap-2">
                <h2 id="sel-char-name" class="text-xl font-black text-amber-400">cabbar</h2>
                <span id="sel-gm-badge" class="text-[10px] px-2 py-0.5 rounded bg-red-600 text-white font-extrabold shadow-sm">GM</span>
                <span id="sel-online-badge" class="text-[10px] px-2 py-0.5 rounded bg-green-500/10 text-green-400 border border-green-500/30 font-bold flex items-center gap-1">
                  <span class="w-1.5 h-1.5 rounded-full bg-green-400"></span> Çevrimiçi
                </span>
                <span id="sel-nation-badge" class="text-[10px] px-2 py-0.5 rounded bg-red-500/10 text-red-400 border border-red-500/30 font-bold">🔴 Karus</span>
                <span id="sel-punish-badge" class="hidden text-[10px] px-2 py-0.5 rounded bg-amber-500 text-black font-extrabold animate-pulse">
                  <i class="fa-solid fa-gavel mr-1"></i> [CEZALI]
                </span>
              </div>
              <div class="text-xs text-gray-400 mt-1 flex flex-wrap gap-x-4">
                <span>Seviye: <b id="sel-level-text" class="text-white font-bold">23</b></span>
                <span>Sınıf: <b id="sel-job-text" class="text-gray-300 font-semibold">Rogue</b></span>
                <span>Hesap: <b id="sel-account-text" class="text-gray-300">KnightLab1</b></span>
                <span>Bölge: <b id="sel-zone-text" class="text-gray-400">Zone 21 (Moradon)</b></span>
              </div>
            </div>
          </div>

          <!-- Balances & 1-Click Buttons -->
          <div class="flex flex-wrap items-center gap-3">
            <div class="bg-[#0b0f17] px-3.5 py-1.5 rounded-lg border border-gray-800 text-right">
              <div class="text-[10px] uppercase font-bold text-gray-500">Mevcut Noah</div>
              <div id="sel-gold-text" class="text-sm font-black text-amber-400 font-mono">0 Noah</div>
            </div>
            <div class="bg-[#0b0f17] px-3.5 py-1.5 rounded-lg border border-gray-800 text-right">
              <div class="text-[10px] uppercase font-bold text-gray-500">Knight Cash</div>
              <div id="sel-cash-text" class="text-sm font-black text-green-400 font-mono">0 KC</div>
            </div>
            <div class="flex items-center gap-1.5">
              <button onclick="quickGold(100000000)" class="bg-[#182233] hover:bg-amber-600 hover:text-black text-amber-300 border border-amber-500/30 text-xs font-bold px-3 py-2 rounded-lg transition" title="Seçili karaktere 100M Noah verir">
                +100M Noah
              </button>
              <button onclick="quickKc(5000)" class="bg-[#182233] hover:bg-green-600 hover:text-black text-green-300 border border-green-500/30 text-xs font-bold px-3 py-2 rounded-lg transition" title="Seçili karaktere 5000 KC yükler">
                +5,000 KC
              </button>
              <button onclick="toggleGM()" id="btn-toggle-gm" class="bg-[#182233] hover:bg-red-700 hover:text-white text-gray-300 border border-gray-700 text-xs font-bold px-3 py-2 rounded-lg transition" title="Yetkisini GM yapar veya alır">
                <i class="fa-solid fa-crown text-amber-400 mr-1"></i> Yetki Değiştir
              </button>
            </div>
          </div>

        </div>
      </div>

      <!-- Player Management Sub-Tabs -->
      <div class="bg-[#111723] border-b border-[#212a3b] px-3 rounded-t-xl">
        <div class="flex space-x-2 sm:space-x-6 overflow-x-auto">
          <button onclick="switchPlayerTab('discipline')" id="tab-btn-discipline" class="tab-btn py-3 px-3 text-xs sm:text-sm font-bold border-b-2 border-amber-500 text-amber-400 flex items-center gap-2">
            <i class="fa-solid fa-gavel"></i> Disiplin & Moradon Town Cezası
          </button>
          <button onclick="switchPlayerTab('items')" id="tab-btn-items" class="tab-btn py-3 px-3 text-xs sm:text-sm font-semibold border-b-2 border-transparent text-gray-400 hover:text-gray-200 flex items-center gap-2">
            <i class="fa-solid fa-wand-magic-sparkles"></i> Eşya Kataloğu & Verme
          </button>
          <button onclick="switchPlayerTab('forge')" id="tab-btn-forge" class="tab-btn py-3 px-3 text-xs sm:text-sm font-semibold border-b-2 border-transparent text-gray-400 hover:text-gray-200 flex items-center gap-2">
            <i class="fa-solid fa-hammer"></i> Edit İtem Forge (Özel Üretim)
          </button>
          <button onclick="switchPlayerTab('economy')" id="tab-btn-economy" class="tab-btn py-3 px-3 text-xs sm:text-sm font-semibold border-b-2 border-transparent text-gray-400 hover:text-gray-200 flex items-center gap-2">
            <i class="fa-solid fa-coins"></i> Para, KC & Seviye
          </button>
        </div>
      </div>

      <!-- OYUNCU SEKME 1: DİSİPLİN & CEZA -->
      <div id="player-tab-discipline" class="player-tab-content space-y-5">
        
        <div class="bg-gradient-to-br from-[#18131e] to-[#121620] border-2 border-amber-500/40 rounded-xl p-5 shadow-2xl space-y-4">
          <div class="flex flex-wrap items-center justify-between gap-3 border-b border-gray-800 pb-3">
            <div class="flex items-center space-x-3">
              <div class="w-10 h-10 rounded-lg bg-amber-500 text-black flex items-center justify-center text-xl font-black shadow-lg shadow-amber-500/30">
                <i class="fa-solid fa-gavel"></i>
              </div>
              <div>
                <h3 class="text-sm font-black text-amber-400 uppercase tracking-wider flex items-center gap-2">
                  Moradon Town Hareketsiz Ceza Sistemi
                  <span class="text-[10px] bg-amber-500/20 text-amber-300 px-2 py-0.5 rounded border border-amber-500/40 font-mono font-bold">[CEZALI] ETİKETLİ</span>
                </h3>
                <p class="text-xs text-gray-400">Karakter Moradon Town'da kilitlenir, kafasında [CEZALI] tabelası çıkar, süre yalnızca karakter oyundayken (online) işler!</p>
              </div>
            </div>

            <div id="punish-status-box" class="bg-[#0b0e14] px-4 py-2 rounded-lg border border-gray-700 flex items-center gap-3">
              <span class="text-xs text-gray-400 font-semibold">Ceza Durumu:</span>
              <span id="punish-status-text" class="text-xs font-bold text-gray-300">Temiz (Cezasız)</span>
            </div>
          </div>

          <div class="space-y-2">
            <label class="block text-xs font-bold text-gray-300 uppercase tracking-wider">
              Ceza Süresi Belirle:
            </label>
            <div class="flex flex-wrap gap-2">
              <button onclick="setPunishMinutes(15)" class="punish-time-btn filter-btn">15 Dakika</button>
              <button onclick="setPunishMinutes(30)" class="punish-time-btn filter-btn">30 Dakika</button>
              <button onclick="setPunishMinutes(60)" class="punish-time-btn filter-btn active">1 Saat (60 Dk)</button>
              <button onclick="setPunishMinutes(120)" class="punish-time-btn filter-btn">2 Saat</button>
              <button onclick="setPunishMinutes(360)" class="punish-time-btn filter-btn">6 Saat</button>
              <button onclick="setPunishMinutes(720)" class="punish-time-btn filter-btn">12 Saat</button>
              <button onclick="setPunishMinutes(1440)" class="punish-time-btn filter-btn">24 Saat</button>
            </div>
            <div class="flex items-center gap-3 pt-2">
              <span class="text-xs text-gray-400">Veya Özel Süre (Dakika):</span>
              <input type="number" id="input-punish-minutes" value="60" min="1" max="43200" class="w-32 bg-[#090d14] border border-gray-700 rounded-lg px-3 py-1.5 text-xs text-gray-200 focus:outline-none focus:border-amber-500">
              <span class="text-xs text-gray-500 font-mono">(= <span id="punish-hours-preview">1.0</span> saat)</span>
            </div>
          </div>

          <div class="flex flex-wrap items-center gap-3 pt-3 border-t border-gray-800">
            <button onclick="applyPunishment()" class="bg-gradient-to-r from-amber-600 to-red-600 hover:from-amber-500 hover:to-red-500 text-black font-extrabold px-6 py-2.5 rounded-lg text-xs transition shadow-lg shadow-red-500/20 flex items-center gap-2">
              <i class="fa-solid fa-lock text-sm"></i>
              Moradon Town'a Hapset & [CEZALI] Yap
            </button>
            <button onclick="removePunishment()" class="bg-[#1b2333] hover:bg-green-600 hover:text-black text-green-300 border border-green-500/40 font-bold px-5 py-2.5 rounded-lg text-xs transition flex items-center gap-2">
              <i class="fa-solid fa-lock-open text-sm"></i>
              Cezayı Kaldır & Serbest Bırak
            </button>
          </div>
        </div>

        <!-- Moderation Quick Buttons -->
        <div class="bg-[#141a27] border border-[#222b3d] rounded-xl p-5 shadow-lg space-y-4">
          <h3 class="text-xs font-bold text-gray-300 uppercase tracking-wider flex items-center gap-2">
            <i class="fa-solid fa-shield-cat text-amber-400"></i> Hızlı Disiplin & Moderasyon Kontrolleri
          </h3>

          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
            <div class="bg-[#0e131d] border border-gray-800 rounded-lg p-3.5 space-y-2">
              <span class="text-xs font-bold text-red-400 flex items-center gap-1.5">
                <i class="fa-solid fa-plug-circle-xmark"></i> DC / Oyundan At
              </span>
              <p class="text-[11px] text-gray-400">Oyuncunun bağlantısını sunucudan anında koparır.</p>
              <button onclick="kickSelectedUser()" class="w-full bg-red-950 hover:bg-red-800 text-red-200 border border-red-700/40 text-xs font-bold py-1.5 rounded transition">
                Oyuncuyu DC Et
              </button>
            </div>

            <div class="bg-[#0e131d] border border-gray-800 rounded-lg p-3.5 space-y-2">
              <span class="text-xs font-bold text-purple-400 flex items-center gap-1.5">
                <i class="fa-solid fa-ban"></i> Hesap Banla / Aç
              </span>
              <p class="text-[11px] text-gray-400">Hesabın giriş yetkisini (Authority 255) kilitler veya açar.</p>
              <div class="flex gap-2">
                <button onclick="banSelectedUser()" class="flex-1 bg-red-900 hover:bg-red-700 text-white text-xs font-bold py-1.5 rounded transition">Banla</button>
                <button onclick="unbanSelectedUser()" class="flex-1 bg-green-900 hover:bg-green-700 text-white text-xs font-bold py-1.5 rounded transition">Aç</button>
              </div>
            </div>

            <div class="bg-[#0e131d] border border-gray-800 rounded-lg p-3.5 space-y-2">
              <span class="text-xs font-bold text-amber-400 flex items-center gap-1.5">
                <i class="fa-solid fa-comment-slash"></i> Chat Mute (Sustur)
              </span>
              <p class="text-[11px] text-gray-400">Genel ve özel chat yazışmasını engeller (Authority 11).</p>
              <div class="flex gap-2">
                <button onclick="muteSelectedUser()" class="flex-1 bg-amber-900 hover:bg-amber-700 text-white text-xs font-bold py-1.5 rounded transition">Sustur</button>
                <button onclick="unmuteSelectedUser()" class="flex-1 bg-blue-900 hover:bg-blue-700 text-white text-xs font-bold py-1.5 rounded transition">Aç</button>
              </div>
            </div>

            <div class="bg-[#0e131d] border border-gray-800 rounded-lg p-3.5 space-y-2">
              <span class="text-xs font-bold text-orange-400 flex items-center gap-1.5">
                <i class="fa-solid fa-hand"></i> Saldırı (Atak) Engelle
              </span>
              <p class="text-[11px] text-gray-400">Karakterin saldırı ve skill vurmasını sunucu seviyesinde durdurur.</p>
              <div class="flex gap-2">
                <button onclick="setAttackDisabled(true)" class="flex-1 bg-orange-950 hover:bg-orange-800 text-orange-200 border border-orange-700/40 text-xs font-bold py-1.5 rounded transition">Kapat</button>
                <button onclick="setAttackDisabled(false)" class="flex-1 bg-green-950 hover:bg-green-800 text-green-200 border border-green-700/40 text-xs font-bold py-1.5 rounded transition">Aç</button>
              </div>
            </div>
          </div>

          <!-- Teleport Row -->
          <div class="pt-3 border-t border-gray-800 flex flex-wrap items-center justify-between gap-3">
            <div class="flex items-center space-x-2 text-xs">
              <i class="fa-solid fa-compass text-amber-400"></i>
              <span class="text-gray-300 font-bold">Oyuncuyu Işınla:</span>
            </div>
            <div class="flex items-center space-x-2 flex-1 max-w-md">
              <select id="tp-destination" class="w-full bg-[#0a0e16] border border-gray-700 rounded-lg px-3 py-1.5 text-xs text-gray-200">
                <option value="21|815|545">21 - Moradon Town</option>
                <option value="71|1024|1024">71 - Colony Zone Bowl</option>
                <option value="1|376|212">1 - Luferson Castle Town</option>
                <option value="2|376|212">2 - El Morad Castle Town</option>
                <option value="11|376|212">11 - Karus Eslant</option>
                <option value="12|376|212">12 - El Morad Eslant</option>
                <option value="72|1024|1024">72 - Ardream</option>
              </select>
              <button onclick="teleportUser()" class="bg-blue-600 hover:bg-blue-500 text-white font-bold px-4 py-1.5 rounded-lg text-xs transition whitespace-nowrap">
                Işınla
              </button>
            </div>
          </div>

        </div>
      </div>

      <!-- OYUNCU SEKME 2: EŞYA KATALOĞU & VERME -->
      <div id="player-tab-items" class="player-tab-content hidden space-y-4">
        <div class="bg-[#141a27] border border-[#222b3d] rounded-xl p-5 shadow-lg space-y-4">
          
          <div class="flex flex-col sm:flex-row gap-3 items-center justify-between">
            <div class="relative w-full sm:w-2/3">
              <i class="fa-solid fa-magnifying-glass absolute left-4 top-3 text-gray-500 text-sm"></i>
              <input type="text" id="item-search-query" onkeydown="if(event.key==='Enter') searchItems()" placeholder="Eşya adı veya ID girin (örn: Shard, Raptor, Iron Necklace, Chitin Shield...)" class="w-full bg-[#0a0e16] border border-gray-700 rounded-lg pl-10 pr-4 py-2.5 text-sm text-gray-200 placeholder-gray-500 focus:outline-none focus:border-amber-500">
            </div>
            <button onclick="searchItems()" class="w-full sm:w-auto bg-amber-600 hover:bg-amber-500 text-black font-bold px-6 py-2.5 rounded-lg text-sm transition flex items-center justify-center gap-2">
              <i class="fa-solid fa-search"></i> Eşya Ara
            </button>
          </div>

          <div class="flex flex-wrap gap-2 pt-2 border-t border-gray-800">
            <span class="text-xs text-gray-500 py-1 font-semibold">Hızlı Aramalar:</span>
            <button onclick="quickSearchItem('Shard')" class="bg-[#192231] hover:bg-amber-600/20 hover:text-amber-300 border border-transparent text-xs px-3 py-1 rounded text-gray-300 transition">Shard</button>
            <button onclick="quickSearchItem('Raptor')" class="bg-[#192231] hover:bg-amber-600/20 hover:text-amber-300 border border-transparent text-xs px-3 py-1 rounded text-gray-300 transition">Raptor</button>
            <button onclick="quickSearchItem('Iron Impact')" class="bg-[#192231] hover:bg-amber-600/20 hover:text-amber-300 border border-transparent text-xs px-3 py-1 rounded text-gray-300 transition">Iron Impact</button>
            <button onclick="quickSearchItem('Hell Breaker')" class="bg-[#192231] hover:bg-amber-600/20 hover:text-amber-300 border border-transparent text-xs px-3 py-1 rounded text-gray-300 transition">Hell Breaker</button>
            <button onclick="quickSearchItem('Dark Vane')" class="bg-[#192231] hover:bg-amber-600/20 hover:text-amber-300 border border-transparent text-xs px-3 py-1 rounded text-gray-300 transition">Dark Vane</button>
            <button onclick="quickSearchItem('Chitin Shield')" class="bg-[#192231] hover:bg-amber-600/20 hover:text-amber-300 border border-transparent text-xs px-3 py-1 rounded text-gray-300 transition">Chitin Shield</button>
            <button onclick="quickSearchItem('Iron Necklace')" class="bg-[#192231] hover:bg-amber-600/20 hover:text-amber-300 border border-transparent text-xs px-3 py-1 rounded text-gray-300 transition">Iron Necklace</button>
            <button onclick="quickSearchItem('Iron Belt')" class="bg-[#192231] hover:bg-amber-600/20 hover:text-amber-300 border border-transparent text-xs px-3 py-1 rounded text-gray-300 transition">Iron Belt</button>
            <button onclick="quickSearchItem('Ring of Life')" class="bg-[#192231] hover:bg-amber-600/20 hover:text-amber-300 border border-transparent text-xs px-3 py-1 rounded text-gray-300 transition">Ring of Life</button>
            <button onclick="quickSearchItem('Chitin Armor')" class="bg-[#192231] hover:bg-amber-600/20 hover:text-amber-300 border border-transparent text-xs px-3 py-1 rounded text-gray-300 transition">Chitin Armor</button>
            <button onclick="quickSearchItem('Krowaz')" class="bg-[#192231] hover:bg-amber-600/20 hover:text-amber-300 border border-transparent text-xs px-3 py-1 rounded text-gray-300 transition">Krowaz</button>
          </div>

          <div id="item-search-results" class="mt-4 grid grid-cols-1 md:grid-cols-2 gap-4 max-h-[580px] overflow-y-auto pr-1">
            <div class="col-span-full text-center py-12 text-gray-500 text-sm">
              <i class="fa-solid fa-wand-magic-sparkles text-3xl mb-2 text-gray-600 block"></i>
              Aramak için yukarıdaki kutuya bir eşya adı yazın veya hızlı butonlardan birine tıklayın.
            </div>
          </div>
        </div>
      </div>

      <!-- OYUNCU SEKME 3: EDİT İTEM FORGE -->
      <div id="player-tab-forge" class="player-tab-content hidden space-y-4">
        <div class="bg-[#141a27] border border-[#232b3d] rounded-xl p-5 shadow-lg space-y-5">
          <div class="flex items-center space-x-3 border-b border-gray-800 pb-3">
            <div class="w-10 h-10 rounded-lg bg-gradient-to-tr from-amber-600 to-amber-400 text-black flex items-center justify-center text-xl font-black">
              <i class="fa-solid fa-hammer"></i>
            </div>
            <div>
              <h3 class="text-sm font-black text-amber-400 uppercase tracking-wider">
                Edit İtem Forge (Özel Üretim Atölyesi)
              </h3>
              <p class="text-xs text-gray-400">Seçili eşyanın özelliklerini kişiselleştirip doğrudan bu oyuncunun envanterine üretin.</p>
            </div>
          </div>

          <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div class="bg-[#0b0e15] border border-gray-800 rounded-lg p-4 space-y-3">
              <span class="text-xs font-bold text-gray-300 uppercase tracking-wider block">Taban Eşya:</span>
              <div class="flex items-center space-x-3">
                <div id="forge-preview-slot" class="ko-slot ko-slot-large">
                  <i class="fa-solid fa-wand-sparkles text-gray-600 text-2xl"></i>
                </div>
                <div>
                  <h4 id="forge-preview-name" class="text-sm font-bold text-amber-400">Shard (+8)</h4>
                  <p id="forge-preview-id" class="text-xs text-gray-400 font-mono">ID: 111118008</p>
                </div>
              </div>
              <p class="text-[11px] text-gray-500">İpucu: Eşya Kataloğundaki herhangi bir eşyanın üzerindeki "Edit Forge" butonuna tıklayarak doğrudan buraya yükleyebilirsiniz.</p>
            </div>

            <div class="lg:col-span-2 bg-[#0b0e15] border border-gray-800 rounded-lg p-4 space-y-4">
              <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
                <div>
                  <label class="block text-gray-400 mb-1 font-semibold">Özel İsim:</label>
                  <input type="text" id="forge-name" value="Edit Shard" class="w-full bg-[#131924] border border-gray-700 rounded px-2.5 py-1.5 text-gray-200">
                </div>
                <div>
                  <label class="block text-amber-400 mb-1 font-semibold">Attack Power (AP):</label>
                  <input type="number" id="forge-damage" value="130" class="w-full bg-[#131924] border border-gray-700 rounded px-2.5 py-1.5 text-gray-200 font-bold">
                </div>
                <div>
                  <label class="block text-blue-400 mb-1 font-semibold">Defans (AC):</label>
                  <input type="number" id="forge-ac" value="0" class="w-full bg-[#131924] border border-gray-700 rounded px-2.5 py-1.5 text-gray-200">
                </div>
                <div>
                  <label class="block text-green-400 mb-1 font-semibold">STR Bonusu:</label>
                  <input type="number" id="forge-str" value="15" class="w-full bg-[#131924] border border-gray-700 rounded px-2.5 py-1.5 text-gray-200">
                </div>
                <div>
                  <label class="block text-green-400 mb-1 font-semibold">DEX Bonusu:</label>
                  <input type="number" id="forge-dex" value="15" class="w-full bg-[#131924] border border-gray-700 rounded px-2.5 py-1.5 text-gray-200">
                </div>
                <div>
                  <label class="block text-green-400 mb-1 font-semibold">HP Bonusu:</label>
                  <input type="number" id="forge-hp" value="15" class="w-full bg-[#131924] border border-gray-700 rounded px-2.5 py-1.5 text-gray-200">
                </div>
                <div>
                  <label class="block text-red-400 mb-1 font-semibold">Flame Hasarı:</label>
                  <input type="number" id="forge-fire" value="80" class="w-full bg-[#131924] border border-gray-700 rounded px-2.5 py-1.5 text-gray-200">
                </div>
                <div>
                  <label class="block text-purple-400 mb-1 font-semibold">Poison Hasarı:</label>
                  <input type="number" id="forge-poison" value="100" class="w-full bg-[#131924] border border-gray-700 rounded px-2.5 py-1.5 text-gray-200">
                </div>
              </div>

              <div class="pt-3 border-t border-gray-800 flex justify-end">
                <button onclick="submitForgeItem()" class="bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-amber-400 text-black font-extrabold px-6 py-2.5 rounded-lg text-xs transition shadow-lg shadow-amber-500/20 flex items-center gap-2">
                  <i class="fa-solid fa-hammer"></i> Eşyayı Üret ve Seçili Oyuncuya Ver
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- OYUNCU SEKME 4: EKONOMİ, KC & SEVİYE -->
      <div id="player-tab-economy" class="player-tab-content hidden space-y-4">
        <div class="bg-[#141a27] border border-[#222b3d] rounded-xl p-5 shadow-lg space-y-5">
          <h3 class="text-xs font-bold uppercase tracking-wider text-amber-400 flex items-center gap-2">
            <i class="fa-solid fa-coins"></i> Seçili Oyuncu İçin Para, KC & Seviye İşlemleri
          </h3>

          <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
            <div class="bg-[#0b0e15] border border-gray-800 rounded-lg p-4 space-y-3">
              <span class="text-xs font-bold text-amber-400 uppercase tracking-wider flex items-center gap-1.5">
                <i class="fa-solid fa-coins"></i> Noah (Gold) Ekle
              </span>
              <div class="grid grid-cols-3 gap-2">
                <button onclick="quickGold(10000000)" class="bg-[#182233] hover:bg-amber-600 hover:text-black text-xs py-1.5 rounded text-gray-200 font-semibold transition">10M</button>
                <button onclick="quickGold(100000000)" class="bg-[#182233] hover:bg-amber-600 hover:text-black text-xs py-1.5 rounded text-gray-200 font-semibold transition">100M</button>
                <button onclick="quickGold(1000000000)" class="bg-[#182233] hover:bg-amber-600 hover:text-black text-xs py-1.5 rounded text-gray-200 font-semibold transition">1 GB</button>
              </div>
              <div class="flex gap-2">
                <input type="number" id="input-custom-gold" placeholder="Özel Miktar" class="w-full bg-[#131924] border border-gray-700 rounded px-2.5 py-1 text-xs text-gray-200">
                <button onclick="submitCustomGold()" class="bg-amber-600 hover:bg-amber-500 text-black font-bold px-3 py-1 rounded text-xs">Ekle</button>
              </div>
            </div>

            <div class="bg-[#0b0e15] border border-gray-800 rounded-lg p-4 space-y-3">
              <span class="text-xs font-bold text-green-400 uppercase tracking-wider flex items-center gap-1.5">
                <i class="fa-solid fa-gem"></i> Knight Cash (KC) Yükle
              </span>
              <div class="grid grid-cols-3 gap-2">
                <button onclick="quickKc(1000)" class="bg-[#182233] hover:bg-green-600 hover:text-black text-xs py-1.5 rounded text-gray-200 font-semibold transition">1,000</button>
                <button onclick="quickKc(5000)" class="bg-[#182233] hover:bg-green-600 hover:text-black text-xs py-1.5 rounded text-gray-200 font-semibold transition">5,000</button>
                <button onclick="quickKc(32000)" class="bg-[#182233] hover:bg-green-600 hover:text-black text-xs py-1.5 rounded text-gray-200 font-semibold transition">32,000</button>
              </div>
              <div class="flex gap-2">
                <input type="number" id="input-custom-kc" placeholder="Özel KC" class="w-full bg-[#131924] border border-gray-700 rounded px-2.5 py-1 text-xs text-gray-200">
                <button onclick="submitCustomKc()" class="bg-green-600 hover:bg-green-500 text-black font-bold px-3 py-1 rounded text-xs">Yükle</button>
              </div>
            </div>

            <div class="bg-[#0b0e15] border border-gray-800 rounded-lg p-4 space-y-3">
              <span class="text-xs font-bold text-blue-400 uppercase tracking-wider flex items-center gap-1.5">
                <i class="fa-solid fa-angle-up"></i> Seviye (Level) Ayarla
              </span>
              <p class="text-[10px] text-gray-500">Her level için 5 stat puanı otomatik olarak karaktere verilir.</p>
              <div class="flex gap-2">
                <input type="number" id="input-level-val" min="1" max="83" value="83" class="w-full bg-[#131924] border border-gray-700 rounded px-2.5 py-1 text-xs text-gray-200">
                <button onclick="submitLevel()" class="bg-blue-600 hover:bg-blue-500 text-white font-bold px-4 py-1 rounded text-xs">Ayarla</button>
              </div>
            </div>
          </div>
        </div>
      </div>

    </main>
  </div>

  <!-- ======================================================== -->
  <!-- VIEW 2: GENEL SUNUCU & ETKİNLİK YÖNETİMİ                 -->
  <!-- ======================================================== -->
  <div id="view-server-mode" class="hidden flex-1 flex flex-col w-full max-w-[1920px] mx-auto overflow-y-auto p-6 space-y-6">

    <div class="bg-gradient-to-r from-[#171f2c] via-[#151c27] to-[#121620] border border-[#273245] rounded-xl p-4 shadow-xl flex items-center justify-between">
      <div class="flex items-center space-x-3.5">
        <div class="w-11 h-11 rounded-xl bg-gradient-to-br from-amber-500 to-amber-700 text-black flex items-center justify-center text-2xl font-black shadow-lg shadow-amber-500/20">
          <i class="fa-solid fa-server"></i>
        </div>
        <div>
          <h2 class="text-base font-black text-amber-400 uppercase tracking-wider">
            Genel Sunucu & Etkinlik Masası
          </h2>
          <p class="text-xs text-gray-400">Boss Spawner, Boss Listesi, Savaşlar (Lunar Wars, CSW, Snow), EXP/NP Bonusları ve Sunucu Duyuruları</p>
        </div>
      </div>
      <button onclick="killAllMobsInZone()" class="bg-red-950 hover:bg-red-800 text-red-200 border border-red-700/50 text-xs font-bold px-4 py-2 rounded-lg transition flex items-center gap-2 shadow-lg">
        <i class="fa-solid fa-skull"></i> Seçili Bölgedeki Tüm Canavarları Temizle (Kill All)
      </button>
    </div>

    <!-- BOSS & CANAVAR SPAWNER -->
    <div class="bg-[#121722] border border-[#232c3d] rounded-xl p-5 shadow-xl space-y-4">
      <div class="flex items-center justify-between border-b border-gray-800 pb-3">
        <div class="flex items-center space-x-2.5">
          <i class="fa-solid fa-dragon text-amber-400 text-lg"></i>
          <h3 class="text-xs font-black uppercase tracking-wider text-gray-200">
            Boss Spawner & Hazır Boss Kataloğu
          </h3>
        </div>
        <div class="flex items-center space-x-3 text-xs">
          <span class="text-gray-400 font-semibold">Hedef Bölge:</span>
          <select id="server-spawn-zone" class="bg-[#0b0e15] border border-gray-700 rounded-lg px-3 py-1.5 text-xs text-gray-200 font-semibold">
            <option value="21">21 - Moradon Town</option>
            <option value="71" selected>71 - Colony Zone Bowl</option>
            <option value="1">1 - Luferson Castle</option>
            <option value="2">2 - El Morad Castle</option>
            <option value="11">11 - Karus Eslant</option>
            <option value="12">12 - El Morad Eslant</option>
            <option value="72">72 - Ardream</option>
          </select>
          <span class="text-gray-400 font-semibold">Adet:</span>
          <input type="number" id="server-spawn-count" value="1" min="1" max="50" class="w-16 bg-[#0b0e15] border border-gray-700 rounded-lg px-2 py-1.5 text-xs text-gray-200 text-center font-bold">
        </div>
      </div>

      <div id="server-boss-grid" class="grid grid-cols-2 sm:grid-cols-4 md:grid-cols-5 lg:grid-cols-7 gap-2.5"></div>

      <div class="pt-3 border-t border-gray-800 space-y-2">
        <span class="text-xs font-bold text-gray-400 uppercase tracking-wider">Tüm NPC / Canavar Tablosunda Arama Yap:</span>
        <div class="flex gap-2">
          <input type="text" id="server-mob-query" onkeydown="if(event.key==='Enter') searchServerMobs()" placeholder="Canavar adı veya SSID girin (örn: Atross, Riote, Lycaon, Orc, 5702)..." class="w-full bg-[#0a0d14] border border-gray-700 rounded-lg px-3 py-2 text-xs text-gray-200 focus:outline-none focus:border-amber-500">
          <button onclick="searchServerMobs()" class="bg-amber-600 hover:bg-amber-500 text-black font-bold px-5 py-2 rounded-lg text-xs transition">
            Canavar Ara
          </button>
        </div>
        <div id="server-mob-results" class="grid grid-cols-1 sm:grid-cols-3 gap-2 max-h-40 overflow-y-auto"></div>
      </div>
    </div>

    <!-- SAVAŞLAR & GENEL ETKİNLİKLER -->
    <div class="bg-[#121722] border border-[#232c3d] rounded-xl p-5 shadow-xl space-y-4">
      <div class="flex items-center space-x-2.5 border-b border-gray-800 pb-3">
        <i class="fa-solid fa-flag-checkered text-amber-400 text-lg"></i>
        <h3 class="text-xs font-black uppercase tracking-wider text-gray-200">
          Genel Savaş & Etkinlik Açma / Kapama (Lunar Wars, CSW & Boostlar)
        </h3>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="bg-[#0b0e15] border border-gray-800 rounded-lg p-3.5 space-y-2.5">
          <span class="text-xs font-bold text-amber-400 flex items-center gap-1.5">
            <i class="fa-solid fa-swords"></i> Lunar War 1 (Alseids Plain)
          </span>
          <p class="text-[11px] text-gray-400">Klasik Alseids Plain 1. Irk Savaşı.</p>
          <div class="flex gap-2">
            <button onclick="triggerWar(1, 'open')" class="flex-1 bg-amber-600 hover:bg-amber-500 text-black text-xs font-bold py-1.5 rounded transition">Başlat</button>
            <button onclick="triggerWar(1, 'close')" class="flex-1 bg-gray-800 hover:bg-gray-700 text-gray-300 text-xs font-bold py-1.5 rounded transition">Kapat</button>
          </div>
        </div>

        <div class="bg-[#0b0e15] border border-gray-800 rounded-lg p-3.5 space-y-2.5">
          <span class="text-xs font-bold text-amber-400 flex items-center gap-1.5">
            <i class="fa-solid fa-ship"></i> Lunar War 2 (Nereids Island)
          </span>
          <p class="text-[11px] text-gray-400">Nereids Adası Gemi Savaşı.</p>
          <div class="flex gap-2">
            <button onclick="triggerWar(2, 'open')" class="flex-1 bg-amber-600 hover:bg-amber-500 text-black text-xs font-bold py-1.5 rounded transition">Başlat</button>
            <button onclick="triggerWar(2, 'close')" class="flex-1 bg-gray-800 hover:bg-gray-700 text-gray-300 text-xs font-bold py-1.5 rounded transition">Kapat</button>
          </div>
        </div>

        <div class="bg-[#0b0e15] border border-gray-800 rounded-lg p-3.5 space-y-2.5">
          <span class="text-xs font-bold text-blue-400 flex items-center gap-1.5">
            <i class="fa-solid fa-chess-rook"></i> Castle Siege Warfare (CSW)
          </span>
          <p class="text-[11px] text-gray-400">Delos Kalesi Klan Kuşatması.</p>
          <div class="flex gap-2">
            <button onclick="triggerWar(1, 'open')" class="flex-1 bg-blue-600 hover:bg-blue-500 text-white text-xs font-bold py-1.5 rounded transition">CSW Aç</button>
            <button onclick="triggerWar(1, 'close')" class="flex-1 bg-gray-800 hover:bg-gray-700 text-gray-300 text-xs font-bold py-1.5 rounded transition">Bitir</button>
          </div>
        </div>

        <div class="bg-[#0b0e15] border border-gray-800 rounded-lg p-3.5 space-y-2.5">
          <span class="text-xs font-bold text-cyan-400 flex items-center gap-1.5">
            <i class="fa-solid fa-snowflake"></i> Snow War (Kartopu Savaşı)
          </span>
          <p class="text-[11px] text-gray-400">Kartopu Arenası Savaşı.</p>
          <div class="flex gap-2">
            <button onclick="triggerWar(10, 'open')" class="flex-1 bg-cyan-600 hover:bg-cyan-500 text-black text-xs font-bold py-1.5 rounded transition">Başlat</button>
            <button onclick="triggerWar(10, 'close')" class="flex-1 bg-gray-800 hover:bg-gray-700 text-gray-300 text-xs font-bold py-1.5 rounded transition">Kapat</button>
          </div>
        </div>
      </div>

      <!-- Sunucu Bonus Boostları -->
      <div class="pt-3 border-t border-gray-800 grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="bg-[#0b0e15] border border-gray-800 rounded-lg p-3.5 space-y-2">
          <span class="text-xs font-bold text-green-400 flex items-center gap-1.5">
            <i class="fa-solid fa-bolt"></i> Sunucu EXP Boost Event
          </span>
          <div class="grid grid-cols-4 gap-1.5">
            <button onclick="setEventBonus('EXP', 20)" class="bg-[#151d2a] hover:bg-green-600 hover:text-black text-xs py-1 rounded text-gray-300 font-semibold transition">+%20</button>
            <button onclick="setEventBonus('EXP', 50)" class="bg-[#151d2a] hover:bg-green-600 hover:text-black text-xs py-1 rounded text-gray-300 font-semibold transition">+%50</button>
            <button onclick="setEventBonus('EXP', 100)" class="bg-[#151d2a] hover:bg-green-600 hover:text-black text-xs py-1 rounded text-gray-300 font-semibold transition">+%100</button>
            <button onclick="setEventBonus('EXP', 0)" class="bg-red-950 hover:bg-red-800 text-red-300 text-xs py-1 rounded font-bold transition">Kapat</button>
          </div>
        </div>

        <div class="bg-[#0b0e15] border border-gray-800 rounded-lg p-3.5 space-y-2">
          <span class="text-xs font-bold text-amber-400 flex items-center gap-1.5">
            <i class="fa-solid fa-coins"></i> Sunucu Noah / Para Boost Event
          </span>
          <div class="grid grid-cols-4 gap-1.5">
            <button onclick="setEventBonus('MONEY', 25)" class="bg-[#151d2a] hover:bg-amber-600 hover:text-black text-xs py-1 rounded text-gray-300 font-semibold transition">+%25</button>
            <button onclick="setEventBonus('MONEY', 50)" class="bg-[#151d2a] hover:bg-amber-600 hover:text-black text-xs py-1 rounded text-gray-300 font-semibold transition">+%50</button>
            <button onclick="setEventBonus('MONEY', 100)" class="bg-[#151d2a] hover:bg-amber-600 hover:text-black text-xs py-1 rounded text-gray-300 font-semibold transition">+%100</button>
            <button onclick="setEventBonus('MONEY', 0)" class="bg-red-950 hover:bg-red-800 text-red-300 text-xs py-1 rounded font-bold transition">Kapat</button>
          </div>
        </div>

        <div class="bg-[#0b0e15] border border-gray-800 rounded-lg p-3.5 space-y-2">
          <span class="text-xs font-bold text-purple-400 flex items-center gap-1.5">
            <i class="fa-solid fa-award"></i> Sunucu NP Boost Event
          </span>
          <div class="grid grid-cols-4 gap-1.5">
            <button onclick="setEventBonus('NP', 10)" class="bg-[#151d2a] hover:bg-purple-600 hover:text-white text-xs py-1 rounded text-gray-300 font-semibold transition">+10</button>
            <button onclick="setEventBonus('NP', 20)" class="bg-[#151d2a] hover:bg-purple-600 hover:text-white text-xs py-1 rounded text-gray-300 font-semibold transition">+20</button>
            <button onclick="setEventBonus('NP', 35)" class="bg-[#151d2a] hover:bg-purple-600 hover:text-white text-xs py-1 rounded text-gray-300 font-semibold transition">+35</button>
            <button onclick="setEventBonus('NP', 0)" class="bg-red-950 hover:bg-red-800 text-red-300 text-xs py-1 rounded font-bold transition">Kapat</button>
          </div>
        </div>
      </div>
    </div>

    <!-- CANLI DUYURU & KOMUT GEÇMİŞİ -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div class="bg-[#121722] border border-[#232c3d] rounded-xl p-5 shadow-xl space-y-3">
        <h3 class="text-xs font-black uppercase tracking-wider text-amber-400 flex items-center gap-2">
          <i class="fa-solid fa-bullhorn"></i> Oyun İçi Canlı GM Duyurusu (Notice)
        </h3>
        <textarea id="server-notice-text" rows="3" placeholder="Tüm sunucuya geçilecek GM duyurusunu yazın..." class="w-full bg-[#0a0d14] border border-gray-700 rounded-lg p-3 text-xs text-gray-200 focus:outline-none focus:border-amber-500"></textarea>
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-3 text-xs">
            <label class="flex items-center space-x-1.5 cursor-pointer">
              <input type="radio" name="server_notice_type" value="notice" checked class="accent-amber-500">
              <span>Sarı Notice</span>
            </label>
            <label class="flex items-center space-x-1.5 cursor-pointer">
              <input type="radio" name="server_notice_type" value="announcement" class="accent-amber-500">
              <span>Kırmızı / Beyaz Ekran Ortası</span>
            </label>
          </div>
          <button onclick="sendServerNotice()" class="bg-amber-600 hover:bg-amber-500 text-black font-bold px-5 py-2 rounded-lg text-xs transition">
            <i class="fa-solid fa-paper-plane mr-1"></i> Duyuruyu Geç
          </button>
        </div>
      </div>

      <div class="bg-[#121722] border border-[#232c3d] rounded-xl p-5 shadow-xl space-y-3">
        <div class="flex items-center justify-between">
          <h3 class="text-xs font-black uppercase tracking-wider text-gray-200 flex items-center gap-2">
            <i class="fa-solid fa-clock-rotate-left text-amber-400"></i> Komut Kuyruğu Geçmişi
          </h3>
          <button onclick="loadQueueHistory()" class="text-xs text-amber-400 hover:text-amber-300">
            <i class="fa-solid fa-rotate-right"></i>
          </button>
        </div>
        <div class="overflow-x-auto max-h-56 overflow-y-auto">
          <table class="w-full text-left text-xs text-gray-300">
            <thead class="bg-[#090d14] text-[10px] uppercase text-gray-500 font-bold sticky top-0">
              <tr>
                <th class="p-2">ID</th>
                <th class="p-2">Komut</th>
                <th class="p-2">Parametre</th>
                <th class="p-2">Durum</th>
                <th class="p-2">Sonuç</th>
              </tr>
            </thead>
            <tbody id="history-tbody" class="divide-y divide-gray-800"></tbody>
          </table>
        </div>
      </div>
    </div>

  </div>

  <!-- ======================================================== -->
  <!-- VIEW 3: YARATIK, DROP & SPAWN EDİTÖRÜ (TAMAMEN YENİ!)    -->
  <!-- ======================================================== -->
  <div id="view-mobs-mode" class="hidden flex-1 flex flex-col lg:flex-row w-full max-w-[1920px] mx-auto overflow-hidden">

    <!-- SOL SÜTUN: CANAVAR LİSTESİ & FİLTRELER -->
    <aside class="w-full lg:w-96 bg-[#0d121b] border-b lg:border-b-0 lg:border-r border-[#20293a] flex flex-col h-auto lg:h-[calc(100vh-57px)] flex-shrink-0">
      
      <div class="p-3.5 border-b border-[#20293a] bg-[#111723] space-y-2.5">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-2">
            <i class="fa-solid fa-dragon text-amber-400 text-sm"></i>
            <h2 class="text-xs font-black uppercase tracking-wider text-gray-200">Yaratık Kataloğu</h2>
            <span id="mob-total-badge" class="text-[10px] bg-gray-800 text-gray-300 px-1.5 py-0.2 rounded font-mono font-bold">0</span>
          </div>
          <button onclick="loadMobsList(0)" class="text-[11px] text-amber-400 hover:text-amber-300 flex items-center gap-1 transition">
            <i class="fa-solid fa-rotate-right"></i> Yenile
          </button>
        </div>

        <!-- Search Bar -->
        <div class="relative">
          <i class="fa-solid fa-magnifying-glass absolute left-3 top-2.5 text-gray-500 text-xs"></i>
          <input type="text" id="mob-search-input" oninput="debounceMobFilter()" placeholder="Canavar adı veya SSID ara (örn: Felankor, 5702)..." class="w-full bg-[#080c12] border border-gray-700/80 rounded-lg pl-8 pr-3 py-1.5 text-xs text-gray-200 placeholder-gray-500 focus:outline-none focus:border-amber-500">
        </div>

        <!-- Category & Drop Filters -->
        <div class="grid grid-cols-3 gap-1 text-[11px]">
          <button onclick="setMobCategoryFilter('all')" id="filter-mobcat-all" class="filter-btn active text-center">Tümü</button>
          <button onclick="setMobCategoryFilter('boss')" id="filter-mobcat-boss" class="filter-btn text-center text-amber-300">👑 Bosslar</button>
          <button onclick="setMobCategoryFilter('normal')" id="filter-mobcat-normal" class="filter-btn text-center">👾 Normal</button>
        </div>

        <!-- Drop Status Filter -->
        <div class="flex items-center space-x-1.5 text-[11px]">
          <span class="text-[10px] text-gray-500 font-bold uppercase w-10">Drop:</span>
          <button onclick="setMobDropFilter('all')" id="filter-mobdrop-all" class="filter-btn active">Tümü</button>
          <button onclick="setMobDropFilter('yes')" id="filter-mobdrop-yes" class="filter-btn text-green-400">🎁 Drobu Var</button>
          <button onclick="setMobDropFilter('no')" id="filter-mobdrop-no" class="filter-btn text-gray-400">Drobu Yok</button>
        </div>

        <!-- Zone Selector -->
        <div class="flex items-center space-x-2 text-[11px]">
          <span class="text-[10px] text-gray-500 font-bold uppercase w-10">Bölge:</span>
          <select id="mob-zone-filter" onchange="loadMobsList(0)" class="w-full bg-[#0a0e16] border border-gray-700 rounded-lg px-2 py-1 text-xs text-gray-200">
            <option value="0">Tüm Bölgeler</option>
            <option value="71">71 - Colony Zone (Ronark Land)</option>
            <option value="21">21 - Moradon</option>
            <option value="11">11 - Karus Eslant</option>
            <option value="12">12 - El Morad Eslant</option>
            <option value="1">1 - Luferson Castle</option>
            <option value="2">2 - El Morad Castle</option>
            <option value="72">72 - Ardream</option>
            <option value="73">73 - Ronark Land Base</option>
            <option value="30">30 - Delos</option>
            <option value="31">31 - Bifrost</option>
            <option value="84">84 - Krowaz</option>
            <option value="94">94 - Felankor Lair</option>
          </select>
        </div>

        <!-- Quick Mob Filter Shortcuts -->
        <div class="flex flex-wrap gap-1 text-[10px] pt-1 border-t border-gray-800/80">
          <span class="text-gray-500 font-bold py-0.5">Popüler:</span>
          <button onclick="quickFilterMobName('Felankor')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-1.5 py-0.2 rounded">Felankor</button>
          <button onclick="quickFilterMobName('Ultima')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-1.5 py-0.2 rounded">Ultima</button>
          <button onclick="quickFilterMobName('Isiloon')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-1.5 py-0.2 rounded">Isiloon</button>
          <button onclick="quickFilterMobName('Talos')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-1.5 py-0.2 rounded">Talos</button>
          <button onclick="quickFilterMobName('Snake Queen')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-1.5 py-0.2 rounded">Snake Queen</button>
          <button onclick="quickFilterMobName('Harpy Queen')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-1.5 py-0.2 rounded">Harpy Queen</button>
          <button onclick="quickFilterMobName('Troll King')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-1.5 py-0.2 rounded">Troll King</button>
          <button onclick="quickFilterMobName('Lycaon')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-1.5 py-0.2 rounded">Lycaon</button>
          <button onclick="quickFilterMobName('Atross')" class="bg-[#182130] hover:bg-amber-600/20 text-gray-300 px-1.5 py-0.2 rounded">Atross</button>
        </div>
      </div>

      <!-- Scrollable Mob Cards List -->
      <div id="mobs-list-container" class="flex-1 overflow-y-auto p-2.5 space-y-2">
        <div class="text-xs text-center text-gray-500 py-10">Canavarlar yükleniyor...</div>
      </div>

      <!-- Pagination -->
      <div class="p-2.5 border-t border-[#20293a] bg-[#111723] flex items-center justify-between text-xs">
        <button onclick="changeMobPage(-1)" id="btn-mob-prev" class="bg-[#161f2e] hover:bg-amber-600 hover:text-black text-gray-300 px-3 py-1 rounded transition disabled:opacity-30 disabled:pointer-events-none">
          <i class="fa-solid fa-chevron-left mr-1"></i> Önceki
        </button>
        <span id="mob-page-text" class="text-gray-400 font-mono text-[11px]">1 / 1</span>
        <button onclick="changeMobPage(1)" id="btn-mob-next" class="bg-[#161f2e] hover:bg-amber-600 hover:text-black text-gray-300 px-3 py-1 rounded transition disabled:opacity-30 disabled:pointer-events-none">
          Sonraki <i class="fa-solid fa-chevron-right ml-1"></i>
        </button>
      </div>
    </aside>

    <!-- SAĞ SÜTUN: SEÇİLİ CANAVARIN DROP & SPAWN DÜZENLEME MASASI -->
    <main class="flex-1 flex flex-col h-auto lg:h-[calc(100vh-57px)] overflow-y-auto p-5 space-y-5">
      
      <!-- CANAVAR BİLGİ KARTI -->
      <div id="selected-mob-banner" class="bg-gradient-to-r from-[#171f2c] via-[#141b27] to-[#111620] border border-[#273245] rounded-xl p-4 shadow-xl">
        <div class="flex flex-wrap items-center justify-between gap-4">
          
          <div class="flex items-center space-x-3.5">
            <div id="mob-detail-avatar" class="w-14 h-14 rounded-xl bg-gradient-to-tr from-red-600 to-amber-500 text-black flex items-center justify-center text-2xl font-black shadow-lg shadow-red-500/20 p-2.5">
              <i class="fa-solid fa-dragon"></i>
            </div>
            <div>
              <div class="flex items-center gap-2">
                <h2 id="mob-detail-name" class="text-xl font-black text-amber-400">Felankor</h2>
                <span id="mob-detail-ssid" class="text-xs bg-[#0b0e14] px-2 py-0.5 rounded border border-gray-700 font-mono text-gray-300">SSID: 5702</span>
                <span id="mob-detail-boss-badge" class="text-[10px] px-2 py-0.5 rounded bg-amber-500 text-black font-extrabold shadow-sm">BOSS</span>
              </div>
              <div class="text-xs text-gray-400 mt-1 flex flex-wrap gap-x-4">
                <span>Seviye: <b id="mob-detail-level" class="text-white font-bold">230</b></span>
                <span>Max HP: <b id="mob-detail-hp" class="text-green-400 font-mono font-bold">1,981,241</b></span>
                <span>Attack: <b id="mob-detail-atk" class="text-amber-300 font-mono">3,200</b></span>
                <span>Defans: <b id="mob-detail-ac" class="text-blue-300 font-mono">1,100</b></span>
                <span>Exp: <b id="mob-detail-exp" class="text-purple-300 font-mono">150,000</b></span>
                <span>NP: <b id="mob-detail-np" class="text-yellow-400 font-mono">1,000</b></span>
              </div>
            </div>
          </div>

          <!-- Quick Test Spawn Button -->
          <div class="flex items-center gap-2">
            <button onclick="testSpawnSelectedMob()" class="bg-[#1c2536] hover:bg-amber-600 hover:text-black text-amber-300 border border-amber-500/40 text-xs font-bold px-4 py-2.5 rounded-lg transition flex items-center gap-2 shadow-lg shadow-amber-500/10">
              <i class="fa-solid fa-crosshairs"></i> Test Spawn Et (CZ Bowl / Moradon)
            </button>
          </div>

        </div>
      </div>

      <!-- 1. BÖLÜM: DROP ORANLARI VE DÜŞEN EŞYALAR (7 SLOT) -->
      <div class="bg-[#121722] border border-[#232c3d] rounded-xl p-5 shadow-xl space-y-4">
        <div class="flex items-center justify-between border-b border-gray-800 pb-3">
          <div class="flex items-center space-x-2.5">
            <i class="fa-solid fa-gift text-amber-400 text-lg"></i>
            <div>
              <h3 class="text-xs font-black uppercase tracking-wider text-gray-200">
                Canavar Drop Oranları & Düşen Eşyalar (7 Slot)
              </h3>
              <p class="text-[11px] text-gray-400">Her slot için eşyayı ve düşme ihtimali yüzdesini (%0.01 - %100) belirleyin.</p>
            </div>
          </div>
          <button onclick="saveMobDrops()" class="bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-amber-400 text-black font-extrabold px-6 py-2.5 rounded-lg text-xs transition shadow-lg shadow-amber-500/20 flex items-center gap-2">
            <i class="fa-solid fa-floppy-disk"></i> Drop Oranlarını Kaydet & Oyuna Uygula
          </button>
        </div>

        <!-- 7 Drop Slots Grid -->
        <div id="mob-drops-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-7 gap-3">
          <!-- Populated by JS -->
        </div>
      </div>

      <!-- 2. BÖLÜM: SPAWN NOKTALARI, ADETLERİ VE RESPAWN SÜRELERİ -->
      <div class="bg-[#121722] border border-[#232c3d] rounded-xl p-5 shadow-xl space-y-4">
        <div class="flex items-center justify-between border-b border-gray-800 pb-3">
          <div class="flex items-center space-x-2.5">
            <i class="fa-solid fa-map-location-dot text-amber-400 text-lg"></i>
            <div>
              <h3 class="text-xs font-black uppercase tracking-wider text-gray-200">
                Canavarın Doğma (Spawn) Noktaları & Yeniden Doğma Süreleri (Respawn)
              </h3>
              <p class="text-[11px] text-gray-400">Hangi bölgelerde kaç adet doğduğunu ve öldükten kaç saniye sonra yeniden doğacağını düzenleyin.</p>
            </div>
          </div>
        </div>

        <!-- Current Spawns Table -->
        <div class="overflow-x-auto">
          <table class="w-full text-left text-xs text-gray-300">
            <thead class="bg-[#090d14] text-[10px] uppercase text-gray-500 font-bold">
              <tr>
                <th class="p-3">Bölge (Zone)</th>
                <th class="p-3">Spawn Adedi (NumNPC)</th>
                <th class="p-3">Yeniden Doğma Süresi (RegTime)</th>
                <th class="p-3">Koordinatlar (X, Z)</th>
                <th class="p-3 text-right">İşlemler</th>
              </tr>
            </thead>
            <tbody id="mob-spawns-tbody" class="divide-y divide-gray-800">
              <!-- Populated by JS -->
            </tbody>
          </table>
        </div>

        <!-- Yeni Spawn Noktası Ekleme Paneli -->
        <div class="bg-[#0c1017] border border-gray-800 rounded-xl p-4 space-y-3 mt-4">
          <h4 class="text-xs font-bold text-amber-400 uppercase tracking-wider flex items-center gap-1.5">
            <i class="fa-solid fa-plus-circle"></i> Bu Canavar İçin Yeni Spawn Noktası Ekle
          </h4>
          <div class="grid grid-cols-1 sm:grid-cols-5 gap-3 text-xs">
            <div>
              <label class="block text-gray-400 mb-1">Bölge (Zone):</label>
              <select id="new-spawn-zone" class="w-full bg-[#121822] border border-gray-700 rounded-lg px-2.5 py-1.5 text-gray-200">
                <option value="71">71 - Colony Zone Bowl</option>
                <option value="21">21 - Moradon Town</option>
                <option value="11">11 - Karus Eslant</option>
                <option value="12">12 - El Morad Eslant</option>
                <option value="1">1 - Luferson Castle</option>
                <option value="2">2 - El Morad Castle</option>
                <option value="72">72 - Ardream</option>
                <option value="30">30 - Delos</option>
                <option value="94">94 - Felankor Lair</option>
              </select>
            </div>
            <div>
              <label class="block text-gray-400 mb-1">Doğacak Adet:</label>
              <input type="number" id="new-spawn-count" value="1" min="1" max="50" class="w-full bg-[#121822] border border-gray-700 rounded-lg px-2.5 py-1.5 text-gray-200">
            </div>
            <div>
              <label class="block text-gray-400 mb-1">Yeniden Doğma (Saniye):</label>
              <input type="number" id="new-spawn-time" value="60" min="5" max="86400" class="w-full bg-[#121822] border border-gray-700 rounded-lg px-2.5 py-1.5 text-gray-200" title="Örn: 60 = 1 dakika, 3600 = 1 saat">
            </div>
            <div>
              <label class="block text-gray-400 mb-1">X Koordinatı:</label>
              <input type="number" id="new-spawn-x" value="1024" class="w-full bg-[#121822] border border-gray-700 rounded-lg px-2.5 py-1.5 text-gray-200">
            </div>
            <div>
              <label class="block text-gray-400 mb-1">Z Koordinatı:</label>
              <input type="number" id="new-spawn-z" value="1024" class="w-full bg-[#121822] border border-gray-700 rounded-lg px-2.5 py-1.5 text-gray-200">
            </div>
          </div>
          <div class="flex justify-end pt-2">
            <button onclick="addNewSpawnPoint()" class="bg-amber-600 hover:bg-amber-500 text-black font-extrabold px-5 py-2 rounded-lg text-xs transition shadow-md">
              <i class="fa-solid fa-plus mr-1"></i> Spawn Noktasını Ekle & Haritaya Koy
            </button>
          </div>
        </div>

      </div>

    </main>
  </div>

  <!-- ======================================================== -->
  <!-- JAVASCRIPT: MASTER APPLICATION LOGIC                      -->
  <!-- ======================================================== -->
  <script>
    let currentMainMode = 'players';
    let currentPlayerTab = 'discipline';
    let selectedPlayer = null;
    let charactersList = [];
    let filterStatus = 'all';
    let filterNation = 'all';
    let filterJob = 'all';
    let selectedPunishMinutes = 60;
    let cachedVariants = {};
    let debounceTimer = null;

    // Mob Management State
    let mobsList = [];
    let selectedMob = null;
    let mobOffset = 0;
    let mobLimit = 35;
    let mobTotal = 0;
    let mobFilterCategory = 'all';
    let mobFilterDrop = 'all';
    let activePickerSlot = 1;
    let currentMobDrops = [];

    // --- MAIN MODE SWITCHER ---
    function setMainMode(mode) {
      currentMainMode = mode;
      document.getElementById('nav-mode-players').classList.toggle('active', mode === 'players');
      document.getElementById('nav-mode-server').classList.toggle('active', mode === 'server');
      document.getElementById('nav-mode-mobs').classList.toggle('active', mode === 'mobs');
      
      document.getElementById('view-players-mode').classList.toggle('hidden', mode !== 'players');
      document.getElementById('view-server-mode').classList.toggle('hidden', mode !== 'server');
      document.getElementById('view-mobs-mode').classList.toggle('hidden', mode !== 'mobs');

      if (mode === 'server') {
        loadServerBossPresets();
        loadQueueHistory();
      } else if (mode === 'mobs') {
        loadMobsList(0);
      }
    }

    // --- PLAYER TAB SWITCHER ---
    function switchPlayerTab(tab) {
      currentPlayerTab = tab;
      const tabs = ['discipline', 'items', 'forge', 'economy'];
      tabs.forEach(t => {
        const btn = document.getElementById(`tab-btn-${t}`);
        const content = document.getElementById(`player-tab-${t}`);
        if (btn) {
          if (t === tab) {
            btn.className = "tab-btn py-3 px-3 text-xs sm:text-sm font-bold border-b-2 border-amber-500 text-amber-400 flex items-center gap-2";
          } else {
            btn.className = "tab-btn py-3 px-3 text-xs sm:text-sm font-semibold border-b-2 border-transparent text-gray-400 hover:text-gray-200 flex items-center gap-2";
          }
        }
        if (content) {
          content.classList.toggle('hidden', t !== tab);
        }
      });
    }

    // --- TOAST NOTIFICATIONS ---
    function showToast(message, isError = false) {
      const toast = document.getElementById('toast');
      const msg = document.getElementById('toast-msg');
      const icon = document.getElementById('toast-icon');

      msg.innerText = message;
      if (isError) {
        toast.className = "fixed bottom-5 right-5 z-50 transform transition-all duration-300 translate-y-0 opacity-100 bg-red-950 border border-red-500 text-white px-5 py-3 rounded-xl shadow-2xl flex items-center space-x-3";
        icon.className = "fa-solid fa-circle-exclamation text-red-400 text-lg";
      } else {
        toast.className = "fixed bottom-5 right-5 z-50 transform transition-all duration-300 translate-y-0 opacity-100 bg-[#161f2e] border border-amber-500/80 text-white px-5 py-3 rounded-xl shadow-2xl flex items-center space-x-3";
        icon.className = "fa-solid fa-circle-check text-amber-400 text-lg";
      }

      setTimeout(() => {
        toast.classList.remove('translate-y-0', 'opacity-100');
        toast.classList.add('translate-y-20', 'opacity-0');
      }, 3500);
    }

    // --- SERVER STATUS ---
    async function loadStatus() {
      try {
        const res = await fetch('/api/status');
        const data = await res.json();
        
        const badgeGame = document.getElementById('badge-game');
        const textGame = document.getElementById('text-game');
        if (data.game_server) {
          badgeGame.className = "w-2.5 h-2.5 rounded-full bg-green-500 shadow-sm shadow-green-500/50";
          textGame.innerText = "Aktif (15001)";
          textGame.className = "text-green-400 font-bold";
        } else {
          badgeGame.className = "w-2.5 h-2.5 rounded-full bg-red-500 animate-pulse";
          textGame.innerText = "Kapalı";
          textGame.className = "text-red-400 font-bold";
        }

        const badgeLogin = document.getElementById('badge-login');
        const textLogin = document.getElementById('text-login');
        if (data.login_server) {
          badgeLogin.className = "w-2.5 h-2.5 rounded-full bg-green-500 shadow-sm shadow-green-500/50";
          textLogin.innerText = "Aktif (15100)";
          textLogin.className = "text-green-400 font-bold";
        } else {
          badgeLogin.className = "w-2.5 h-2.5 rounded-full bg-red-500 animate-pulse";
          textLogin.innerText = "Kapalı";
          textLogin.className = "text-red-400 font-bold";
        }
      } catch (err) {
        console.error("Status load failed", err);
      }
    }

    // --- LOAD CHARACTERS ---
    async function loadCharactersList() {
      try {
        const q = document.getElementById('sidebar-search-input').value.trim();
        const url = `/api/characters/search?q=${encodeURIComponent(q)}&status=${filterStatus}&nation=${filterNation}&job=${filterJob}&limit=150`;
        const res = await fetch(url);
        const data = await res.json();

        charactersList = data.characters || [];
        document.getElementById('sidebar-total-badge').innerText = data.total;
        document.getElementById('count-status-all').innerText = data.total;
        document.getElementById('count-status-online').innerText = data.online_count;
        document.getElementById('count-status-offline').innerText = data.offline_count;

        renderSidebarList(charactersList);

        if (!selectedPlayer && charactersList.length > 0) {
          selectPlayer(charactersList[0]);
        } else if (selectedPlayer) {
          const fresh = charactersList.find(c => c.name === selectedPlayer.name);
          if (fresh) selectPlayer(fresh);
        }
      } catch (err) {
        console.error("Characters load failed", err);
      }
    }

    function renderSidebarList(chars) {
      const container = document.getElementById('sidebar-players-container');
      if (!chars || chars.length === 0) {
        container.innerHTML = `<div class="text-xs text-center text-gray-500 py-10">Filtreye uygun oyuncu bulunamadı.</div>`;
        return;
      }

      container.innerHTML = chars.map(c => {
        const isSel = selectedPlayer && selectedPlayer.name === c.name;
        const jobIcons = {
          warrior: 'fa-user-shield',
          rogue: 'fa-user-ninja',
          mage: 'fa-wand-magic-sparkles',
          priest: 'fa-cross',
          kurian: 'fa-dragon'
        };
        const icon = jobIcons[c.job_category] || 'fa-user';

        let badges = '';
        if (c.is_punished) badges += `<span class="text-[9px] bg-amber-500 text-black font-extrabold px-1.5 py-0.2 rounded animate-pulse">[CEZALI]</span>`;
        if (c.is_gm) badges += `<span class="text-[9px] bg-red-600 text-white font-extrabold px-1.5 py-0.2 rounded">GM</span>`;
        if (c.is_banned) badges += `<span class="text-[9px] bg-purple-900 text-purple-200 font-extrabold px-1.5 py-0.2 rounded">BAN</span>`;
        if (c.is_muted) badges += `<span class="text-[9px] bg-yellow-900 text-yellow-200 font-extrabold px-1.5 py-0.2 rounded">MUTE</span>`;

        const onlineDot = c.is_online 
          ? `<span class="w-2 h-2 rounded-full bg-green-500 shadow-sm shadow-green-500/50" title="Çevrimiçi"></span>`
          : `<span class="w-2 h-2 rounded-full bg-gray-600" title="Çevrimdışı"></span>`;

        return `
          <div onclick="selectPlayerByName('${c.name}')" class="player-card ${isSel ? 'active' : ''} p-3 rounded-xl border border-[#20293b] bg-[#121722] hover:bg-[#171f2e] cursor-pointer transition flex items-center justify-between">
            <div class="flex items-center space-x-3">
              <div class="w-9 h-9 rounded-lg bg-[#1a2333] border border-gray-700/60 flex items-center justify-center text-amber-400 text-base">
                <i class="fa-solid ${icon}"></i>
              </div>
              <div>
                <div class="flex items-center gap-1.5">
                  <span class="text-xs font-bold ${isSel ? 'text-amber-400' : 'text-gray-200'}">${c.name}</span>
                  ${badges}
                </div>
                <div class="text-[10px] text-gray-400 mt-0.5">
                  Lvl ${c.level} • ${c.job_title} • ${c.nation_name === 'Karus' ? '🔴' : '🔵'} ${c.nation_name}
                </div>
              </div>
            </div>
            <div class="flex items-center space-x-2">
              ${onlineDot}
            </div>
          </div>
        `;
      }).join('');
    }

    function selectPlayerByName(name) {
      const char = charactersList.find(c => c.name === name);
      if (char) selectPlayer(char);
    }

    function selectPlayer(char) {
      selectedPlayer = char;
      renderSidebarList(charactersList);

      document.getElementById('sel-char-name').innerText = char.name;
      document.getElementById('sel-level-text').innerText = char.level;
      document.getElementById('sel-job-text').innerText = char.job_title;
      document.getElementById('sel-account-text').innerText = char.account;
      document.getElementById('sel-zone-text').innerText = `Zone ${char.zone}`;
      document.getElementById('sel-gold-text').innerText = `${char.gold.toLocaleString()} Noah`;
      document.getElementById('sel-cash-text').innerText = `${char.cash.toLocaleString()} KC`;

      const gmBadge = document.getElementById('sel-gm-badge');
      const btnToggleGm = document.getElementById('btn-toggle-gm');
      if (char.is_gm) {
        gmBadge.classList.remove('hidden');
        btnToggleGm.innerHTML = `<i class="fa-solid fa-user-xmark text-red-400 mr-1"></i> Yetkisini Al`;
      } else {
        gmBadge.classList.add('hidden');
        btnToggleGm.innerHTML = `<i class="fa-solid fa-crown text-amber-400 mr-1"></i> GM Yetkisi Ver`;
      }

      const onlineBadge = document.getElementById('sel-online-badge');
      if (char.is_online) {
        onlineBadge.className = "text-[10px] px-2 py-0.5 rounded bg-green-500/10 text-green-400 border border-green-500/30 font-bold flex items-center gap-1";
        onlineBadge.innerHTML = `<span class="w-1.5 h-1.5 rounded-full bg-green-400"></span> Çevrimiçi`;
      } else {
        onlineBadge.className = "text-[10px] px-2 py-0.5 rounded bg-gray-700/50 text-gray-400 font-bold flex items-center gap-1";
        onlineBadge.innerHTML = `<span class="w-1.5 h-1.5 rounded-full bg-gray-500"></span> Çevrimdışı`;
      }

      const nationBadge = document.getElementById('sel-nation-badge');
      if (char.nation === 1 || char.race <= 4) {
        nationBadge.className = "text-[10px] px-2 py-0.5 rounded bg-red-500/10 text-red-400 border border-red-500/30 font-bold";
        nationBadge.innerText = "🔴 Karus";
      } else {
        nationBadge.className = "text-[10px] px-2 py-0.5 rounded bg-blue-500/10 text-blue-400 border border-blue-500/30 font-bold";
        nationBadge.innerText = "🔵 El Morad";
      }

      const punishBadge = document.getElementById('sel-punish-badge');
      const punishBox = document.getElementById('punish-status-box');
      const punishText = document.getElementById('punish-status-text');

      if (char.is_punished) {
        punishBadge.classList.remove('hidden');
        punishBox.className = "bg-amber-950/60 border border-amber-500/80 px-4 py-2 rounded-lg flex items-center gap-3 animate-pulse";
        punishText.className = "text-xs font-black text-amber-300";
        punishText.innerText = `🚨 CEZALI! Kalan: ${char.punish_text} (Sadece oyunda işler)`;
      } else {
        punishBadge.classList.add('hidden');
        punishBox.className = "bg-[#0b0e14] px-4 py-2 rounded-lg border border-gray-700 flex items-center gap-3";
        punishText.className = "text-xs font-bold text-gray-300";
        punishText.innerText = "Temiz (Cezasız)";
      }

      const jobIcons = {
        warrior: 'fa-user-shield',
        rogue: 'fa-user-ninja',
        mage: 'fa-wand-magic-sparkles',
        priest: 'fa-cross',
        kurian: 'fa-dragon'
      };
      document.getElementById('sel-job-icon').className = `fa-solid ${jobIcons[char.job_category] || 'fa-user'}`;
    }

    function setStatusFilter(status) {
      filterStatus = status;
      ['all', 'online', 'offline'].forEach(s => {
        document.getElementById(`filter-status-${s}`).classList.toggle('active', s === status);
      });
      loadCharactersList();
    }

    function setNationFilter(nation) {
      filterNation = nation;
      ['all', 'karus', 'elmorad'].forEach(n => {
        document.getElementById(`filter-nation-${n}`).classList.toggle('active', n === nation);
      });
      loadCharactersList();
    }

    function setJobFilter(job) {
      filterJob = job;
      ['all', 'warrior', 'rogue', 'mage', 'priest', 'kurian'].forEach(j => {
        document.getElementById(`filter-job-${j}`).classList.toggle('active', j === job);
      });
      loadCharactersList();
    }

    function debouncePlayerFilter() {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(loadCharactersList, 250);
    }

    // --- MORADON TOWN PUNISHMENT ---
    function setPunishMinutes(mins) {
      selectedPunishMinutes = mins;
      document.getElementById('input-punish-minutes').value = mins;
      document.getElementById('punish-hours-preview').innerText = (mins / 60).toFixed(1);
      
      document.querySelectorAll('.punish-time-btn').forEach(btn => {
        btn.classList.toggle('active', btn.innerText.includes(`${mins} Dakika`) || btn.innerText.includes(`${mins/60} Saat`));
      });
    }

    document.getElementById('input-punish-minutes').addEventListener('input', (e) => {
      const v = parseInt(e.target.value) || 0;
      selectedPunishMinutes = v;
      document.getElementById('punish-hours-preview').innerText = (v / 60).toFixed(1);
    });

    async function applyPunishment() {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const mins = parseInt(document.getElementById('input-punish-minutes').value) || selectedPunishMinutes;
      if (mins <= 0) return showToast("Geçerli bir ceza süresi girin", true);

      try {
        const res = await fetch('/api/character/punish', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({ character: selectedPlayer.name, duration_minutes: mins })
        });
        const data = await res.json();
        showToast(data.message);
        loadCharactersList();
      } catch (err) {
        showToast("Ceza verilemedi", true);
      }
    }

    async function removePunishment() {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      try {
        const res = await fetch('/api/character/unpunish', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({ character: selectedPlayer.name })
        });
        const data = await res.json();
        showToast(data.message);
        loadCharactersList();
      } catch (err) {
        showToast("Ceza kaldırılamadı", true);
      }
    }

    // --- DISCIPLINE ACTIONS ---
    async function kickSelectedUser() {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const res = await fetch('/api/kick', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ character: selectedPlayer.name })
      });
      const data = await res.json();
      showToast(data.message);
      setTimeout(loadCharactersList, 1500);
    }

    async function banSelectedUser() {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      if (!confirm(`${selectedPlayer.name} hesabını BANLAMAK istediğinize emin misiniz?`)) return;
      const res = await fetch('/api/character/ban', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ character: selectedPlayer.name })
      });
      const data = await res.json();
      showToast(data.message);
      loadCharactersList();
    }

    async function unbanSelectedUser() {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const res = await fetch('/api/character/unban', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ character: selectedPlayer.name })
      });
      const data = await res.json();
      showToast(data.message);
      loadCharactersList();
    }

    async function muteSelectedUser() {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const res = await fetch('/api/character/mute', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ character: selectedPlayer.name })
      });
      const data = await res.json();
      showToast(data.message);
      loadCharactersList();
    }

    async function unmuteSelectedUser() {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const res = await fetch('/api/character/unmute', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ character: selectedPlayer.name })
      });
      const data = await res.json();
      showToast(data.message);
      loadCharactersList();
    }

    async function setAttackDisabled(disable) {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const res = await fetch('/api/character/attack-control', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ character: selectedPlayer.name, disable: disable })
      });
      const data = await res.json();
      showToast(data.message);
    }

    async function teleportUser() {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const val = document.getElementById('tp-destination').value.split('|');
      const res = await fetch('/api/teleport', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
          character: selectedPlayer.name,
          zone: parseInt(val[0]),
          x: parseFloat(val[1]),
          z: parseFloat(val[2])
        })
      });
      const data = await res.json();
      showToast(data.message);
    }

    async function quickGold(amount) {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const res = await fetch('/api/give-gold', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ character: selectedPlayer.name, amount: amount, mode: 'add' })
      });
      const data = await res.json();
      showToast(data.message);
      loadCharactersList();
    }

    async function submitCustomGold() {
      const v = parseInt(document.getElementById('input-custom-gold').value);
      if (v > 0) quickGold(v);
    }

    async function quickKc(amount) {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const res = await fetch('/api/give-kc', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ character: selectedPlayer.name, amount: amount })
      });
      const data = await res.json();
      showToast(data.message);
      loadCharactersList();
    }

    async function submitCustomKc() {
      const v = parseInt(document.getElementById('input-custom-kc').value);
      if (v > 0) quickKc(v);
    }

    async function submitLevel() {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const lvl = parseInt(document.getElementById('input-level-val').value);
      const res = await fetch('/api/set-level', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ character: selectedPlayer.name, level: lvl })
      });
      const data = await res.json();
      showToast(data.message);
      loadCharactersList();
    }

    async function toggleGM() {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const targetAuth = selectedPlayer.is_gm ? 1 : 0;
      const res = await fetch('/api/set-authority', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ character: selectedPlayer.name, authority: targetAuth })
      });
      const data = await res.json();
      showToast(data.message);
      loadCharactersList();
    }

    // --- ITEM CATALOG SEARCH ---
    async function searchItems() {
      const q = document.getElementById('item-search-query').value.trim();
      if (!q) return;
      const container = document.getElementById('item-search-results');
      container.innerHTML = `<div class="col-span-full text-center py-10 text-gray-400">Eşyalar aranıyor...</div>`;

      try {
        const res = await fetch(`/api/items/search?q=${encodeURIComponent(q)}&limit=30`);
        const items = await res.json();
        renderItemResults(items);
      } catch (err) {
        container.innerHTML = `<div class="col-span-full text-center py-10 text-red-400">Arama başarısız.</div>`;
      }
    }

    function quickSearchItem(name) {
      document.getElementById('item-search-query').value = name;
      searchItems();
    }

    function renderItemResults(items) {
      const container = document.getElementById('item-search-results');
      if (!items || items.length === 0) {
        container.innerHTML = `<div class="col-span-full text-center py-10 text-gray-500 text-sm">Sonuç bulunamadı.</div>`;
        return;
      }

      container.innerHTML = items.map(item => {
        const iconHtml = item.icon_url 
          ? `<img src="${item.icon_url}" class="w-10 h-10 object-contain drop-shadow" alt="${item.name}">`
          : `<i class="fa-solid fa-shield-halved text-gray-500 text-xl"></i>`;

        return `
          <div id="item-card-${item.num}" class="bg-[#0b0e15] border border-gray-800 rounded-xl p-3.5 flex flex-col justify-between hover:border-gray-700 transition space-y-3">
            <div class="flex items-start space-x-3">
              <div class="ko-slot">
                ${iconHtml}
              </div>
              <div class="flex-1 min-w-0">
                <h4 class="text-xs font-bold text-amber-300 truncate">${item.name}</h4>
                <div class="text-[10px] text-gray-400 mt-0.5 space-x-2">
                  <span>ID: <b class="text-gray-300 font-mono">${item.num}</b></span>
                  ${item.damage ? `<span>AP: <b class="text-white">${item.damage}</b></span>` : ''}
                  ${item.ac ? `<span>Def: <b class="text-white">${item.ac}</b></span>` : ''}
                  ${item.req_level ? `<span>Lvl: <b class="text-white">${item.req_level}</b></span>` : ''}
                </div>
              </div>
            </div>

            <div id="variants-row-${item.num}" class="flex flex-wrap gap-1 pt-1">
              <button onclick="loadVariantsForCard(${item.num}, '${item.base_name.replace(/'/g, "\\'")}')" class="text-[10px] text-amber-400 hover:text-amber-300 flex items-center gap-1 font-semibold">
                <i class="fa-solid fa-plus-minus"></i> + Seviyelerini Yükle (+1..+10)
              </button>
            </div>

            <div class="flex items-center justify-between pt-2 border-t border-gray-800/80">
              <button onclick="prepareForge(${item.num}, '${item.name.replace(/'/g, "\\'")}', ${item.damage||0}, ${item.ac||0})" class="text-[11px] text-gray-400 hover:text-amber-400 flex items-center gap-1 transition">
                <i class="fa-solid fa-hammer"></i> Edit Forge
              </button>
              <button onclick="giveItemToSelected(${item.num})" class="bg-amber-600 hover:bg-amber-500 text-black font-extrabold px-3 py-1.5 rounded-lg text-xs transition flex items-center gap-1 shadow-sm">
                <i class="fa-solid fa-gift"></i> Çantaya Ver
              </button>
            </div>
          </div>
        `;
      }).join('');
    }

    async function loadVariantsForCard(itemNum, baseName) {
      const container = document.getElementById(`variants-row-${itemNum}`);
      container.innerHTML = `<span class="text-[10px] text-gray-400">+ seviyeleri aranıyor...</span>`;

      try {
        let variants = cachedVariants[baseName];
        if (!variants) {
          const res = await fetch(`/api/items/variants?base_name=${encodeURIComponent(baseName)}`);
          variants = await res.json();
          cachedVariants[baseName] = variants;
        }

        if (!variants || variants.length === 0) {
          container.innerHTML = `<span class="text-[10px] text-gray-500">Bu eşyanın + varyantı yok</span>`;
          return;
        }

        container.innerHTML = variants.map(v => `
          <button onclick="giveItemToSelected(${v.num})" class="grade-pill" title="${v.name} (AP: ${v.damage}, Def: ${v.ac})">
            +${v.grade}
          </button>
        `).join('');
      } catch (err) {
        container.innerHTML = `<span class="text-[10px] text-red-400">Yüklenemedi</span>`;
      }
    }

    async function giveItemToSelected(itemNum) {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const res = await fetch('/api/give-item', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ character: selectedPlayer.name, item_id: itemNum, count: 1 })
      });
      const data = await res.json();
      showToast(data.message);
    }

    function prepareForge(baseId, name, dmg, ac) {
      document.getElementById('forge-preview-name').innerText = name;
      document.getElementById('forge-preview-id').innerText = `ID: ${baseId}`;
      document.getElementById('forge-name').value = `Edit ${name}`;
      document.getElementById('forge-damage').value = dmg > 0 ? (dmg + 25) : 0;
      document.getElementById('forge-ac').value = ac > 0 ? (ac + 20) : 0;
      
      const slot = document.getElementById('forge-preview-slot');
      slot.setAttribute('data-base-id', baseId);
      
      switchPlayerTab('forge');
    }

    async function submitForgeItem() {
      if (!selectedPlayer) return showToast("Lütfen bir oyuncu seçin", true);
      const baseId = parseInt(document.getElementById('forge-preview-slot').getAttribute('data-base-id')) || 111118008;
      
      const payload = {
        character: selectedPlayer.name,
        base_item_id: baseId,
        name: document.getElementById('forge-name').value.trim() || "Özel Edit Eşya",
        damage: parseInt(document.getElementById('forge-damage').value) || 0,
        ac: parseInt(document.getElementById('forge-ac').value) || 0,
        strb: parseInt(document.getElementById('forge-str').value) || 0,
        dexb: parseInt(document.getElementById('forge-dex').value) || 0,
        stab: parseInt(document.getElementById('forge-hp').value) || 0,
        firedamage: parseInt(document.getElementById('forge-fire').value) || 0,
        poisondamage: parseInt(document.getElementById('forge-poison').value) || 0,
        count: 1
      };

      try {
        const res = await fetch('/api/forge-item', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify(payload)
        });
        const data = await res.json();
        showToast(data.message);
      } catch (err) {
        showToast("Edit eşya üretilemedi", true);
      }
    }

    // =========================================================
    // SERVER & EVENT MODE LOGIC
    // =========================================================
    async function loadServerBossPresets() {
      const container = document.getElementById('server-boss-grid');
      try {
        const res = await fetch('/api/bosses/presets');
        const presets = await res.json();

        container.innerHTML = presets.map(b => `
          <div onclick="spawnServerBoss(${b.ssid}, '${b.name}')" class="bg-[#0b0e15] border border-gray-800 hover:border-amber-500/80 rounded-xl p-3 text-center cursor-pointer transition transform hover:-translate-y-0.5 space-y-1.5 shadow-md">
            <div class="w-10 h-10 mx-auto rounded-lg bg-[#141b26] flex items-center justify-center text-amber-400 text-lg">
              <i class="fa-solid fa-${b.icon || 'skull'}"></i>
            </div>
            <div class="text-xs font-bold text-gray-200 truncate">${b.name}</div>
            <div class="text-[10px] text-gray-500 font-mono">SSID: ${b.ssid}</div>
            <button class="w-full bg-amber-600/20 hover:bg-amber-600 hover:text-black text-amber-300 border border-amber-500/30 text-[10px] font-bold py-1 rounded transition">
              Spawn Et
            </button>
          </div>
        `).join('');
      } catch (err) {
        console.error("Presets failed", err);
      }
    }

    async function spawnServerBoss(ssid, name) {
      const zone = parseInt(document.getElementById('server-spawn-zone').value) || 71;
      const count = parseInt(document.getElementById('server-spawn-count').value) || 1;

      try {
        const res = await fetch('/api/bosses/spawn', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({ ssid: ssid, zone: zone, count: count })
        });
        const data = await res.json();
        showToast(`${name} (x${count}) Zone ${zone} bölgesine atıldı!`);
        setTimeout(loadQueueHistory, 1200);
      } catch (err) {
        showToast("Boss atılamadı", true);
      }
    }

    async function searchServerMobs() {
      const q = document.getElementById('server-mob-query').value.trim();
      if (!q) return;
      const container = document.getElementById('server-mob-results');
      container.innerHTML = `<span class="text-xs text-gray-400">Canavarlar aranıyor...</span>`;

      try {
        const res = await fetch(`/api/bosses/search?q=${encodeURIComponent(q)}`);
        const mobs = await res.json();
        if (!mobs || mobs.length === 0) {
          container.innerHTML = `<span class="text-xs text-gray-500">Canavar bulunamadı.</span>`;
          return;
        }

        container.innerHTML = mobs.map(m => `
          <div onclick="spawnServerBoss(${m.ssid}, '${m.name}')" class="bg-[#0b0e15] border border-gray-800 hover:border-amber-500 rounded p-2 text-xs flex justify-between items-center cursor-pointer transition">
            <div>
              <b class="text-amber-300">${m.name}</b>
              <div class="text-[10px] text-gray-500">SSID: ${m.ssid} • Lvl ${m.level}</div>
            </div>
            <span class="text-[10px] bg-amber-600 text-black font-bold px-2 py-0.5 rounded">At</span>
          </div>
        `).join('');
      } catch (err) {
        container.innerHTML = `<span class="text-xs text-red-400">Hata oluştu.</span>`;
      }
    }

    async function killAllMobsInZone() {
      const zone = parseInt(document.getElementById('server-spawn-zone').value) || 21;
      if (!confirm(`Zone ${zone} bölgesindeki TÜM canavarları temizlemek istiyor musunuz?`)) return;

      const res = await fetch('/api/bosses/kill-all', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ zone: zone })
      });
      const data = await res.json();
      showToast(data.message);
      setTimeout(loadQueueHistory, 1200);
    }

    async function triggerWar(warType, action) {
      try {
        const res = await fetch('/api/server/war', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({ war_type: warType, action: action })
        });
        const data = await res.json();
        showToast(data.message);
        setTimeout(loadQueueHistory, 1200);
      } catch (err) {
        showToast("Savaş işlemi başarısız", true);
      }
    }

    async function setEventBonus(type, percent) {
      try {
        const res = await fetch('/api/server/bonus', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({ bonus_type: type, percent: percent })
        });
        const data = await res.json();
        showToast(data.message);
        setTimeout(loadQueueHistory, 1200);
      } catch (err) {
        showToast("Bonus uygulanamadı", true);
      }
    }

    async function sendServerNotice() {
      const msg = document.getElementById('server-notice-text').value.trim();
      if (!msg) return showToast("Duyuru metni yazın", true);
      const ntype = document.querySelector('input[name="server_notice_type"]:checked').value;

      try {
        const res = await fetch('/api/send-notice', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({ message: msg, notice_type: ntype })
        });
        const data = await res.json();
        showToast(data.message);
        document.getElementById('server-notice-text').value = '';
        setTimeout(loadQueueHistory, 1200);
      } catch (err) {
        showToast("Duyuru iletilemedi", true);
      }
    }

    async function loadQueueHistory() {
      try {
        const res = await fetch('/api/queue-history');
        const list = await res.json();
        const tbody = document.getElementById('history-tbody');
        if (!list || list.length === 0) {
          tbody.innerHTML = `<tr><td colspan="5" class="p-3 text-center text-gray-500">Henüz kuyrukta komut yok.</td></tr>`;
          return;
        }

        tbody.innerHTML = list.map(item => {
          let statusBadge = `<span class="px-1.5 py-0.5 rounded text-[10px] font-bold bg-amber-500/20 text-amber-300">Bekliyor</span>`;
          if (item.status === 1) statusBadge = `<span class="px-1.5 py-0.5 rounded text-[10px] font-bold bg-green-500/20 text-green-300">İşlendi</span>`;
          else if (item.status === 2) statusBadge = `<span class="px-1.5 py-0.5 rounded text-[10px] font-bold bg-red-500/20 text-red-300">Hata</span>`;

          return `
            <tr class="hover:bg-[#151c27]">
              <td class="p-2 font-mono text-gray-400">#${item.id}</td>
              <td class="p-2 font-bold text-amber-300">${item.command}</td>
              <td class="p-2 text-gray-300 font-mono">${item.param1 || '-'} ${item.param2 ? `| ${item.param2}` : ''}</td>
              <td class="p-2">${statusBadge}</td>
              <td class="p-2 text-gray-400 truncate max-w-xs">${item.result_msg || '-'}</td>
            </tr>
          `;
        }).join('');
      } catch (err) {
        console.error("Queue history failed", err);
      }
    }

    // =========================================================
    // VIEW 3: YARATIK, DROP & SPAWN EDİTÖRÜ MANTIĞI
    // =========================================================
    async function loadMobsList(offset = 0) {
      mobOffset = offset;
      const q = document.getElementById('mob-search-input').value.trim();
      const zone = parseInt(document.getElementById('mob-zone-filter').value) || 0;
      const container = document.getElementById('mobs-list-container');
      container.innerHTML = `<div class="text-xs text-center text-gray-500 py-10">Canavarlar yükleniyor...</div>`;

      try {
        const url = `/api/mobs?q=${encodeURIComponent(q)}&zone=${zone}&has_drops=${mobFilterDrop}&is_boss=${mobFilterCategory}&limit=${mobLimit}&offset=${mobOffset}`;
        const res = await fetch(url);
        const data = await res.json();

        mobTotal = data.total;
        mobsList = data.mobs || [];
        document.getElementById('mob-total-badge').innerText = mobTotal;

        const totalPages = Math.max(1, Math.ceil(mobTotal / mobLimit));
        const curPage = Math.floor(mobOffset / mobLimit) + 1;
        document.getElementById('mob-page-text').innerText = `${curPage} / ${totalPages}`;
        document.getElementById('btn-mob-prev').disabled = (mobOffset === 0);
        document.getElementById('btn-mob-next').disabled = (curPage >= totalPages);

        renderMobsList(mobsList);

        if (!selectedMob && mobsList.length > 0) {
          selectMob(mobsList[0]);
        } else if (selectedMob) {
          const fresh = mobsList.find(m => m.ssid === selectedMob.ssid);
          if (fresh) selectMob(fresh);
        }
      } catch (err) {
        container.innerHTML = `<div class="text-xs text-center text-red-400 py-10">Yüklenemedi.</div>`;
      }
    }

    function renderMobsList(mobs) {
      const container = document.getElementById('mobs-list-container');
      if (!mobs || mobs.length === 0) {
        container.innerHTML = `<div class="text-xs text-center text-gray-500 py-10">Canavar bulunamadı.</div>`;
        return;
      }

      container.innerHTML = mobs.map(m => {
        const isSel = selectedMob && selectedMob.ssid === m.ssid;
        let badgeHtml = '';
        if (m.is_boss) badgeHtml += `<span class="text-[9px] bg-amber-500 text-black font-extrabold px-1.5 py-0.2 rounded">BOSS</span>`;
        if (m.drop_count > 0) badgeHtml += `<span class="text-[9px] bg-green-500/20 text-green-300 border border-green-500/30 px-1 py-0.2 rounded font-bold">${m.drop_count} Drop</span>`;
        if (m.spawn_count > 0) badgeHtml += `<span class="text-[9px] bg-blue-500/20 text-blue-300 border border-blue-500/30 px-1 py-0.2 rounded font-bold">${m.spawn_count} Spawn</span>`;

        return `
          <div onclick="selectMobBySsid(${m.ssid})" class="mob-card ${isSel ? 'active' : ''} p-3 rounded-xl border border-[#20293b] bg-[#121722] hover:bg-[#171f2e] cursor-pointer transition flex items-center justify-between">
            <div class="flex items-center space-x-3">
              <div class="w-9 h-9 rounded-lg bg-[#1a2333] border border-gray-700/60 flex items-center justify-center text-red-400 text-base">
                <i class="fa-solid fa-${m.is_boss ? 'dragon' : 'paw'}"></i>
              </div>
              <div>
                <div class="flex items-center gap-1.5">
                  <span class="text-xs font-bold ${isSel ? 'text-amber-400' : 'text-gray-200'}">${m.name}</span>
                  ${badgeHtml}
                </div>
                <div class="text-[10px] text-gray-400 mt-0.5">
                  Lvl ${m.level} • HP: ${m.hp.toLocaleString()} • SSID: ${m.ssid}
                </div>
              </div>
            </div>
            <i class="fa-solid fa-chevron-right text-gray-600 text-xs"></i>
          </div>
        `;
      }).join('');
    }

    function selectMobBySsid(ssid) {
      const mob = mobsList.find(m => m.ssid === ssid) || { ssid: ssid };
      selectMob(mob);
    }

    async function selectMob(mob) {
      selectedMob = mob;
      renderMobsList(mobsList);

      try {
        const res = await fetch(`/api/mobs/${mob.ssid}`);
        const data = await res.json();
        const m = data.mob;

        document.getElementById('mob-detail-name').innerText = m.name;
        document.getElementById('mob-detail-ssid').innerText = `SSID: ${m.ssid}`;
        document.getElementById('mob-detail-level').innerText = m.level;
        document.getElementById('mob-detail-hp').innerText = m.hp.toLocaleString();
        document.getElementById('mob-detail-atk').innerText = m.atk.toLocaleString();
        document.getElementById('mob-detail-ac').innerText = m.ac.toLocaleString();
        document.getElementById('mob-detail-exp').innerText = m.exp.toLocaleString();
        document.getElementById('mob-detail-np').innerText = m.loyalty.toLocaleString();

        const bossBadge = document.getElementById('mob-detail-boss-badge');
        bossBadge.classList.toggle('hidden', m.level < 70 && !m.is_boss);

        currentMobDrops = data.drops || [];
        renderMobDrops(currentMobDrops);

        renderMobSpawns(data.spawns || []);
      } catch (err) {
        console.error("Mob detail load failed", err);
      }
    }

    function renderMobDrops(drops) {
      const container = document.getElementById('mob-drops-grid');
      container.innerHTML = drops.map(d => {
        const hasItem = d.item_id > 0;
        const iconHtml = d.icon_url 
          ? `<img src="${d.icon_url}" class="w-9 h-9 object-contain drop-shadow" alt="${d.item_name}">`
          : (hasItem ? `<i class="fa-solid fa-cube text-amber-400 text-lg"></i>` : `<i class="fa-solid fa-plus text-gray-600 text-base"></i>`);

        return `
          <div class="bg-[#0b0e15] border border-gray-800 rounded-xl p-3 flex flex-col justify-between space-y-2.5">
            <div class="flex items-center justify-between">
              <span class="text-[10px] font-bold uppercase text-gray-500">Slot ${d.slot}</span>
              ${hasItem ? `<button onclick="clearDropSlot(${d.slot})" class="text-[10px] text-red-400 hover:text-red-300" title="Slotu Temizle"><i class="fa-solid fa-trash"></i></button>` : ''}
            </div>

            <div class="flex flex-col items-center text-center space-y-1.5">
              <div onclick="openItemPicker(${d.slot})" class="ko-slot cursor-pointer" title="Eşya Seç / Değiştir">
                ${iconHtml}
              </div>
              <div class="w-full">
                <div class="text-xs font-bold ${hasItem ? 'text-amber-300' : 'text-gray-500'} truncate" title="${d.item_name}">
                  ${d.item_name}
                </div>
                <div class="text-[10px] text-gray-500 font-mono">
                  ${hasItem ? `ID: ${d.item_id}` : 'Boş'}
                </div>
              </div>
            </div>

            <div class="space-y-1 pt-1 border-t border-gray-800">
              <label class="block text-[10px] text-gray-400 font-semibold">Drop Oranı (%):</label>
              <div class="relative">
                <input type="number" id="drop-percent-input-${d.slot}" step="0.01" min="0" max="100" value="${d.percent_float}" class="w-full bg-[#121822] border border-gray-700 rounded px-2 py-1 text-xs text-white font-bold text-center">
                <span class="absolute right-2 top-1 text-[11px] text-gray-500 font-bold">%</span>
              </div>
              <button onclick="openItemPicker(${d.slot})" class="w-full mt-1 bg-[#151d2a] hover:bg-amber-600/20 text-gray-300 hover:text-amber-300 text-[10px] py-1 rounded transition font-semibold">
                ${hasItem ? 'Eşyayı Değiştir' : '+ Eşya Ekle'}
              </button>
            </div>
          </div>
        `;
      }).join('');
    }

    function renderMobSpawns(spawns) {
      const tbody = document.getElementById('mob-spawns-tbody');
      if (!spawns || spawns.length === 0) {
        tbody.innerHTML = `<tr><td colspan="5" class="p-4 text-center text-gray-500">Bu canavar için tanımlı otomatik spawn noktası bulunamadı. Aşağıdan yeni spawn noktası ekleyebilirsiniz.</td></tr>`;
        return;
      }

      tbody.innerHTML = spawns.map((s, idx) => `
        <tr class="hover:bg-[#151c27]">
          <td class="p-3">
            <span class="font-bold text-amber-300">${s.zone_name}</span>
            <div class="text-[10px] text-gray-500">Zone ID: ${s.zone_id} • ActType: ${s.act_type}</div>
          </td>
          <td class="p-3">
            <input type="number" id="spawn-num-${idx}" value="${s.num_npc}" min="1" max="50" class="w-16 bg-[#0a0d14] border border-gray-700 rounded px-2 py-1 text-xs text-center font-bold text-white">
          </td>
          <td class="p-3">
            <div class="flex items-center gap-1.5">
              <input type="number" id="spawn-reg-${idx}" value="${s.reg_time}" min="5" max="86400" class="w-20 bg-[#0a0d14] border border-gray-700 rounded px-2 py-1 text-xs text-center font-mono font-bold text-white">
              <span class="text-gray-400 text-xs">sn (${(s.reg_time/60).toFixed(1)} dk)</span>
            </div>
          </td>
          <td class="p-3 font-mono text-gray-300">
            X: ${s.left_x}, Z: ${s.top_z}
          </td>
          <td class="p-3 text-right space-x-1.5">
            <button onclick="saveSpawnPoint(${idx}, ${s.zone_id}, ${s.left_x}, ${s.top_z})" class="bg-blue-600 hover:bg-blue-500 text-white font-bold px-3 py-1 rounded text-xs transition">
              Kaydet
            </button>
            <button onclick="deleteSpawnPoint(${s.zone_id}, ${s.left_x}, ${s.top_z})" class="bg-red-950 hover:bg-red-800 text-red-300 border border-red-700/50 font-bold px-2.5 py-1 rounded text-xs transition" title="Sil">
              <i class="fa-solid fa-trash"></i>
            </button>
          </td>
        </tr>
      `).join('');
    }

    // --- DROP MODAL & SELECTION ---
    function openItemPicker(slot) {
      activePickerSlot = slot;
      document.getElementById('picker-slot-title').innerText = `Slot ${slot}`;
      document.getElementById('item-picker-modal').classList.remove('hidden');
      document.getElementById('picker-search-input').focus();
    }

    function closeItemPicker() {
      document.getElementById('item-picker-modal').classList.add('hidden');
    }

    async function searchPickerItems() {
      const q = document.getElementById('picker-search-input').value.trim();
      if (!q) return;
      const container = document.getElementById('picker-results-container');
      container.innerHTML = `<div class="col-span-full text-center py-6 text-gray-400">Eşyalar aranıyor...</div>`;

      try {
        const res = await fetch(`/api/items/search?q=${encodeURIComponent(q)}&limit=24`);
        const items = await res.json();
        if (!items || items.length === 0) {
          container.innerHTML = `<div class="col-span-full text-center py-6 text-gray-500">Eşya bulunamadı.</div>`;
          return;
        }

        container.innerHTML = items.map(item => `
          <div onclick="selectPickerItem(${item.num}, '${item.name.replace(/'/g, "\\'")}', '${item.icon_url || ''}')" class="bg-[#0b0e15] border border-gray-800 hover:border-amber-500 rounded-lg p-2.5 flex items-center justify-between cursor-pointer transition">
            <div class="flex items-center space-x-2.5">
              <div class="ko-slot w-10 h-10">
                ${item.icon_url ? `<img src="${item.icon_url}" class="w-8 h-8 object-contain">` : `<i class="fa-solid fa-shield-halved text-gray-500"></i>`}
              </div>
              <div>
                <div class="text-xs font-bold text-gray-200 truncate max-w-xs">${item.name}</div>
                <div class="text-[10px] text-gray-500 font-mono">ID: ${item.num}</div>
              </div>
            </div>
            <button class="bg-amber-600 hover:bg-amber-500 text-black font-extrabold text-[10px] px-2.5 py-1 rounded">
              Seç
            </button>
          </div>
        `).join('');
      } catch (err) {
        container.innerHTML = `<div class="col-span-full text-center py-6 text-red-400">Arama başarısız.</div>`;
      }
    }

    function quickPickerSearch(name) {
      document.getElementById('picker-search-input').value = name;
      searchPickerItems();
    }

    function selectPickerItem(itemId, name, iconUrl) {
      const slotObj = currentMobDrops.find(d => d.slot === activePickerSlot);
      if (slotObj) {
        slotObj.item_id = itemId;
        slotObj.item_name = name;
        slotObj.icon_url = iconUrl;
        if (slotObj.percent_float === 0) slotObj.percent_float = 5.0; // default 5%
      }
      renderMobDrops(currentMobDrops);
      closeItemPicker();
      showToast(`Slot ${activePickerSlot} için '${name}' seçildi.`);
    }

    function clearDropSlot(slot) {
      const slotObj = currentMobDrops.find(d => d.slot === slot);
      if (slotObj) {
        slotObj.item_id = 0;
        slotObj.item_name = "Boş Slot";
        slotObj.icon_url = null;
        slotObj.percent_float = 0.0;
        slotObj.percent_raw = 0;
      }
      renderMobDrops(currentMobDrops);
    }

    async function saveMobDrops() {
      if (!selectedMob) return showToast("Lütfen bir canavar seçin", true);

      // Read current input values
      const dropsPayload = currentMobDrops.map(d => {
        const input = document.getElementById(`drop-percent-input-${d.slot}`);
        const percent = input ? parseFloat(input.value) || 0.0 : d.percent_float;
        return {
          slot: d.slot,
          item_id: d.item_id,
          percent: percent
        };
      });

      try {
        const res = await fetch(`/api/mobs/${selectedMob.ssid}/drops`, {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({ drops: dropsPayload })
        });
        const data = await res.json();
        showToast(data.message);
        selectMob(selectedMob);
      } catch (err) {
        showToast("Drop oranları kaydedilemedi", true);
      }
    }

    // --- SPAWN MANAGEMENT ---
    async function saveSpawnPoint(idx, zoneId, leftX, topZ) {
      if (!selectedMob) return;
      const numNpc = parseInt(document.getElementById(`spawn-num-${idx}`).value) || 1;
      const regTime = parseInt(document.getElementById(`spawn-reg-${idx}`).value) || 60;

      try {
        const res = await fetch(`/api/mobs/${selectedMob.ssid}/spawn/update`, {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({
            zone_id: zoneId,
            left_x: leftX,
            top_z: topZ,
            num_npc: numNpc,
            reg_time: regTime
          })
        });
        const data = await res.json();
        showToast(data.message);
        selectMob(selectedMob);
      } catch (err) {
        showToast("Spawn güncellenemedi", true);
      }
    }

    async function addNewSpawnPoint() {
      if (!selectedMob) return showToast("Lütfen bir canavar seçin", true);
      const zone = parseInt(document.getElementById('new-spawn-zone').value);
      const count = parseInt(document.getElementById('new-spawn-count').value) || 1;
      const time = parseInt(document.getElementById('new-spawn-time').value) || 60;
      const x = parseInt(document.getElementById('new-spawn-x').value) || 1024;
      const z = parseInt(document.getElementById('new-spawn-z').value) || 1024;

      try {
        const res = await fetch(`/api/mobs/${selectedMob.ssid}/spawn/add`, {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({
            zone_id: zone,
            num_npc: count,
            reg_time: time,
            x: x,
            z: z
          })
        });
        const data = await res.json();
        showToast(data.message);
        selectMob(selectedMob);
      } catch (err) {
        showToast("Spawn eklenemedi", true);
      }
    }

    async function deleteSpawnPoint(zoneId, leftX, topZ) {
      if (!selectedMob) return;
      if (!confirm("Bu spawn noktasını silmek istediğinize emin misiniz?")) return;

      try {
        const res = await fetch(`/api/mobs/${selectedMob.ssid}/spawn/delete`, {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({
            zone_id: zoneId,
            left_x: leftX,
            top_z: topZ
          })
        });
        const data = await res.json();
        showToast(data.message);
        selectMob(selectedMob);
      } catch (err) {
        showToast("Spawn silinemedi", true);
      }
    }

    async function testSpawnSelectedMob() {
      if (!selectedMob) return showToast("Lütfen bir canavar seçin", true);
      spawnServerBoss(selectedMob.ssid, selectedMob.name);
    }

    // --- MOB FILTERS & PAGINATION ---
    function setMobCategoryFilter(cat) {
      mobFilterCategory = cat;
      ['all', 'boss', 'normal'].forEach(c => {
        document.getElementById(`filter-mobcat-${c}`).classList.toggle('active', c === cat);
      });
      loadMobsList(0);
    }

    function setMobDropFilter(drop) {
      mobFilterDrop = drop;
      ['all', 'yes', 'no'].forEach(d => {
        document.getElementById(`filter-mobdrop-${d}`).classList.toggle('active', d === drop);
      });
      loadMobsList(0);
    }

    function quickFilterMobName(name) {
      document.getElementById('mob-search-input').value = name;
      loadMobsList(0);
    }

    function debounceMobFilter() {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(() => {
        loadMobsList(0);
      }, 300);
    }

    function changeMobPage(dir) {
      const nextOffset = mobOffset + (dir * mobLimit);
      if (nextOffset >= 0 && nextOffset < mobTotal) {
        loadMobsList(nextOffset);
      }
    }

    // --- REFRESH ALL ---
    function refreshData() {
      loadStatus();
      loadCharactersList();
      if (currentMainMode === 'server') {
        loadQueueHistory();
      } else if (currentMainMode === 'mobs') {
        loadMobsList(mobOffset);
      }
      showToast("Veriler güncellendi");
    }

    setInterval(() => {
      loadStatus();
      if (currentMainMode === 'players') {
        fetch(`/api/characters/search?q=&status=all&nation=all&job=all&limit=200`)
          .then(r => r.json())
          .then(data => {
            document.getElementById('count-status-online').innerText = data.online_count;
            document.getElementById('count-status-offline').innerText = data.offline_count;
          }).catch(()=>{});
      }
    }, 4000);

    window.addEventListener('DOMContentLoaded', () => {
      loadStatus();
      loadCharactersList();
    });
  </script>
</body>
</html>
''')
print("Successfully wrote full index.html with Mob, Drop, and Spawn Studio!")
