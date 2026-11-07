/* Existing GM panel extension. Changes are explicit and apply on the next login. */
(() => {
  const style = document.createElement('style');
  style.textContent = '.ce-input{display:block;width:100%;margin-top:.4rem;padding:.6rem .7rem;background:#090d14;color:#e5e7eb;border:1px solid #4b5563;border-radius:.5rem;font-size:.85rem}.ce-input:focus{outline:2px solid #fbbf24;outline-offset:2px}.ce-input:invalid:not(:placeholder-shown){border-color:#f87171}';
  document.head.appendChild(style);
  let snapshot = null, metadata = null, dirty = false, sequence = 0, saving = false;
  const $ = id => document.getElementById(id);
  const fields = [
    ['character-progress-fields', 'level', 'Seviye', 1, 83],
    ['character-progress-fields', 'exp', 'Mevcut EXP', 0, Number.MAX_SAFE_INTEGER],
    ['character-progress-fields', 'points', 'Boş stat puanı', 0, 32767],
    ['character-stat-fields', 'strong', 'STR · Güç', 1, 255],
    ['character-stat-fields', 'sta', 'HP · Dayanıklılık', 1, 255],
    ['character-stat-fields', 'dex', 'DEX · Çeviklik', 1, 255],
    ['character-stat-fields', 'intel', 'INT · Zekâ', 1, 255],
    ['character-stat-fields', 'cha', 'MP · Büyü gücü', 1, 255],
    ['character-skill-fields', 'skill_free', 'Boş skill puanı', 0, 255],
    ['character-skill-fields', 'skill_1', 'Skill dalı 1', 0, 83],
    ['character-skill-fields', 'skill_2', 'Skill dalı 2', 0, 83],
    ['character-skill-fields', 'skill_3', 'Skill dalı 3', 0, 83],
    ['character-skill-fields', 'skill_master', 'Master skill', 0, 23]
  ];
  for (const [parent, key, text, min, max] of fields) {
    const label = document.createElement('label'); label.htmlFor = 'ce-' + key; label.className = 'text-xs text-gray-300'; label.textContent = text;
    const input = document.createElement('input'); Object.assign(input, {id:'ce-' + key, type:'number', min:String(min), max:String(max), step:'1', required:true, className:'ce-input'});
    label.appendChild(input); $(parent).appendChild(label);
  }
  const formKeys = fields.map(f => f[1]).concat(['nation', 'race', 'class_id']);
  function error(message) {
    $('character-editor-error').textContent = message;
    $('character-editor-error').classList.remove('hidden');
    $('character-editor-error').focus();
  }
  function clearError() { $('character-editor-error').classList.add('hidden'); }
  async function request(url, init) {
    const response = await fetch(url, init), data = await response.json();
    if (!response.ok) {
      const detail = Array.isArray(data.detail) ? data.detail.map(e => `${e.loc.slice(1).join('.')}: ${e.msg}`).join('; ') : data.detail;
      throw new Error(detail || 'İşlem tamamlanamadı.');
    }
    return data;
  }
  function options(select, items, value) {
    select.replaceChildren(...items.map(item => {const option = document.createElement('option'); option.value = item.id; option.textContent = item.label; return option;}));
    if (items.some(item => item.id === Number(value))) select.value = value;
  }
  function races(value) {
    const cls = metadata.classes.find(c => c.id === Number($('ce-class_id').value));
    options($('ce-race'), metadata.races.filter(r => cls && cls.races.includes(r.id)), value);
  }
  function classes(value, race) {
    options($('ce-class_id'), metadata.classes.filter(c => c.nation === Number($('ce-nation').value)), value);
    races(race);
  }
  function resetSkills() {
    for (const key of ['skill_1','skill_2','skill_3','skill_master']) $('ce-' + key).value = 0;
    $('ce-skill_free').value = Math.max(0, (Number($('ce-level').value) - 9) * 2);
    dirty = true;
  }
  $('character-editor-form').addEventListener('input', () => { dirty = true; });
  $('ce-nation').addEventListener('change', () => {
    const suffix = Number($('ce-class_id').value) % 100;
    classes(Number($('ce-nation').value) * 100 + suffix);
    resetSkills();
  });
  $('ce-class_id').addEventListener('change', () => { races(); resetSkills(); });
  $('ce-level').addEventListener('change', () => {
    if (snapshot && Number($('ce-level').value) !== snapshot.level) $('ce-exp').value = 0;
    $('character-exp-hint').textContent = 'Seviye değişiminde EXP 0 yapılır. Dilersen kaydetmeden önce düzenleyebilirsin.';
  });
  $('character-reset-skills').addEventListener('click', resetSkills);

  window.loadCharacterEditor = async (force = false) => {
    if (saving) return;
    const name = selectedPlayer?.name;
    if (!name) return;
    if (!force && snapshot?.character === name && (selectedPlayer.is_online || snapshot.is_online)) {
      $('character-editor-fields').disabled = true;
      $('character-editor-status').textContent = selectedPlayer.is_online
        ? `${name} · Hesap çevrimiçi. Kaydetmek için oyundan çıkıp mevcut değerleri yeniden yükleyin.`
        : `${name} · Hesap çevrimdışı oldu. Son kaydı okumak için mevcut değerleri yeniden yükleyin.`;
      snapshot.is_online = true;
      return;
    }
    if (!force && snapshot?.character === name && dirty) return;
    // Background sidebar refresh must not keep replacing a form the user is reading.
    if (!force && snapshot?.character === name) return;
    const id = ++sequence;
    $('character-editor-fields').disabled = true;
    $('character-editor-status').textContent = `${name} için mevcut değerler yükleniyor…`;
    clearError();
    try {
      const [meta, state] = await Promise.all([
        metadata || request('/api/character-editor/options'),
        request('/api/character-editor/' + encodeURIComponent(name))
      ]);
      if (id !== sequence || selectedPlayer?.name !== name) return;
      metadata = meta; snapshot = state; dirty = false;
      for (const key of fields.map(f => f[1])) $('ce-' + key).value = state[key];
      $('ce-nation').value = state.nation; classes(state.class_id, state.race);
      $('character-exp-hint').textContent = state.exp_to_next ? `Sonraki seviye için ${state.exp_to_next.toLocaleString('tr-TR')} EXP gerekiyor.` : '';
      $('character-editor-status').textContent = state.is_online
        ? `${name} · Hesap çevrimiçi. Değerleri inceleyebilirsin; kaydetmek için oyundan çıkıp “Mevcut değerleri yeniden yükle”ye bas.`
        : `${name} · Çevrimdışı. Düzenleyip kaydedebilirsin.`;
      $('character-editor-fields').disabled = state.is_online;
    } catch (e) { if (id === sequence) error(e.message); }
  };
  $('character-editor-reload').addEventListener('click', () => window.loadCharacterEditor(true));
  $('character-editor-form').addEventListener('submit', async event => {
    event.preventDefault(); clearError();
    if (!snapshot || selectedPlayer?.name !== snapshot.character) return error('Önce seçili karakterin mevcut değerlerini yükleyin.');
    if (!$('character-editor-form').reportValidity()) return;
    const payload = {character: snapshot.character, revision: snapshot.revision};
    for (const key of formKeys) {
      const value = Number($('ce-' + key).value);
      if (!Number.isSafeInteger(value)) return error('Alanlara tam sayı girin.');
      payload[key] = value;
    }
    saving = true; $('character-editor-save').disabled = true; $('character-editor-save').textContent = 'Kaydediliyor…';
    try {
      const data = await request('/api/character-editor', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify(payload)});
      snapshot = data.character; dirty = false;
      $('character-editor-status').textContent = data.message + ` İşlem #${data.audit_id}`;
      showToast(data.message);
      await loadCharactersList();
    } catch (e) { error(e.message); }
    finally {
      saving = false; $('character-editor-save').disabled = false; $('character-editor-save').textContent = 'Karakter değişikliklerini kaydet';
      if (snapshot?.character !== selectedPlayer?.name) window.loadCharacterEditor();
    }
  });
})();
