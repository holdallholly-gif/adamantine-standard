(function(){
  const $status = document.getElementById('status');
  const $tbody = document.querySelector('#log tbody');

  function row(obj){
    const tr = document.createElement('tr');
    const td = (t)=>{ const x = document.createElement('td'); x.innerText = t; return x; };
    const yn = (v)=> v === true ? 'YES' : (v === false ? 'NO' : '');

    tr.appendChild(td(obj.utc || ''));
    tr.appendChild(td(obj.doc || ''));
    tr.appendChild(td(obj.sha256 || ''));
    tr.appendChild(td(obj.expected || ''));
    const me = yn(obj.match_expected);
    const ml = yn(obj.match_ledger);
    const tdMe = td(me); tdMe.className = (me==='YES'?'ok':(me==='NO'?'fail':'')); tr.appendChild(tdMe);
    const tdMl = td(ml); tdMl.className = (ml==='YES'?'ok':(ml==='NO'?'fail':'')); tr.appendChild(tdMl);
    tr.appendChild(td(obj.tool || ''));
    return tr;
  }

  fetch('repro_log.jsonl', {cache: 'no-store'})
    .then(r => r.text())
    .then(txt => {
      $status.textContent = '';
      const lines = txt.trim().split(/\r?\n/).filter(Boolean);
      if(!lines.length){ $status.textContent = 'No verification events logged yet.'; return; }
      const events = lines.map(l => { try { return JSON.parse(l); } catch(e){ return null; } }).filter(Boolean);
      events.forEach(obj => $tbody.appendChild(row(obj)));
    })
    .catch(err => {
      $status.textContent = 'Failed to load verification log.';
      console.error(err);
    });
})();