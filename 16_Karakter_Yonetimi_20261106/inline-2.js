
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

    // --- MAIN MODE SWITCHER ---
    function setMainMode(mode) {
      currentMainMode = mode;
      document.getElementById('nav-mode-players')?.classList.toggle('active', mode === 'players');
      document.getElementById('nav-mode-server')?.classList.toggle('active', mode === 'server');
      document.getElementById('nav-mode-mobs')?.classList.toggle('active', mode === 'mobs');
      document.getElementById('nav-mode-chests')?.classList.toggle('active', mode === 'chests');
      
      document.getElementById('view-players-mode')?.classList.toggle('hidden', mode !== 'players');
      document.getElementById('view-server-mode')?.classList.toggle('hidden', mode !== 'server');
      document.getElementById('view-mobs-mode')?.classList.toggle('hidden', mode !== 'mobs');
      document.getElementById('view-chests-mode')?.classList.toggle('hidden', mode !== 'chests');

      if (mode === 'server') {
        loadServerBossPresets();
        loadQueueHistory();
      } else if (mode === 'mobs') {
        loadMobsList();
      } else if (mode === 'chests') {
        loadChestsList();
        loadUpgradeRates();
      }
    }

    // --- PLAYER TAB SWITCHER ---
    function switchPlayerTab(tab) {
      currentPlayerTab = tab;
      const tabs = ['discipline', 'items', 'forge', 'economy', 'character'];
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
      if (tab === 'character' && window.loadCharacterEditor) window.loadCharacterEditor();
      if (tab === 'items') {
        const resCont = document.getElementById('item-search-results');
        if (!resCont || resCont.children.length === 0) {
          doCatalogSearch(1);
        }
      }
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

      // GM Badge & Toggle button
      const gmBadge = document.getElementById('sel-gm-badge');
      const btnToggleGm = document.getElementById('btn-toggle-gm');
      if (char.is_gm) {
        gmBadge.classList.remove('hidden');
        btnToggleGm.innerHTML = `<i class="fa-solid fa-user-xmark text-red-400 mr-1"></i> Yetkisini Al (Oyuncu Yap)`;
      } else {
        gmBadge.classList.add('hidden');
        btnToggleGm.innerHTML = `<i class="fa-solid fa-crown text-amber-400 mr-1"></i> GM Yetkisi Ver`;
      }

      // Online Badge
      const onlineBadge = document.getElementById('sel-online-badge');
      if (char.is_online) {
        onlineBadge.className = "text-[10px] px-2 py-0.5 rounded bg-green-500/10 text-green-400 border border-green-500/30 font-bold flex items-center gap-1";
        onlineBadge.innerHTML = `<span class="w-1.5 h-1.5 rounded-full bg-green-400"></span> Çevrimiçi`;
      } else {
        onlineBadge.className = "text-[10px] px-2 py-0.5 rounded bg-gray-700/50 text-gray-400 font-bold flex items-center gap-1";
        onlineBadge.innerHTML = `<span class="w-1.5 h-1.5 rounded-full bg-gray-500"></span> Çevrimdışı`;
      }

      // Nation Badge
      const nationBadge = document.getElementById('sel-nation-badge');
      if (char.nation === 1 || char.race <= 4) {
        nationBadge.className = "text-[10px] px-2 py-0.5 rounded bg-red-500/10 text-red-400 border border-red-500/30 font-bold";
        nationBadge.innerText = "🔴 Karus";
      } else {
        nationBadge.className = "text-[10px] px-2 py-0.5 rounded bg-blue-500/10 text-blue-400 border border-blue-500/30 font-bold";
        nationBadge.innerText = "🔵 El Morad";
      }

      // Punish Badge & Status Box
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

      // Avatar Icon
      const jobIcons = {
        warrior: 'fa-user-shield',
        rogue: 'fa-user-ninja',
        mage: 'fa-wand-magic-sparkles',
        priest: 'fa-cross',
        kurian: 'fa-dragon'
      };
      document.getElementById('sel-job-icon').className = `fa-solid ${jobIcons[char.job_category] || 'fa-user'}`;
      if (currentPlayerTab === 'character' && window.loadCharacterEditor) window.loadCharacterEditor();
    }

    // --- SIDEBAR FILTERS ---
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
      debounceTimer = setTimeout(() => {
        loadCharactersList();
      }, 250);
    }

    // --- MORADON TOWN PUNISHMENT SYSTEM ---
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
      if (!selectedPlayer) return showToast("Lütfen önce bir oyuncu seçin", true);
      const mins = parseInt(document.getElementById('input-punish-minutes').value) || selectedPunishMinutes;
      if (mins <= 0) return showToast("Geçerli bir ceza süresi girin", true);

      try {
        const res = await fetch('/api/character/punish', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({
            character: selectedPlayer.name,
            duration_minutes: mins
          })
        });
        const data = await res.json();
        showToast(data.message);
        loadCharactersList();
      } catch (err) {
        showToast("Ceza verilemedi", true);
      }
    }

    async function removePunishment() {
      if (!selectedPlayer) return showToast("Lütfen önce bir oyuncu seçin", true);
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

    // --- QUICK GOLD, KC, LEVEL, GM ---
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
        switchPlayerTab('character');
        await window.loadCharacterEditor(true);
        const field = document.getElementById('ce-level');
        if (field && !document.getElementById('character-editor-fields').disabled && lvl >= 1 && lvl <= 83) {
          field.value = lvl;
          field.dispatchEvent(new Event('input', {bubbles:true}));
          field.dispatchEvent(new Event('change', {bubbles:true}));
          showToast('Hedef seviye aktarıldı. Diğer değerleri kontrol edip karakter değişikliklerini kaydedin.');
        }
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

    // --- ADVANCED ITEM CATALOG & FORGE ENGINE ---
    let currentCatalogCategory = 'all';
    let currentCatalogSubCategory = 'all';
    let currentCatalogPage = 1;
    let totalCatalogPages = 1;
    let forgeSearchTimer = null;
    let selectedCardActiveItem = {};

    const catalogSubCategories = {
      all: [],
      weapon: [
        { id: 'all', label: '⚔️ Tüm Silahlar' },
        { id: 'dagger', label: '🗡️ Hançer (Dagger)' },
        { id: 'sword', label: '⚔️ Kılıç (1H / 2H)' },
        { id: 'axe', label: '🪓 Balta (Axe)' },
        { id: 'mace', label: '🔨 Gürz (Club/Mace)' },
        { id: 'spear', label: '🔱 Mızrak (Spear)' },
        { id: 'bow', label: '🏹 Yay (Bow)' },
        { id: 'staff', label: '🔮 Asa (Staff)' },
        { id: 'jamadar', label: '🗡️ Jamadar' },
        { id: 'shield', label: '🛡️ Kalkan (Shield)' }
      ],
      armor: [
        { id: 'all', label: '🛡️ Tüm Zırhlar' },
        { id: 'warrior_armor', label: 'Warrior Zırhları' },
        { id: 'rogue_armor', label: 'Rogue Zırhları' },
        { id: 'mage_armor', label: 'Mage Zırhları' },
        { id: 'priest_armor', label: 'Priest Zırhları' },
        { id: 'kurian_armor', label: 'Kurian Zırhları' }
      ],
      accessory: [
        { id: 'all', label: '💍 Tüm Takılar' },
        { id: 'ring', label: '💍 Yüzük' },
        { id: 'necklace', label: '📿 Kolye' },
        { id: 'belt', label: '🎗️ Kemer' },
        { id: 'earring', label: '💎 Küpe' }
      ],
      scroll: [
        { id: 'all', label: '📜 Tüm Kağıtlar' },
        { id: 'scroll', label: 'Upgrade & Scroller' }
      ],
      box: [
        { id: 'all', label: '📦 Tüm Kutular & Gemler' }
      ]
    };

    function escapeHtml(str) {
      if (!str) return '';
      return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
    }

    function escapeJs(str) {
      if (!str) return '';
      return String(str).replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/"/g, '\\"');
    }

    function setCatalogCategory(cat) {
      currentCatalogCategory = cat;
      currentCatalogSubCategory = 'all';

      // Update Category Buttons
      document.querySelectorAll('.catalog-cat-btn').forEach(btn => btn.classList.remove('active'));
      const activeBtn = document.getElementById(`cat-btn-${cat}`);
      if (activeBtn) activeBtn.classList.add('active');

      // Update Subcategory Row
      const subWrap = document.getElementById('catalog-subcat-wrapper');
      const list = catalogSubCategories[cat] || [];
      if (list.length > 0) {
        subWrap.classList.remove('hidden');
        subWrap.innerHTML = list.map(s => `
          <button type="button" onclick="setCatalogSubCategory('${s.id}')" id="subcat-btn-${s.id}" class="catalog-subcat-btn ${s.id === 'all' ? 'active' : ''}">
            ${s.label}
          </button>
        `).join('');
      } else {
        subWrap.classList.add('hidden');
        subWrap.innerHTML = '';
      }

      doCatalogSearch(1);
    }

    function setCatalogSubCategory(subCat) {
      currentCatalogSubCategory = subCat;
      document.querySelectorAll('.catalog-subcat-btn').forEach(btn => btn.classList.remove('active'));
      const activeBtn = document.getElementById(`subcat-btn-${subCat}`);
      if (activeBtn) activeBtn.classList.add('active');
      doCatalogSearch(1);
    }

    function quickSearchItem(name) {
      document.getElementById('item-search-query').value = name;
      doCatalogSearch(1);
    }

    async function doCatalogSearch(page = 1) {
      currentCatalogPage = page;
      const q = (document.getElementById('item-search-query')?.value || '').trim();
      const sort = document.getElementById('item-catalog-sort')?.value || 'default';
      const baseOnly = document.getElementById('item-base-only')?.checked ? 'true' : 'false';

      const container = document.getElementById('item-search-results');
      container.innerHTML = `<div class="col-span-full text-center py-12 text-gray-400">
        <i class="fa-solid fa-spinner fa-spin text-2xl text-amber-500 mb-2 block"></i>
        Eşyalar getiriliyor...
      </div>`;

      try {
        const url = `/api/items/search?q=${encodeURIComponent(q)}&category=${currentCatalogCategory}&sub_category=${currentCatalogSubCategory}&sort=${sort}&base_only=${baseOnly}&page=${page}&limit=30`;
        const res = await fetch(url);
        const data = await res.json();

        const items = Array.isArray(data) ? data : (data.items || []);
        totalCatalogPages = data.total_pages || 1;
        const totalCount = data.total || items.length;

        // Update Total Indicator
        const totalIndicator = document.getElementById('catalog-total-indicator');
        if (totalIndicator) totalIndicator.innerText = `Toplam: ${totalCount.toLocaleString()} Eşya`;

        // Update Pager
        const pageCur = document.getElementById('pager-current-page');
        const pageTot = document.getElementById('pager-total-pages');
        const pageInfo = document.getElementById('pager-page-info');
        if (pageCur) pageCur.innerText = currentCatalogPage;
        if (pageTot) pageTot.innerText = totalCatalogPages;
        if (pageInfo) pageInfo.innerText = `${currentCatalogPage} / ${totalCatalogPages}`;

        const btnPrev = document.getElementById('btn-page-prev');
        const btnNext = document.getElementById('btn-page-next');
        const btnFirst = document.getElementById('btn-page-first');
        const btnLast = document.getElementById('btn-page-last');

        if (btnPrev) btnPrev.disabled = currentCatalogPage <= 1;
        if (btnFirst) btnFirst.disabled = currentCatalogPage <= 1;
        if (btnNext) btnNext.disabled = currentCatalogPage >= totalCatalogPages;
        if (btnLast) btnLast.disabled = currentCatalogPage >= totalCatalogPages;

        renderItemResults(items);

      } catch (err) {
        container.innerHTML = `<div class="col-span-full text-center py-12 text-red-400">Eşyalar listelenirken bir hata oluştu.</div>`;
      }
    }

    function changeCatalogPage(page) {
      if (page < 1 || page > totalCatalogPages) return;
      doCatalogSearch(page);
    }

    function renderItemResults(items) {
      const container = document.getElementById('item-search-results');
      if (!items || items.length === 0) {
        container.innerHTML = `<div class="col-span-full text-center py-12 text-gray-500 text-sm">
          <i class="fa-solid fa-circle-exclamation text-2xl mb-2 text-gray-600 block"></i>
          Bu filtreye uygun hiçbir eşya bulunamadı.
        </div>`;
        return;
      }

      container.innerHTML = items.map(item => {
        selectedCardActiveItem[item.num] = {
          num: item.num,
          name: item.name,
          damage: item.damage || 0,
          ac: item.ac || 0,
          grade: item.grade || 0,
          icon_url: item.icon_url
        };

        const safeName = escapeHtml(item.name);
        const jsName = escapeJs(item.name);
        const jsBaseName = escapeJs(item.base_name);
        const jsIcon = escapeJs(item.icon_url || '');

        const imgBlock = item.icon_url ? `
          <img src="${item.icon_url}" class="w-10 h-10 object-contain drop-shadow" alt="${safeName}" onerror="this.style.display='none'; var f=document.getElementById('fallback-icon-${item.num}'); if(f) f.style.display='flex';">
          <div id="fallback-icon-${item.num}" class="w-10 h-10 items-center justify-center text-amber-500/70 text-xl hidden">
            <i class="fa-solid fa-shield-halved"></i>
          </div>
        ` : `
          <div class="w-10 h-10 flex items-center justify-center text-amber-500/70 text-xl">
            <i class="fa-solid fa-shield-halved"></i>
          </div>
        `;

        return `
          <div id="item-card-${item.num}" class="bg-[#0f1420] border border-[#212c3f] hover:border-amber-500/50 rounded-xl p-4 flex flex-col justify-between transition-all shadow-lg space-y-3">
            
            <!-- Top: Slot + Title + Attributes -->
            <div class="flex items-start space-x-3.5">
              <div class="ko-slot flex-shrink-0 flex items-center justify-center">
                ${imgBlock}
              </div>
              <div class="flex-1 min-w-0">
                <div class="flex items-center justify-between gap-2">
                  <h4 id="card-title-${item.num}" class="text-sm font-black text-amber-300 truncate" title="${safeName}">
                    ${safeName}
                  </h4>
                  <span class="text-[10px] font-mono text-gray-400 bg-[#161d2b] px-2 py-0.5 rounded border border-gray-700/60 flex-shrink-0">
                    ID: <b id="card-id-${item.num}" class="text-amber-400 font-bold">${item.num}</b>
                  </span>
                </div>

                <!-- Attributes Row -->
                <div id="card-stats-${item.num}" class="flex flex-wrap items-center gap-1.5 mt-2 text-[11px]">
                  ${item.damage ? `<span class="bg-red-500/15 text-red-300 border border-red-500/30 px-2 py-0.5 rounded font-mono font-bold">AP: ${item.damage}</span>` : ''}
                  ${item.ac ? `<span class="bg-blue-500/15 text-blue-300 border border-blue-500/30 px-2 py-0.5 rounded font-mono font-bold">Def: ${item.ac}</span>` : ''}
                  ${item.req_level ? `<span class="bg-gray-800 text-gray-300 px-2 py-0.5 rounded font-mono">Lvl: ${item.req_level}</span>` : ''}
                  ${item.item_class ? `<span class="bg-purple-500/15 text-purple-300 border border-purple-500/30 px-2 py-0.5 rounded text-[10px]">${item.item_class}</span>` : ''}
                </div>
              </div>
            </div>

            <!-- Middle: Grade Selection Row -->
            <div class="bg-[#090d14] border border-gray-800/80 rounded-lg p-2.5 space-y-1.5">
              <div class="flex items-center justify-between text-[11px]">
                <span class="text-gray-400 font-bold uppercase tracking-wider flex items-center gap-1.5">
                  <i class="fa-solid fa-sliders text-amber-400 text-xs"></i> + Derecesi Seçin:
                </span>
                <button type="button" onclick="loadAllVariantsForCard(${item.num}, '${jsBaseName}')" class="text-[10px] text-amber-400 hover:text-amber-300 font-semibold underline flex items-center gap-1">
                  <i class="fa-solid fa-list-check"></i> Tüm + Seviyeleri
                </button>
              </div>

              <!-- Grade Pills Container -->
              <div id="variants-container-${item.num}" class="flex flex-wrap items-center gap-1.5 pt-1">
                <button type="button" onclick="selectCardGrade(${item.num}, ${item.num}, 0, '${jsName}', ${item.damage||0}, ${item.ac||0})" id="grade-pill-${item.num}-${item.num}" class="grade-pill active">
                  +0
                </button>
              </div>
            </div>

            <!-- Bottom: Quantity Stepper + Action Buttons -->
            <div class="flex items-center justify-between gap-2 pt-2 border-t border-gray-800/80">
              
              <!-- Quantity Stepper -->
              <div class="flex items-center space-x-1.5 bg-[#090d14] border border-gray-700/80 rounded-lg px-2 py-1">
                <span class="text-[10px] text-gray-400 font-bold uppercase">Adet:</span>
                <input type="number" id="card-qty-${item.num}" value="1" min="1" max="9999" class="w-12 bg-transparent text-center text-xs font-bold text-amber-300 focus:outline-none">
              </div>

              <!-- Buttons -->
              <div class="flex items-center space-x-2">
                <button type="button" onclick="loadBaseItemForForge('${jsName}', ${item.num}, ${item.damage||0}, ${item.ac||0}, '${jsIcon}'); switchPlayerTab('forge');" class="bg-[#161d2b] hover:bg-[#1e283b] text-gray-300 hover:text-amber-400 border border-gray-700 text-xs px-3 py-1.5 rounded-lg transition flex items-center gap-1 font-semibold" title="Bu eşyayı Edit Forge atölyesinde özelleştir">
                  <i class="fa-solid fa-hammer"></i> Edit İtem
                </button>
                <button type="button" onclick="giveItemFromCard(${item.num})" class="bg-amber-600 hover:bg-amber-500 text-black font-extrabold text-xs px-4 py-1.5 rounded-lg transition flex items-center gap-1.5 shadow-md shadow-amber-600/30">
                  <i class="fa-solid fa-gift"></i> Seçili Oyuncuya Ver
                </button>
              </div>
            </div>

          </div>
        `;
      }).join('');

      // Background load variants for top 6 items
      items.slice(0, 6).forEach(item => {
        loadAllVariantsForCard(item.num, item.base_name, true);
      });
    }

    function selectCardGrade(baseNum, targetNum, grade, name, damage, ac) {
      selectedCardActiveItem[baseNum] = {
        num: targetNum,
        name: name,
        damage: damage,
        ac: ac,
        grade: grade
      };

      const container = document.getElementById(`variants-container-${baseNum}`);
      if (container) {
        container.querySelectorAll('.grade-pill').forEach(btn => btn.classList.remove('active'));
        const activeBtn = document.getElementById(`grade-pill-${baseNum}-${targetNum}`);
        if (activeBtn) activeBtn.classList.add('active');
      }

      const titleElem = document.getElementById(`card-title-${baseNum}`);
      if (titleElem) titleElem.innerText = name;

      const idElem = document.getElementById(`card-id-${baseNum}`);
      if (idElem) idElem.innerText = targetNum;

      const statsElem = document.getElementById(`card-stats-${baseNum}`);
      if (statsElem) {
        let badgesHtml = '';
        if (damage) badgesHtml += `<span class="bg-red-500/15 text-red-300 border border-red-500/30 px-2 py-0.5 rounded font-mono font-bold">AP: ${damage}</span> `;
        if (ac) badgesHtml += `<span class="bg-blue-500/15 text-blue-300 border border-blue-500/30 px-2 py-0.5 rounded font-mono font-bold">Def: ${ac}</span> `;
        statsElem.innerHTML = badgesHtml;
      }
    }

    async function loadAllVariantsForCard(baseNum, baseName, silent = false) {
      const container = document.getElementById(`variants-container-${baseNum}`);
      if (!container) return;

      if (!silent) {
        container.innerHTML = `<span class="text-[10px] text-gray-400"><i class="fa-solid fa-spinner fa-spin text-amber-500 mr-1"></i> + Seviyeleri aranıyor...</span>`;
      }

      try {
        let variants = cachedVariants[baseName];
        if (!variants) {
          const res = await fetch(`/api/items/variants?base_name=${encodeURIComponent(baseName)}`);
          variants = await res.json();
          cachedVariants[baseName] = variants;
        }

        if (!variants || variants.length === 0) {
          container.innerHTML = `<span class="text-[10px] text-gray-500">Bu eşyanın ekstra + seviyesi bulunmuyor (+0).</span>`;
          return;
        }

        const currentActive = selectedCardActiveItem[baseNum]?.num || baseNum;

        container.innerHTML = variants.map(v => {
          const isActive = v.num === currentActive ? 'active' : '';
          const jsVarName = escapeJs(v.name);
          return `
            <button type="button" 
                    id="grade-pill-${baseNum}-${v.num}" 
                    onclick="selectCardGrade(${baseNum}, ${v.num}, ${v.grade}, '${jsVarName}', ${v.damage||0}, ${v.ac||0})" 
                    class="grade-pill ${isActive}" 
                    title="${escapeHtml(v.name)} (AP: ${v.damage||0}, Def: ${v.ac||0})">
              +${v.grade}
            </button>
          `;
        }).join('');

      } catch (err) {
        if (!silent) {
          container.innerHTML = `<span class="text-[10px] text-red-400">Varyantlar yüklenemedi.</span>`;
        }
      }
    }

    async function giveItemFromCard(baseNum) {
      if (!selectedPlayer) {
        return showToast("Lütfen önce sol listeden bir hedef oyuncu seçin!", true);
      }

      const activeItem = selectedCardActiveItem[baseNum] || { num: baseNum };
      const qtyInput = document.getElementById(`card-qty-${baseNum}`);
      const count = qtyInput ? (parseInt(qtyInput.value) || 1) : 1;

      try {
        const res = await fetch('/api/give-item', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({
            character: selectedPlayer.name,
            item_id: activeItem.num,
            count: count
          })
        });
        const data = await res.json();
        if (data.success) {
          showToast(`[${selectedPlayer.name}] Karakterine ${count}x "${activeItem.name || 'Eşya'}" verildi!`);
        } else {
          showToast(data.message || "İşlem başarısız!", true);
        }
      } catch (err) {
        showToast("Sunucu ile iletişim hatası oluştu!", true);
      }
    }

    // --- DYNAMIC FORGE WORKSPACE ---
    function loadBaseItemForForge(name, num, dmg = 0, ac = 0, iconUrl = '') {
      const slot = document.getElementById('forge-preview-slot');
      if (slot) slot.setAttribute('data-base-id', num);

      const nameElem = document.getElementById('forge-preview-name');
      if (nameElem) nameElem.innerText = name;

      const idElem = document.getElementById('forge-preview-id');
      if (idElem) idElem.innerText = `ID: ${num}`;

      const lblAp = document.getElementById('forge-lbl-ap');
      if (lblAp) lblAp.innerText = dmg;

      const lblDef = document.getElementById('forge-lbl-def');
      if (lblDef) lblDef.innerText = ac;

      // Update Form Inputs
      document.getElementById('forge-name').value = `Edit ${name}`;
      document.getElementById('forge-damage').value = dmg > 0 ? (dmg + 30) : 0;
      document.getElementById('forge-ac').value = ac > 0 ? (ac + 25) : 0;

      // Image
      const imgElem = document.getElementById('forge-preview-img');
      const fallbackElem = document.getElementById('forge-fallback-icon');
      if (iconUrl && imgElem) {
        imgElem.src = iconUrl;
        imgElem.style.display = 'block';
        if (fallbackElem) fallbackElem.style.display = 'none';
      }

      // Close dropdown
      const dd = document.getElementById('forge-search-dropdown');
      if (dd) dd.classList.add('hidden');

      showToast(`Taban Eşya Seçildi: "${name}"`);
    }

    function debounceForgeSearch() {
      clearTimeout(forgeSearchTimer);
      forgeSearchTimer = setTimeout(executeForgeSearch, 250);
    }

    async function executeForgeSearch() {
      const q = document.getElementById('forge-item-search-input').value.trim();
      const dd = document.getElementById('forge-search-dropdown');
      if (!dd) return;

      if (!q || q.length < 2) {
        dd.classList.add('hidden');
        dd.innerHTML = '';
        return;
      }

      dd.classList.remove('hidden');
      dd.innerHTML = `<div class="p-3 text-xs text-center text-gray-400"><i class="fa-solid fa-spinner fa-spin mr-1 text-amber-500"></i> Aranıyor...</div>`;

      try {
        const res = await fetch(`/api/items/search?q=${encodeURIComponent(q)}&base_only=true&limit=12`);
        const data = await res.json();
        const items = Array.isArray(data) ? data : (data.items || []);

        if (items.length === 0) {
          dd.innerHTML = `<div class="p-3 text-xs text-center text-gray-500">Eşya bulunamadı.</div>`;
          return;
        }

        dd.innerHTML = items.map(it => {
          const jsName = escapeJs(it.name);
          const jsIcon = escapeJs(it.icon_url || '');
          return `
            <div onclick="loadBaseItemForForge('${jsName}', ${it.num}, ${it.damage||0}, ${it.ac||0}, '${jsIcon}')" class="flex items-center space-x-2.5 p-2 hover:bg-[#1a2333] cursor-pointer border-b border-gray-800/60 transition">
              <div class="w-8 h-8 rounded bg-[#090d14] flex items-center justify-center overflow-hidden border border-gray-700/60 flex-shrink-0">
                ${it.icon_url ? `<img src="${it.icon_url}" class="w-6 h-6 object-contain">` : `<i class="fa-solid fa-gem text-amber-400 text-xs"></i>`}
              </div>
              <div class="flex-1 min-w-0">
                <div class="text-xs font-bold text-amber-300 truncate">${escapeHtml(it.name)}</div>
                <div class="text-[10px] text-gray-400 space-x-2">
                  <span>ID: ${it.num}</span>
                  ${it.damage ? `<span class="text-red-300">AP: ${it.damage}</span>` : ''}
                  ${it.ac ? `<span class="text-blue-300">Def: ${it.ac}</span>` : ''}
                </div>
              </div>
            </div>
          `;
        }).join('');

      } catch (e) {
        dd.innerHTML = `<div class="p-3 text-xs text-center text-red-400">Arama hatası.</div>`;
      }
    }

    async function submitForgeItem() {
      if (!selectedPlayer) return showToast("Lütfen önce bir hedef oyuncu seçin!", true);
      const slot = document.getElementById('forge-preview-slot');
      const baseId = slot ? (parseInt(slot.getAttribute('data-base-id')) || 111210000) : 111210000;
      const count = parseInt(document.getElementById('forge-count')?.value) || 1;

      const payload = {
        character: selectedPlayer.name,
        base_item_id: baseId,
        name: document.getElementById('forge-name').value.trim() || "Özel Edit Eşya",
        damage: parseInt(document.getElementById('forge-damage').value) || 0,
        ac: parseInt(document.getElementById('forge-ac').value) || 0,
        maxhpb: parseInt(document.getElementById('forge-maxhp').value) || 0,
        maxmpb: parseInt(document.getElementById('forge-maxmp').value) || 0,
        strb: parseInt(document.getElementById('forge-str').value) || 0,
        dexb: parseInt(document.getElementById('forge-dex').value) || 0,
        stab: parseInt(document.getElementById('forge-hp').value) || 0,
        intelb: parseInt(document.getElementById('forge-intel').value) || 0,
        chab: parseInt(document.getElementById('forge-cha').value) || 0,
        firedamage: parseInt(document.getElementById('forge-fire').value) || 0,
        icedamage: parseInt(document.getElementById('forge-ice').value) || 0,
        lightningdamage: parseInt(document.getElementById('forge-light').value) || 0,
        poisondamage: parseInt(document.getElementById('forge-poison').value) || 0,
        count: count
      };

      try {
        const res = await fetch('/api/forge-item', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify(payload)
        });
        const data = await res.json();
        if (data.success) {
          showToast(`[${selectedPlayer.name}] Karakterine "${payload.name}" başarıyla üretilip teslim edildi!`);
        } else {
          showToast(data.message || "Edit eşya üretilemedi!", true);
        }
      } catch (err) {
        showToast("Edit eşya üretilemedi!", true);
      }
    }


    // =========================================================
    // SERVER & EVENT MODE LOGIC (STANDALONE)
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
          body: JSON.stringify({
            ssid: ssid,
            zone: zone,
            count: count
          })
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

    // --- REFRESH ALL ---
    function refreshData() {
      loadStatus();
      loadCharactersList();
      if (currentMainMode === 'server') {
        loadQueueHistory();
      }
      showToast("Veriler güncellendi");
    }

    // Periodic heartbeat every 4 seconds
    setInterval(() => {
      loadStatus();
      if (currentMainMode === 'players') {
        // silent sync for online status
        fetch(`/api/characters/search?q=&status=all&nation=all&job=all&limit=200`)
          .then(r => r.json())
          .then(data => {
            document.getElementById('count-status-online').innerText = data.online_count;
            document.getElementById('count-status-offline').innerText = data.offline_count;
          }).catch(()=>{});
      }
    }, 4000);

    // Initial load
    window.addEventListener('DOMContentLoaded', () => {
      loadStatus();
      loadCharactersList();
    });
  

    // ========================================================
    // --- 🐲 DROP & SPAWN EDİTÖRÜ JAVASCRIPT MOTORU ---
    let currentMobFilters = {
      q: '',
      zone: 0,
      has_drops: 'all',
      is_boss: 'all',
      page: 1,
      limit: 50,
      total: 0
    };
    let currentSelectedSSID = null;
    let currentMobData = null;
    let currentMobSpawns = [];
    let mobDropSlots = [
      { slot: 1, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
      { slot: 2, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
      { slot: 3, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
      { slot: 4, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
      { slot: 5, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
      { slot: 6, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
      { slot: 7, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 }
    ];
    let pickerTargetSlotIndex = 0; // 0..6
    let mobSearchDebounceTimer = null;

    function debounceMobSearch() {
      clearTimeout(mobSearchDebounceTimer);
      mobSearchDebounceTimer = setTimeout(() => {
        currentMobFilters.q = document.getElementById('mobs-search-query').value.trim();
        currentMobFilters.page = 1;
        loadMobsList();
      }, 300);
    }

    function clearMobSearch() {
      document.getElementById('mobs-search-query').value = '';
      currentMobFilters.q = '';
      currentMobFilters.page = 1;
      loadMobsList();
    }

    function applyMobFilters() {
      currentMobFilters.zone = parseInt(document.getElementById('mobs-filter-zone').value || '0');
      currentMobFilters.page = 1;
      loadMobsList();
    }

    function setMobDropFilter(val) {
      currentMobFilters.has_drops = val;
      ['all', 'yes', 'no'].forEach(x => {
        document.getElementById(`btn-drop-${x}`)?.classList.toggle('active', x === val);
      });
      currentMobFilters.page = 1;
      loadMobsList();
    }

    function setMobBossFilter(val) {
      currentMobFilters.is_boss = val;
      ['all', 'boss', 'normal'].forEach(x => {
        document.getElementById(`btn-boss-${x}`)?.classList.toggle('active', x === val);
      });
      currentMobFilters.page = 1;
      loadMobsList();
    }

    function changeMobPage(delta) {
      const newPage = currentMobFilters.page + delta;
      if (newPage < 1) return;
      currentMobFilters.page = newPage;
      loadMobsList();
    }

    async function loadMobsList() {
      const container = document.getElementById('mobs-list-container');
      container.innerHTML = `<div class="text-center py-10 text-gray-500 text-xs"><i class="fa-solid fa-spinner fa-spin mr-2"></i>Canavarlar listeleniyor...</div>`;

      const offset = (currentMobFilters.page - 1) * currentMobFilters.limit;
      const params = new URLSearchParams({
        q: currentMobFilters.q,
        zone: currentMobFilters.zone,
        has_drops: currentMobFilters.has_drops,
        is_boss: currentMobFilters.is_boss,
        offset: offset,
        limit: currentMobFilters.limit
      });

      try {
        const res = await fetch(`/api/mobs?${params.toString()}`);
        const data = await res.json();
        const mobs = data.mobs || [];
        currentMobFilters.total = data.total || 0;

        // Sayfa etiketini ve butonları güncelle
        const totalPages = Math.max(1, Math.ceil(currentMobFilters.total / currentMobFilters.limit));
        document.getElementById('mobs-page-label').textContent = `${currentMobFilters.page} / ${totalPages} (${currentMobFilters.total.toLocaleString()} Canavar)`;
        document.getElementById('mobs-total-badge').textContent = `${currentMobFilters.total.toLocaleString()} Canavar`;
        document.getElementById('btn-mob-prev').disabled = currentMobFilters.page <= 1;
        document.getElementById('btn-mob-next').disabled = currentMobFilters.page >= totalPages;

        if (mobs.length === 0) {
          container.innerHTML = `<div class="text-center py-12 text-gray-500 text-xs">Aradığınız kriterlere uygun canavar bulunamadı.</div>`;
          return;
        }

        container.innerHTML = mobs.map(m => {
          const isSelected = (currentSelectedSSID === m.ssid);
          const bossBadge = m.is_boss 
            ? `<span class="text-[9px] bg-red-950/80 text-red-300 border border-red-700/50 px-1.5 py-0.2 rounded font-bold">BOSS</span>`
            : '';
          const dropBadge = (m.drop_count > 0)
            ? `<span class="text-[9px] bg-emerald-950/80 text-emerald-300 border border-emerald-700/50 px-1.5 py-0.2 rounded font-mono">${m.drop_count} Droplu</span>`
            : `<span class="text-[9px] text-gray-600 font-mono">Dropsuz</span>`;
          const spawnInfo = (m.spawn_count > 0)
            ? `<span class="text-blue-400">${m.spawn_count} Nokta</span>`
            : `<span class="text-gray-500">Spawn Yok</span>`;

          return `
            <div id="mob-card-${m.ssid}" onclick="selectMob(${m.ssid})" class="p-2.5 rounded-xl cursor-pointer transition border ${isSelected ? 'bg-[#1b2536] border-emerald-500 shadow-md' : 'bg-[#0f141f] border-[#1d2636] hover:bg-[#141b29] hover:border-gray-600'} flex items-center justify-between gap-2">
              <div class="flex items-center space-x-2.5 min-w-0">
                <div class="w-8 h-8 rounded-lg ${m.is_boss ? 'bg-red-950/50 text-red-400 border border-red-800/40' : 'bg-emerald-950/40 text-emerald-400 border border-emerald-800/30'} flex items-center justify-center font-bold text-xs flex-shrink-0">
                  <i class="fa-solid fa-dragon"></i>
                </div>
                <div class="min-w-0">
                  <div class="flex items-center space-x-1.5">
                    <span class="text-xs font-bold text-gray-100 truncate">${m.name}</span>
                    ${bossBadge}
                  </div>
                  <div class="text-[10px] text-gray-400 flex items-center gap-1 font-mono">
                    <span class="text-emerald-400">#${m.ssid}</span>
                    <span>•</span>
                    <span>Lv.${m.level}</span>
                    <span>•</span>
                    <span>${spawnInfo}</span>
                  </div>
                </div>
              </div>
              <div class="flex flex-col items-end flex-shrink-0">
                ${dropBadge}
                <span class="text-[9px] text-gray-500 font-mono mt-0.5">${(m.hp || 0).toLocaleString()} HP</span>
              </div>
            </div>
          `;
        }).join('');

        // Eğer henüz bir mob seçilmediyse ilkini seç
        if (!currentSelectedSSID && mobs.length > 0) {
          selectMob(mobs[0].ssid);
        }

      } catch (err) {
        container.innerHTML = `<div class="text-center py-10 text-red-400 text-xs">Canavar listesi alınamadı: ${err.message}</div>`;
      }
    }

    async function selectMob(ssid) {
      currentSelectedSSID = ssid;
      
      // Mob listesindeki aktif kartı vurgula
      const cards = document.querySelectorAll('#mobs-list-container > div');
      cards.forEach(c => {
        if (c.id === `mob-card-${ssid}`) {
          c.className = "p-2.5 rounded-xl cursor-pointer transition border bg-[#1b2536] border-emerald-500 shadow-md flex items-center justify-between gap-2";
        } else {
          c.className = "p-2.5 rounded-xl cursor-pointer transition border bg-[#0f141f] border-[#1d2636] hover:bg-[#141b29] hover:border-gray-600 flex items-center justify-between gap-2";
        }
      });

      try {
        const res = await fetch(`/api/mobs/${ssid}`);
        const data = await res.json();
        currentMobData = data;

        // Header Bilgilerini Doldur
        const mob = data.mob || {};
        document.getElementById('mob-detail-name').textContent = mob.name || 'Bilinmeyen Canavar';
        document.getElementById('mob-detail-ssid').textContent = `SSID: ${mob.ssid}`;
        const isBoss = (mob.level >= 70 || (mob.ssid >= 5000 && mob.ssid < 6000));
        document.getElementById('mob-detail-boss-badge').classList.toggle('hidden', !isBoss);
        document.getElementById('mob-detail-stats').innerHTML = `
          Level: <b class="text-emerald-300">${mob.level || 0}</b> • 
          HP: <b class="text-emerald-300">${(mob.hp || 0).toLocaleString()}</b> • 
          MP: <b class="text-gray-300">${(mob.mp || 0).toLocaleString()}</b> • 
          Defans: <b class="text-gray-300">${mob.ac || 0}</b> • 
          EXP: <b class="text-amber-300">${(mob.exp || 0).toLocaleString()}</b>
        `;

        // 7 Drop Slotunu Hazırla & Render Et
        mobDropSlots = (data.drops && data.drops.length === 7) ? data.drops.map(d => ({
          slot: d.slot,
          item_id: d.item_id || 0,
          name: d.item_name || (d.item_id > 0 ? `Eşya #${d.item_id}` : '(Boş Slot)'),
          icon_url: d.icon_url || '',
          persent: d.percent_raw || 0,
          percent_rate: d.percent_float || 0
        })) : [
          { slot: 1, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
          { slot: 2, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
          { slot: 3, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
          { slot: 4, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
          { slot: 5, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
          { slot: 6, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 },
          { slot: 7, item_id: 0, name: '(Boş Slot)', icon_url: '', persent: 0, percent_rate: 0 }
        ];
        renderMobDropSlots();

        // Spawn Noktalarını Render Et
        currentMobSpawns = data.spawns || [];
        renderMobSpawns(currentMobSpawns);

      } catch (err) {
        showToast(`Canavar detayları alınamadı: ${err.message}`, 'error');
      }
    }

    // --- 7 DROP SLOTU RENDER EDİCİ ---
    function renderMobDropSlots() {
      const container = document.getElementById('mob-drop-slots-container');
      container.innerHTML = mobDropSlots.map((d, idx) => {
        const hasItem = (d.item_id > 0);
        const iconHtml = (hasItem && d.icon_url) ? `
          <img src="${d.icon_url}" class="w-10 h-10 object-contain drop-shadow" alt="${escapeHtml(d.name)}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
          <div class="w-10 h-10 items-center justify-center text-amber-400 text-lg hidden">
            <i class="fa-solid fa-gem"></i>
          </div>
        ` : `
          <div class="w-10 h-10 flex items-center justify-center text-gray-500 text-lg">
            <i class="fa-solid fa-${hasItem ? 'gem text-amber-400' : 'gift text-gray-600'}"></i>
          </div>
        `;

        return `
          <div class="bg-[#0b0e15] border border-[#202b3d] hover:border-gray-700 rounded-xl p-3 flex flex-wrap items-center justify-between gap-3 transition">
            
            <!-- Sol: Slot Numarası & Eşya Kutusu -->
            <div class="flex items-center space-x-3 min-w-[240px]">
              <span class="text-[11px] font-mono font-black text-amber-400 bg-amber-500/10 border border-amber-500/20 px-2 py-1 rounded">#${d.slot}</span>
              <div class="ko-slot cursor-pointer" onclick="openDropItemPicker(${idx})" title="Eşyayı Değiştirmek İçin Tıklayın">
                ${iconHtml}
              </div>
              <div class="min-w-0">
                <div class="text-xs font-bold text-gray-100 truncate">${hasItem ? d.name : '<span class="text-gray-500 italic">Eşya Atanmadı (Boş)</span>'}</div>
                <div class="text-[10px] text-gray-400 font-mono flex items-center gap-2">
                  <span>ID: ${hasItem ? d.item_id : '0'}</span>
                  ${hasItem ? `<button onclick="clearMobDropSlot(${idx})" class="text-red-400 hover:text-red-300 hover:underline">Boşalt</button>` : ''}
                </div>
              </div>
            </div>

            <!-- Sağ: Oran Girişi (%) & Hızlı Butonlar -->
            <div class="flex items-center space-x-3 flex-1 justify-end">
              <!-- Yüzde ve Basis Point (10000 üzerinden) -->
              <div class="flex items-center space-x-2">
                <label class="text-[10px] text-gray-400 font-bold">Oran:</label>
                <div class="relative w-24">
                  <input type="number" step="0.01" min="0" max="100" id="drop-rate-input-${idx}" value="${d.percent_rate}"
                         oninput="onDropRateChange(${idx}, this.value)"
                         class="w-full bg-[#121824] border border-gray-700 rounded px-2 py-1 text-xs text-amber-300 font-mono font-bold text-right pr-6 focus:outline-none focus:border-amber-500">
                  <span class="absolute right-2 top-1 text-gray-400 text-xs font-bold">%</span>
                </div>
                <span id="drop-basis-hint-${idx}" class="text-[10px] text-gray-500 font-mono w-16 text-right">(${d.persent}/10k)</span>
              </div>

              <!-- Hızlı Oran Seçimleri -->
              <div class="hidden sm:flex items-center space-x-1">
                <button onclick="setQuickDropRate(${idx}, 100)" class="grade-pill text-[10px] px-1.5 py-0.5">%100</button>
                <button onclick="setQuickDropRate(${idx}, 25)" class="grade-pill text-[10px] px-1.5 py-0.5">%25</button>
                <button onclick="setQuickDropRate(${idx}, 10)" class="grade-pill text-[10px] px-1.5 py-0.5">%10</button>
                <button onclick="setQuickDropRate(${idx}, 5)" class="grade-pill text-[10px] px-1.5 py-0.5">%5</button>
                <button onclick="setQuickDropRate(${idx}, 1)" class="grade-pill text-[10px] px-1.5 py-0.5">%1</button>
                <button onclick="setQuickDropRate(${idx}, 0.1)" class="grade-pill text-[10px] px-1.5 py-0.5">%0.1</button>
              </div>

              <!-- Seç/Değiştir Butonu -->
              <button onclick="openDropItemPicker(${idx})" class="px-2.5 py-1 rounded bg-[#1a2333] hover:bg-[#253247] text-gray-300 hover:text-white text-xs font-bold transition border border-gray-700">
                <i class="fa-solid fa-folder-open mr-1 text-amber-400"></i> Seç
              </button>
            </div>

          </div>
        `;
      }).join('');
    }

    function onDropRateChange(slotIdx, percentVal) {
      const p = Math.max(0, Math.min(100, parseFloat(percentVal) || 0));
      const basis = Math.round(p * 100);
      mobDropSlots[slotIdx].percent_rate = p;
      mobDropSlots[slotIdx].persent = basis;
      const hint = document.getElementById(`drop-basis-hint-${slotIdx}`);
      if (hint) hint.textContent = `(${basis}/10k)`;
    }

    function setQuickDropRate(slotIdx, percent) {
      const input = document.getElementById(`drop-rate-input-${slotIdx}`);
      if (input) input.value = percent;
      onDropRateChange(slotIdx, percent);
    }

    function clearMobDropSlot(slotIdx) {
      mobDropSlots[slotIdx].item_id = 0;
      mobDropSlots[slotIdx].name = '(Boş Slot)';
      mobDropSlots[slotIdx].icon_url = '';
      mobDropSlots[slotIdx].persent = 0;
      mobDropSlots[slotIdx].percent_rate = 0;
      renderMobDropSlots();
    }

    // --- DROP MODAL İŞLEMLERİ ---
    function openDropItemPicker(slotIdx) {
      pickerTargetSlotIndex = slotIdx;
      document.getElementById('picker-target-slot-label').textContent = `Slot #${slotIdx + 1} Eşyası Düzenleniyor`;
      document.getElementById('drop-item-picker-modal').classList.remove('hidden');
      document.getElementById('picker-search-query').focus();
    }

    function closeDropItemPicker() {
      document.getElementById('drop-item-picker-modal').classList.add('hidden');
    }

    function quickSearchPickerItem(name) {
      document.getElementById('picker-search-query').value = name;
      searchDropPickerItems();
    }

    async function searchDropPickerItems() {
      const q = document.getElementById('picker-search-query').value.trim();
      if (!q) return;
      const container = document.getElementById('picker-results-container');
      container.innerHTML = `<div class="col-span-full text-center py-10 text-gray-400"><i class="fa-solid fa-spinner fa-spin mr-2"></i>Eşyalar aranıyor...</div>`;

      try {
        const res = await fetch(`/api/items/search?q=${encodeURIComponent(q)}&limit=24`);
        const data = await res.json();
        const items = Array.isArray(data) ? data : (data.items || []);
        if (!items || items.length === 0) {
          container.innerHTML = `<div class="col-span-full text-center py-10 text-gray-500 text-xs">"${q}" ile eşleşen eşya bulunamadı.</div>`;
          return;
        }

        container.innerHTML = items.map(item => {
          const iconHtml = item.icon_url 
            ? `<img src="${item.icon_url}" class="w-10 h-10 object-contain drop-shadow" alt="${item.name}">`
            : `<i class="fa-solid fa-shield-halved text-gray-500 text-xl"></i>`;

          return `
            <div class="bg-[#0b0e15] border border-gray-800 hover:border-amber-500/60 rounded-xl p-2.5 flex items-center justify-between gap-2 transition">
              <div class="flex items-center space-x-2.5 min-w-0">
                <div class="ko-slot">
                  ${iconHtml}
                </div>
                <div class="min-w-0">
                  <div class="text-xs font-bold text-gray-100 truncate">${item.name}</div>
                  <div class="text-[10px] text-gray-400 font-mono">ID: ${item.num}</div>
                </div>
              </div>
              <button onclick="assignItemToSlot(${item.num}, '${item.name.replace(/'/g, "\\'")}', '${item.icon_url || ''}')" class="px-3 py-1.5 bg-amber-600 hover:bg-amber-500 text-black font-extrabold text-xs rounded-lg transition">
                Seç
              </button>
            </div>
          `;
        }).join('');
      } catch (err) {
        container.innerHTML = `<div class="col-span-full text-center py-10 text-red-400 text-xs">Arama başarısız: ${err.message}</div>`;
      }
    }

    function assignItemToSlot(num, name, iconUrl) {
      mobDropSlots[pickerTargetSlotIndex].item_id = num;
      mobDropSlots[pickerTargetSlotIndex].name = name;
      mobDropSlots[pickerTargetSlotIndex].icon_url = iconUrl;
      if (mobDropSlots[pickerTargetSlotIndex].persent === 0) {
        mobDropSlots[pickerTargetSlotIndex].persent = 1000;
        mobDropSlots[pickerTargetSlotIndex].percent_rate = 10.0;
      }
      closeDropItemPicker();
      renderMobDropSlots();
      showToast(`Slot #${pickerTargetSlotIndex + 1} için "${name}" seçildi!`, 'success');
    }

    // --- DROP KAYDETME (API + RELOAD_DROPS) ---
    async function saveMobDrops() {
      if (!currentSelectedSSID) {
        showToast('Lütfen önce bir canavar seçin!', 'error');
        return;
      }

      const btn = document.getElementById('btn-save-drops');
      btn.disabled = true;
      btn.innerHTML = `<i class="fa-solid fa-spinner fa-spin mr-1"></i> Kaydediliyor & Reload Gönderiliyor...`;

      try {
        const payload = {
          drops: mobDropSlots.map(d => ({
            slot: d.slot,
            item_id: parseInt(d.item_id) || 0,
            percent: parseFloat(d.percent_rate) || 0
          }))
        };

        const res = await fetch(`/api/mobs/${currentSelectedSSID}/drops`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload)
        });
        const result = await res.json();
        if (result.success) {
          showToast(result.message || 'Drop oranları güncellendi ve sunucuya aktarıldı!', 'success');
        } else {
          showToast(result.error || 'Kaydetme başarısız!', 'error');
        }
      } catch (err) {
        showToast(`Hata: ${err.message}`, 'error');
      } finally {
        btn.disabled = false;
        btn.innerHTML = `<i class="fa-solid fa-floppy-disk mr-1"></i> Drop Oranlarını Kaydet & Sunucuda Yenile`;
      }
    }

    // --- SPAWN NOKTALARI RENDER & İŞLEMLERİ ---
    function renderMobSpawns(spawns) {
      const container = document.getElementById('mob-spawns-container');
      const countBadge = document.getElementById('mob-spawn-count-badge');
      if (countBadge) countBadge.textContent = `${spawns.length} Doğma Noktası`;

      if (!spawns || spawns.length === 0) {
        container.innerHTML = `<div class="text-center py-6 text-gray-500 text-xs">Bu canavar için K_NPCPOS tablosunda kayıtlı doğma noktası bulunamadı.</div>`;
        return;
      }

      container.innerHTML = spawns.map((s, idx) => {
        const timeMinutes = Math.round(s.reg_time / 60);
        const timeHint = s.reg_time >= 3600 
          ? `${(s.reg_time / 3600).toFixed(1)} saat` 
          : (s.reg_time >= 60 ? `${timeMinutes} dk` : `${s.reg_time} sn`);

        return `
          <div id="spawn-spot-card-${idx}" class="bg-[#0b0e15] border border-blue-900/40 rounded-xl p-3 space-y-2 text-xs">
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-2">
                <span class="w-6 h-6 rounded bg-blue-950 text-blue-400 flex items-center justify-center font-bold text-[10px] border border-blue-800/40">#${idx + 1}</span>
                <span class="font-bold text-gray-200">${s.zone_name}</span>
                <span class="text-[10px] text-gray-500 font-mono">(Zone ${s.zone_id})</span>
              </div>
              <span class="text-[10px] bg-blue-900/30 text-blue-300 px-2 py-0.5 rounded font-mono border border-blue-700/30">
                X: ${s.left_x} • Z: ${s.top_z}
              </span>
            </div>

            <div class="grid grid-cols-2 gap-2 pt-1 border-t border-gray-800">
              <div>
                <label class="text-[10px] text-gray-400 block mb-0.5">Adet (NumNPC):</label>
                <input type="number" id="spot-num-${idx}" value="${s.num_npc}" min="1" max="50"
                       class="w-full bg-[#121824] border border-gray-700 rounded px-2 py-1 text-gray-200 font-mono text-xs">
              </div>
              <div>
                <label class="text-[10px] text-gray-400 block mb-0.5">Respawn (RegTime - Sn):</label>
                <div class="flex items-center gap-1">
                  <input type="number" id="spot-reg-${idx}" value="${s.reg_time}" min="1"
                         class="w-full bg-[#121824] border border-gray-700 rounded px-2 py-1 text-gray-200 font-mono text-xs">
                  <span class="text-[10px] text-blue-400 font-mono w-14 text-right">${timeHint}</span>
                </div>
              </div>
            </div>

            <div class="flex items-center justify-end space-x-2 pt-1">
              <button onclick="deleteSpawnSpot(${s.zone_id}, ${s.left_x}, ${s.top_z})" class="px-2.5 py-1 rounded bg-red-950/60 hover:bg-red-900 text-red-300 text-[11px] font-bold border border-red-800/40 transition">
                <i class="fa-solid fa-trash mr-1"></i> Sil
              </button>
              <button onclick="updateSpawnSpot(${s.zone_id}, ${s.left_x}, ${s.top_z}, ${idx})" class="px-3 py-1 rounded bg-blue-600 hover:bg-blue-500 text-white text-[11px] font-bold transition flex items-center gap-1">
                <i class="fa-solid fa-check"></i> Güncelle
              </button>
            </div>
          </div>
        `;
      }).join('');
    }

    async function updateSpawnSpot(zoneId, leftX, topZ, idx) {
      if (!currentSelectedSSID) return;
      const numNpc = parseInt(document.getElementById(`spot-num-${idx}`)?.value || '1');
      const regTime = parseInt(document.getElementById(`spot-reg-${idx}`)?.value || '60');

      try {
        const res = await fetch(`/api/mobs/${currentSelectedSSID}/spawn/update`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            zone_id: zoneId,
            left_x: leftX,
            top_z: topZ,
            num_npc: numNpc,
            reg_time: regTime
          })
        });
        const result = await res.json();
        if (result.success) {
          showToast(result.message || 'Spawn noktası güncellendi!', 'success');
        } else {
          showToast(result.error || 'Güncelleme başarısız!', 'error');
        }
      } catch (err) {
        showToast(`Hata: ${err.message}`, 'error');
      }
    }

    async function deleteSpawnSpot(zoneId, leftX, topZ) {
      if (!confirm(`Bu doğma noktasını (Zone ${zoneId}, X:${leftX}, Z:${topZ}) silmek istediğinize emin misiniz?`)) return;

      try {
        const res = await fetch(`/api/mobs/${currentSelectedSSID}/spawn/delete`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            zone_id: zoneId,
            left_x: leftX,
            top_z: topZ
          })
        });
        const result = await res.json();
        if (result.success) {
          showToast(result.message || 'Spawn noktası silindi!', 'success');
          selectMob(currentSelectedSSID);
        } else {
          showToast(result.error || 'Silme başarısız!', 'error');
        }
      } catch (err) {
        showToast(`Hata: ${err.message}`, 'error');
      }
    }

    async function addNewSpawnSpot() {
      if (!currentSelectedSSID) {
        showToast('Lütfen önce bir canavar seçin!', 'error');
        return;
      }

      const zoneId = parseInt(document.getElementById('new-spawn-zone').value || '21');
      const count = parseInt(document.getElementById('new-spawn-count').value || '1');
      const x = parseInt(document.getElementById('new-spawn-x').value || '0');
      const z = parseInt(document.getElementById('new-spawn-z').value || '0');
      const regTime = parseInt(document.getElementById('new-spawn-regtime').value || '60');

      try {
        const res = await fetch(`/api/mobs/${currentSelectedSSID}/spawn/add`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            zone_id: zoneId,
            num_npc: count,
            x: x,
            z: z,
            reg_time: regTime
          })
        });
        const result = await res.json();
        if (result.success) {
          showToast(result.message || 'Yeni doğma noktası eklendi!', 'success');
          selectMob(currentSelectedSSID);
        } else {
          showToast(result.error || 'Ekleme başarısız!', 'error');
        }
      } catch (err) {
        showToast(`Hata: ${err.message}`, 'error');
      }
    }

    async function testSpawnCurrentMob() {
      if (!currentSelectedSSID) {
        showToast('Lütfen önce bir canavar seçin!', 'error');
        return;
      }
      try {
        const res = await fetch('/api/server/spawn-boss', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            ssid: currentSelectedSSID,
            zone: 21,
            count: 1
          })
        });
        const result = await res.json();
        if (result.success) {
          showToast(result.message || 'Test spawn komutu GameServer kuyruğuna gönderildi!', 'success');
        } else {
          showToast(result.error || 'Test spawn başarısız!', 'error');
        }
      } catch (err) {
        showToast(`Hata: ${err.message}`, 'error');
      }
    }



    // ========================================================
    // --- 📦 KUTU, GEM & UPGRADE ORANLARI JAVASCRIPT MOTORU ---
    // ========================================================
    let currentChestSubTab = 'chests'; // 'chests' or 'upgrades'
    let chestsList = [];
    let selectedChestId = 379156000; // Varsayılan Mavi Kutu
    let selectedChestData = null;
    let chestTypeFilter = 'all';
    let chestSearchDebounceTimer = null;

    let upgradeData = null;
    let selectedUpgradeCategoryKey = 'bus';

    function switchChestSubTab(tab) {
      currentChestSubTab = tab;
      document.getElementById('subtab-btn-chests')?.classList.toggle('bg-purple-600', tab === 'chests');
      document.getElementById('subtab-btn-chests')?.classList.toggle('text-white', tab === 'chests');
      document.getElementById('subtab-btn-chests')?.classList.toggle('bg-[#172030]', tab !== 'chests');
      document.getElementById('subtab-btn-chests')?.classList.toggle('text-gray-300', tab !== 'chests');

      document.getElementById('subtab-btn-upgrades')?.classList.toggle('bg-purple-600', tab === 'upgrades');
      document.getElementById('subtab-btn-upgrades')?.classList.toggle('text-white', tab === 'upgrades');
      document.getElementById('subtab-btn-upgrades')?.classList.toggle('bg-[#172030]', tab !== 'upgrades');
      document.getElementById('subtab-btn-upgrades')?.classList.toggle('text-gray-300', tab !== 'upgrades');

      document.getElementById('chests-subtab-container')?.classList.toggle('hidden', tab !== 'chests');
      document.getElementById('upgrades-subtab-container')?.classList.toggle('hidden', tab !== 'upgrades');

      if (tab === 'upgrades' && !upgradeData) {
        loadUpgradeRates();
      }
    }

    function debounceChestSearch() {
      clearTimeout(chestSearchDebounceTimer);
      chestSearchDebounceTimer = setTimeout(() => {
        loadChestsList();
      }, 300);
    }

    function clearChestSearch() {
      document.getElementById('chests-search-query').value = '';
      loadChestsList();
    }

    function setChestTypeFilter(type) {
      chestTypeFilter = type;
      ['all', 'chest', 'gem', 'fragment'].forEach(t => {
        document.getElementById(`btn-chesttype-${t}`)?.classList.toggle('active', t === type);
      });
      loadChestsList();
    }

    async function loadChestsList() {
      const q = document.getElementById('chests-search-query')?.value || '';
      const container = document.getElementById('chests-list-container');
      container.innerHTML = `<div class="text-center py-10 text-gray-500 text-xs"><i class="fa-solid fa-spinner fa-spin mr-2"></i>Kutular yükleniyor...</div>`;

      try {
        const res = await fetch(`/api/chests?q=${encodeURIComponent(q)}&filter_type=${chestTypeFilter}`);
        chestsList = await res.json();
        document.getElementById('chests-total-badge').textContent = `${chestsList.length} Eşya`;

        if (!chestsList || chestsList.length === 0) {
          container.innerHTML = `<div class="text-center py-10 text-gray-500 text-xs">Aradığınız kriterde kutu/gem bulunamadı.</div>`;
          return;
        }

        container.innerHTML = chestsList.map(c => {
          const isSelected = (selectedChestId === c.id);
          const typeBadge = c.type === 'gem'
            ? `<span class="text-[9px] bg-emerald-950 text-emerald-300 border border-emerald-700/50 px-1.5 py-0.2 rounded font-mono">GEM</span>`
            : (c.type === 'fragment' 
              ? `<span class="text-[9px] bg-amber-950 text-amber-300 border border-amber-700/50 px-1.5 py-0.2 rounded font-mono">FRAG</span>`
              : `<span class="text-[9px] bg-blue-950 text-blue-300 border border-blue-700/50 px-1.5 py-0.2 rounded font-mono">KUTU</span>`);

          return `
            <div id="chest-card-${c.id}" onclick="selectChest(${c.id})" class="p-2.5 rounded-xl cursor-pointer transition border ${isSelected ? 'bg-[#1e1b30] border-purple-500 shadow-md' : 'bg-[#0f141f] border-[#1d2636] hover:bg-[#141b29] hover:border-gray-600'} flex items-center justify-between gap-2">
              <div class="flex items-center space-x-2.5 min-w-0">
                <div class="ko-slot flex-shrink-0 flex items-center justify-center">
                  ${c.icon_url ? `
                    <img src="${c.icon_url}" class="w-8 h-8 object-contain drop-shadow" alt="${escapeHtml(c.name)}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                    <div class="w-8 h-8 items-center justify-center text-purple-400 text-sm hidden">
                      <i class="fa-solid fa-box-archive"></i>
                    </div>
                  ` : `
                    <div class="w-8 h-8 flex items-center justify-center text-purple-400 text-sm">
                      <i class="fa-solid fa-box-archive"></i>
                    </div>
                  `}
                </div>
                <div class="min-w-0">
                  <div class="flex items-center space-x-1.5">
                    <span class="text-xs font-bold text-gray-100 truncate">${c.name}</span>
                    ${typeBadge}
                  </div>
                  <div class="text-[10px] text-gray-400 font-mono">
                    <span class="text-purple-400">#${c.id}</span> • <span>${c.drop_count} Farklı Eşya</span>
                  </div>
                </div>
              </div>
              <div class="text-right flex-shrink-0">
                <span class="text-[9px] text-gray-500 font-mono block">Ağırlık:</span>
                <span class="text-[10px] text-purple-300 font-mono font-bold">${c.total_weight.toLocaleString()}</span>
              </div>
            </div>
          `;
        }).join('');

        // Eğer seçili olan listede yoksa ilkini seç
        if (chestsList.length > 0 && !chestsList.find(x => x.id === selectedChestId)) {
          selectChest(chestsList[0].id);
        } else if (chestsList.length > 0) {
          selectChest(selectedChestId);
        }

      } catch (err) {
        container.innerHTML = `<div class="text-center py-10 text-red-400 text-xs">Yükleme hatası: ${err.message}</div>`;
      }
    }

    async function selectChest(chestId) {
      selectedChestId = chestId;

      // Sol listede aktif border
      const cards = document.querySelectorAll('#chests-list-container > div');
      cards.forEach(c => {
        if (c.id === `chest-card-${chestId}`) {
          c.className = "p-2.5 rounded-xl cursor-pointer transition border bg-[#1e1b30] border-purple-500 shadow-md flex items-center justify-between gap-2";
        } else {
          c.className = "p-2.5 rounded-xl cursor-pointer transition border bg-[#0f141f] border-[#1d2636] hover:bg-[#141b29] hover:border-gray-600 flex items-center justify-between gap-2";
        }
      });

      const tableContainer = document.getElementById('chest-drops-table-container');
      tableContainer.innerHTML = `<div class="text-center py-16 text-gray-500 text-xs"><i class="fa-solid fa-spinner fa-spin mr-2"></i>Eşyalar listeleniyor...</div>`;

      try {
        const res = await fetch(`/api/chests/${chestId}`);
        const data = await res.json();
        selectedChestData = data;

        // Header bilgilerini doldur
        const chest = data.chest || {};
        document.getElementById('selected-chest-name').textContent = chest.name;
        document.getElementById('selected-chest-id-badge').textContent = `ID: ${chest.id}`;
        const cImg = document.getElementById('selected-chest-icon');
        const cFb = document.getElementById('selected-chest-fallback');
        if (chest.icon_url) {
          cImg.src = chest.icon_url;
          cImg.style.display = 'block';
          if (cFb) cFb.style.display = 'none';
        } else {
          cImg.style.display = 'none';
          if (cFb) cFb.style.display = 'flex';
        }
        document.getElementById('selected-chest-drops-count').textContent = `${chest.total_drops} Eşya`;
        document.getElementById('selected-chest-total-weight').textContent = chest.total_weight.toLocaleString();

        renderChestDrops();

      } catch (err) {
        tableContainer.innerHTML = `<div class="text-center py-16 text-red-400 text-xs">Detaylar alınamadı: ${err.message}</div>`;
      }
    }

    function renderChestDrops() {
      const container = document.getElementById('chest-drops-table-container');
      const drops = selectedChestData?.drops || [];

      if (drops.length === 0) {
        container.innerHTML = `<div class="text-center py-16 text-gray-500 text-xs">Bu kutuda henüz drop eşyası tanımlanmamış.</div>`;
        return;
      }

      container.innerHTML = drops.map((d, idx) => {
        return `
          <div class="p-3 hover:bg-[#131a27] transition flex flex-wrap items-center justify-between gap-3 text-xs">
            
            <!-- Eşya İkonu & Adı -->
            <div class="flex items-center space-x-3 min-w-[240px]">
              <div class="ko-slot flex-shrink-0 flex items-center justify-center">
                ${d.icon_url ? `
                  <img src="${d.icon_url}" class="w-8 h-8 object-contain drop-shadow" alt="${escapeHtml(d.name)}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                  <div class="w-8 h-8 items-center justify-center text-amber-500/70 text-sm hidden">
                    <i class="fa-solid fa-gem"></i>
                  </div>
                ` : `
                  <div class="w-8 h-8 flex items-center justify-center text-amber-500/70 text-sm">
                    <i class="fa-solid fa-gem"></i>
                  </div>
                `}
              </div>
              <div class="min-w-0">
                <div class="font-bold text-gray-100 truncate">${d.name}</div>
                <div class="text-[10px] text-gray-400 font-mono">ID: ${d.item_id} • Kural #${d.exchange_id}</div>
              </div>
            </div>

            <!-- Hesaplanan Drop Oranı (%) Barı -->
            <div class="w-36 flex flex-col items-center justify-center">
              <div class="flex items-center justify-between w-full text-[11px] font-mono mb-1">
                <span class="text-gray-400 text-[10px]">Şans:</span>
                <span id="drop-pct-${idx}" class="font-bold text-purple-300 font-mono">%${d.percent.toFixed(2)}</span>
              </div>
              <div class="w-full bg-[#1e2636] h-1.5 rounded-full overflow-hidden">
                <div id="drop-bar-${idx}" class="bg-gradient-to-r from-purple-500 to-indigo-500 h-full rounded-full" style="width: ${Math.min(100, Math.max(2, d.percent))}%;"></div>
              </div>
            </div>

            <!-- Ağırlık Inputu & Butonları -->
            <div class="flex items-center space-x-2 flex-1 justify-end">
              <label class="text-[10px] text-gray-400 font-bold">Ağırlık:</label>
              <input type="number" id="drop-weight-${idx}" value="${d.weight}" min="1" step="10"
                     oninput="onChestDropWeightChange(${idx}, this.value)"
                     class="w-24 bg-[#0a0d14] border border-gray-700 rounded px-2 py-1 text-purple-300 font-mono font-bold text-right text-xs focus:outline-none focus:border-purple-500">
              
              <!-- Hızlı Ağırlık Butonları -->
              <div class="hidden sm:flex items-center space-x-1">
                <button onclick="setQuickChestWeight(${idx}, 5000)" class="grade-pill text-[10px] px-1.5 py-0.5">5k</button>
                <button onclick="setQuickChestWeight(${idx}, 2000)" class="grade-pill text-[10px] px-1.5 py-0.5">2k</button>
                <button onclick="setQuickChestWeight(${idx}, 500)" class="grade-pill text-[10px] px-1.5 py-0.5">500</button>
                <button onclick="setQuickChestWeight(${idx}, 100)" class="grade-pill text-[10px] px-1.5 py-0.5">100</button>
                <button onclick="setQuickChestWeight(${idx}, 10)" class="grade-pill text-[10px] px-1.5 py-0.5">10</button>
              </div>

              <!-- Sil Butonu -->
              <button onclick="deleteChestDrop(${d.exchange_id}, '${d.name.replace(/'/g, "\\'")}')" class="p-1.5 rounded bg-red-950/60 hover:bg-red-900 text-red-300 hover:text-white transition ml-2 border border-red-800/40" title="Eşyayı Bu Kutudan Kaldır">
                <i class="fa-solid fa-trash text-xs"></i>
              </button>
            </div>

          </div>
        `;
      }).join('');
    }

    function onChestDropWeightChange(idx, val) {
      const weight = Math.max(1, parseInt(val) || 1);
      selectedChestData.drops[idx].weight = weight;
      
      // Toplam ağırlığı ve oranları anlık yeniden hesapla
      const totalWeight = selectedChestData.drops.reduce((acc, d) => acc + d.weight, 0);
      selectedChestData.chest.total_weight = totalWeight;
      document.getElementById('selected-chest-total-weight').textContent = totalWeight.toLocaleString();

      selectedChestData.drops.forEach((d, i) => {
        d.percent = totalWeight > 0 ? (d.weight / totalWeight * 100.0) : 0;
        const pctEl = document.getElementById(`drop-pct-${i}`);
        const barEl = document.getElementById(`drop-bar-${i}`);
        if (pctEl) pctEl.textContent = `%${d.percent.toFixed(2)}`;
        if (barEl) barEl.style.width = `${Math.min(100, Math.max(2, d.percent))}%`;
      });
    }

    function setQuickChestWeight(idx, weight) {
      const input = document.getElementById(`drop-weight-${idx}`);
      if (input) input.value = weight;
      onChestDropWeightChange(idx, weight);
    }

    async function saveChestDrops() {
      if (!selectedChestId || !selectedChestData) return;
      const btn = document.getElementById('btn-save-chest-drops');
      btn.disabled = true;
      btn.innerHTML = `<i class="fa-solid fa-spinner fa-spin mr-1"></i> Kaydediliyor...`;

      try {
        const payload = {
          drops: selectedChestData.drops.map(d => ({
            exchange_id: d.exchange_id,
            weight: d.weight
          }))
        };

        const res = await fetch(`/api/chests/${selectedChestId}/drops/update`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload)
        });
        const result = await res.json();
        if (result.success) {
          showToast(result.message || 'Kutu drop oranları güncellendi!', 'success');
          selectChest(selectedChestId);
        } else {
          showToast(result.error || 'Kaydetme başarısız!', 'error');
        }
      } catch (err) {
        showToast(`Hata: ${err.message}`, 'error');
      } finally {
        btn.disabled = false;
        btn.innerHTML = `<i class="fa-solid fa-floppy-disk mr-1"></i> Drop Oranlarını Kaydet & Sunucuda Yenile`;
      }
    }

    function openAddChestItemModal() {
      // Eşya arama modalını aç ve hedefi kutu ekleme olarak işaretle
      pickerTargetSlotIndex = -1; // -1 = Kutuya eşya ekleme modu
      document.getElementById('picker-target-slot-label').textContent = `"${selectedChestData?.chest?.name || 'Kutu'}" İçin Yeni Eşya Ekle`;
      document.getElementById('drop-item-picker-modal').classList.remove('hidden');
      document.getElementById('picker-search-query').focus();
    }

    async function addDropItemToChest(itemId, name) {
      if (!selectedChestId) return;
      try {
        const res = await fetch(`/api/chests/${selectedChestId}/drops/add`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ item_id: itemId, weight: 100 })
        });
        const result = await res.json();
        if (result.success) {
          showToast(`"${name}" kutu drop tablosuna eklendi!`, 'success');
          closeDropItemPicker();
          selectChest(selectedChestId);
        } else {
          showToast(result.error || 'Ekleme başarısız!', 'error');
        }
      } catch (err) {
        showToast(`Hata: ${err.message}`, 'error');
      }
    }

    async function deleteChestDrop(exchangeId, name) {
      if (!confirm(`"${name}" eşyasını bu kutudan kaldırmak istediğinize emin misiniz?`)) return;

      try {
        const res = await fetch(`/api/chests/${selectedChestId}/drops/delete`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ exchange_id: exchangeId })
        });
        const result = await res.json();
        if (result.success) {
          showToast(result.message || 'Eşya kaldırıldı!', 'success');
          selectChest(selectedChestId);
        } else {
          showToast(result.error || 'Silme başarısız!', 'error');
        }
      } catch (err) {
        showToast(`Hata: ${err.message}`, 'error');
      }
    }

    // Modal eşya atama fonksiyonunu çift amaçlı yap
    const originalAssignItemToSlot = assignItemToSlot;
    assignItemToSlot = function(num, name, iconUrl) {
      if (pickerTargetSlotIndex === -1) {
        addDropItemToChest(num, name);
      } else {
        originalAssignItemToSlot(num, name, iconUrl);
      }
    };


    // ========================================================
    // --- ⚡ UPGRADE (BASMA) ORANLARI JS FONKSİYONLARI ---
    // ========================================================

    async function loadUpgradeRates() {
      const container = document.getElementById('upgrade-steps-container');
      container.innerHTML = `<div class="col-span-full text-center py-16 text-gray-500 text-xs"><i class="fa-solid fa-spinner fa-spin mr-2"></i>Upgrade oranları yükleniyor...</div>`;

      try {
        const res = await fetch('/api/upgrades');
        upgradeData = await res.json();
        renderUpgradeSteps();
      } catch (err) {
        container.innerHTML = `<div class="col-span-full text-center py-16 text-red-400 text-xs">Yükleme hatası: ${err.message}</div>`;
      }
    }

    function selectUpgradeCategory(catKey) {
      selectedUpgradeCategoryKey = catKey;
      ['bus', 'middle', 'low', 'rebirth', 'accessory'].forEach(k => {
        document.getElementById(`upg-cat-${k}`)?.classList.toggle('active', k === catKey);
      });
      renderUpgradeSteps();
    }

    function renderUpgradeSteps() {
      const container = document.getElementById('upgrade-steps-container');
      const cat = upgradeData ? upgradeData[selectedUpgradeCategoryKey] : null;

      if (!cat || !cat.steps || cat.steps.length === 0) {
        container.innerHTML = `<div class="col-span-full text-center py-16 text-gray-500 text-xs">Bu kategoride upgrade kuralı bulunamadı.</div>`;
        return;
      }

      document.getElementById('upg-current-cat-title').textContent = `${cat.name} (${cat.steps.length} Seviye Kuralı)`;

      container.innerHTML = cat.steps.map((s, idx) => {
        return `
          <div class="bg-[#101622] border border-[#222d3e] hover:border-amber-500/50 rounded-2xl p-4 shadow-xl flex flex-col justify-between space-y-3 transition">
            
            <!-- Başlık & Scroll Adı -->
            <div>
              <div class="flex items-center justify-between">
                <span class="text-sm font-black text-amber-400 font-mono">${s.note}</span>
                <span class="text-[10px] bg-[#172030] text-gray-400 border border-gray-700 px-2 py-0.5 rounded font-mono">${s.count} Eşya</span>
              </div>
              <span class="text-[11px] text-gray-400 block mt-0.5 truncate">${s.scroll}</span>
            </div>

            <!-- Yüzde Göstergesi & Input -->
            <div class="bg-[#0a0d14] border border-[#1e2636] rounded-xl p-3 flex items-center justify-between">
              <div>
                <span class="text-[10px] text-gray-400 font-bold block">Başarı Oranı</span>
                <span id="upg-rate-text-${idx}" class="text-xl font-black text-amber-300 font-mono">%${s.percent.toFixed(1)}</span>
              </div>
              <div class="text-right">
                <span class="text-[10px] text-gray-500 font-mono block">10k Baz Puan</span>
                <span id="upg-basis-text-${idx}" class="text-xs text-gray-400 font-mono font-bold">${s.basis}</span>
              </div>
            </div>

            <!-- Slider & Number Input -->
            <div class="space-y-1.5">
              <input type="range" id="upg-slider-${idx}" min="0" max="100" step="0.5" value="${s.percent}"
                     oninput="onUpgradeRateChange(${idx}, this.value)"
                     class="w-full accent-amber-500 cursor-pointer">
              
              <!-- Hızlı Seçim Butonları -->
              <div class="flex flex-wrap items-center justify-between gap-1 pt-1">
                <button onclick="setQuickUpgradeRate(${idx}, 100)" class="grade-pill text-[10px] px-1.5 py-0.5">%100</button>
                <button onclick="setQuickUpgradeRate(${idx}, 75)" class="grade-pill text-[10px] px-1.5 py-0.5">%75</button>
                <button onclick="setQuickUpgradeRate(${idx}, 50)" class="grade-pill text-[10px] px-1.5 py-0.5">%50</button>
                <button onclick="setQuickUpgradeRate(${idx}, 25)" class="grade-pill text-[10px] px-1.5 py-0.5">%25</button>
                <button onclick="setQuickUpgradeRate(${idx}, 10)" class="grade-pill text-[10px] px-1.5 py-0.5">%10</button>
                <button onclick="setQuickUpgradeRate(${idx}, 1)" class="grade-pill text-[10px] px-1.5 py-0.5">%1</button>
              </div>
            </div>

            <!-- Tekil Kaydet Butonu -->
            <button onclick="saveUpgradeStep(${idx})" id="btn-save-upg-${idx}" class="w-full bg-[#172030] hover:bg-amber-600 text-gray-300 hover:text-black font-bold text-xs py-2 rounded-xl transition border border-[#2b374c] hover:border-amber-500 flex items-center justify-center gap-1.5 shadow">
              <i class="fa-solid fa-check"></i>
              <span>Bu Seviyeyi Kaydet & Uygula</span>
            </button>

          </div>
        `;
      }).join('');
    }

    function onUpgradeRateChange(idx, val) {
      const p = Math.max(0, Math.min(100, parseFloat(val) || 0));
      const basis = Math.round(p * 100);
      const cat = upgradeData[selectedUpgradeCategoryKey];
      if (!cat) return;

      cat.steps[idx].percent = p;
      cat.steps[idx].basis = basis;

      const txt = document.getElementById(`upg-rate-text-${idx}`);
      const basisTxt = document.getElementById(`upg-basis-text-${idx}`);
      const slider = document.getElementById(`upg-slider-${idx}`);

      if (txt) txt.textContent = `%${p.toFixed(1)}`;
      if (basisTxt) basisTxt.textContent = basis;
      if (slider && slider.value != p) slider.value = p;
    }

    function setQuickUpgradeRate(idx, p) {
      onUpgradeRateChange(idx, p);
    }

    async function saveUpgradeStep(idx) {
      const cat = upgradeData[selectedUpgradeCategoryKey];
      if (!cat || !cat.steps[idx]) return;
      const s = cat.steps[idx];

      const btn = document.getElementById(`btn-save-upg-${idx}`);
      if (btn) {
        btn.disabled = true;
        btn.innerHTML = `<i class="fa-solid fa-spinner fa-spin"></i> Kaydediliyor...`;
      }

      try {
        const res = await fetch('/api/upgrades/update', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            scroll: s.scroll,
            note: s.note,
            rate_type: s.rate_type,
            percent: s.percent
          })
        });
        const result = await res.json();
        if (result.success) {
          showToast(result.message || 'Upgrade oranı güncellendi!', 'success');
        } else {
          showToast(result.error || 'Güncelleme başarısız!', 'error');
        }
      } catch (err) {
        showToast(`Hata: ${err.message}`, 'error');
      } finally {
        if (btn) {
          btn.disabled = false;
          btn.innerHTML = `<i class="fa-solid fa-check"></i> Bu Seviyeyi Kaydet & Uygula`;
        }
      }
    }

    async function saveAllCurrentUpgradeCategory() {
      const cat = upgradeData[selectedUpgradeCategoryKey];
      if (!cat || !cat.steps) return;

      let successCount = 0;
      for (let s of cat.steps) {
        try {
          await fetch('/api/upgrades/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              scroll: s.scroll,
              note: s.note,
              rate_type: s.rate_type,
              percent: s.percent
            })
          });
          successCount++;
        } catch (e) {}
      }

      showToast(`Tüm ${cat.name} oranları (${successCount} adım) kaydedildi ve GameServer'da anında yenilendi!`, 'success');
    }

