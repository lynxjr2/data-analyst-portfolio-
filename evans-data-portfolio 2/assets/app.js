(() => {
  'use strict';
  const profile = window.PORTFOLIO_PROFILE || {};
  document.querySelectorAll('[data-name]').forEach(el => { el.textContent = profile.name || 'Evans Uwadone'; });
  if (/^[a-z\d](?:[a-z\d-]{0,37}[a-z\d])?$/i.test(profile.githubUsername || '')) {
    const username = encodeURIComponent(profile.githubUsername);
    document.querySelectorAll('[data-github]').forEach(el => {
      el.href = `https://github.com/${username}`;
      el.target = '_blank'; el.rel = 'noopener noreferrer'; el.hidden = false;
    });
  }
  if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(profile.email || '')) {
    document.querySelectorAll('[data-contact]').forEach(el => { el.href = 'mailto:' + profile.email; el.hidden = false; });
  }

  const data = window.PORTFOLIO_DATA;
  if (!data) return;
  const money = value => new Intl.NumberFormat('en-NG', { style:'currency',currency:'NGN',maximumFractionDigits:0 }).format(value);
  const compact = value => value >= 1000000 ? `₦${(value/1000000).toFixed(2)}m` : money(value);
  const percent = value => value === null ? 'n.a.' : `${(value*100).toFixed(1)}%`;
  const int = value => new Intl.NumberFormat('en-NG').format(value);
  const escapeHTML = value => String(value).replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
  const monthNames = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  const text = (id, value, full) => {
    const el = document.getElementById(id);
    if (el) { el.textContent=value; if(full) el.title=full; }
  };

  function summarize(transactions, city='All', category='All') {
    const chosen = transactions.filter(t => (city==='All'||t.city===city) && (category==='All'||t.category===category));
    const months = monthNames.map((label,i)=>({label,key:`2025-${String(i+1).padStart(2,'0')}`,revenue:0,profit:0,count:0,returned:0}));
    const categories = ['Electronics','Fashion','Beauty','Home'].map(label=>({label,revenue:0}));
    let revenue=0,profit=0,returned=0;
    for(const t of chosen) {
      revenue+=t.revenue; profit+=t.profit; returned+=Number(t.returned);
      const m=months.find(m=>m.key===t.date.slice(0,7));
      if(m) { m.revenue+=t.revenue; m.profit+=t.profit; m.count++; m.returned+=Number(t.returned); }
      const c=categories.find(c=>c.label===t.category);
      if(c) c.revenue+=t.revenue;
    }
    categories.sort((a,b)=>b.revenue-a.revenue);
    return {revenue,profit,returned,count:chosen.length,completed:chosen.length-returned,
      margin:revenue===0?null:profit/revenue,returnRate:chosen.length===0?null:returned/chosen.length,
      months,categories};
  }

  const hero = document.getElementById('hero-chart');
  if(hero) {
    const series=data.summary.monthly;
    const top=Math.ceil(Math.max(...series.map(m=>m.net_revenue_ngn))/1000000)*1000000;
    const points=series.map((m,i)=>`${12+i*32.4},${118-m.net_revenue_ngn/top*105}`).join(' ');
    const last=series[series.length-1];
    hero.innerHTML=`<svg viewBox="0 0 382 126" preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M0 118H382M0 65H382M0 12H382" stroke="#29445c" stroke-width=".7" stroke-dasharray="3 4"/><polyline points="${points}" fill="none" stroke="#5eead4" stroke-width="2.5" stroke-linejoin="round"/><circle cx="368.4" cy="${118-last.net_revenue_ngn/top*105}" r="4" fill="#5eead4"/></svg>`;
    text('hero-revenue',compact(data.summary.overview.net_revenue_ngn),money(data.summary.overview.net_revenue_ngn));
  }

  function renderDashboard() {
    const city=document.getElementById('city-filter').value;
    const category=document.getElementById('category-filter').value;
    const s=summarize(data.transactions,city,category);
    text('filter-scope',`2025 · ${city==='All'?'All cities':city} · ${category==='All'?'All categories':category}`);
    text('metric-revenue',compact(s.revenue),money(s.revenue));
    text('metric-profit',compact(s.profit),money(s.profit));
    text('metric-margin',percent(s.margin));
    text('metric-return',percent(s.returnRate));
    text('metric-return-count',`${int(s.returned)} of ${int(s.count)} transactions`);
    text('transaction-count',`${int(s.completed)} completed transactions`);
    const scale=Math.max(1000000,Math.ceil(Math.max(...s.months.map(m=>m.revenue))/1000000)*1000000);
    const chart=document.getElementById('monthly-chart');
    chart.setAttribute('aria-label',`Monthly net revenue. ${city==='All'?'All cities':city}. ${category==='All'?'All categories':category}. Values are available in the monthly figures table.`);
    chart.innerHTML=s.months.map(m=>`<div class="month-bar" title="${escapeHTML(m.label+' 2025: '+money(m.revenue))}"><div class="bar" style="height:${m.revenue/scale*100}%"></div><span class="month-label">${m.label}</span></div>`).join('');
    document.getElementById('monthly-axis').innerHTML=[scale,scale*2/3,scale/3,0].map(n=>`<span>${(n/1000000).toFixed(1)}</span>`).join('');
    const categoryMax=Math.max(...s.categories.map(c=>c.revenue),1);
    document.getElementById('category-chart').innerHTML=s.categories.map(c=>`<div class="category-row"><div class="category-label"><span>${escapeHTML(c.label)}</span><strong title="${escapeHTML(money(c.revenue))}">${compact(c.revenue)}</strong></div><div class="category-track" aria-hidden="true"><div class="category-fill" style="width:${c.revenue/categoryMax*100}%"></div></div></div>`).join('');
    document.getElementById('monthly-table').innerHTML=s.months.map(m=>`<tr><th scope="row">${m.label} 2025</th><td>${money(m.revenue)}</td><td>${money(m.profit)}</td><td>${int(m.count)}</td><td>${int(m.returned)}</td></tr>`).join('');
    document.getElementById('reset-filters').disabled=city==='All'&&category==='All';
  }
  window.PortfolioAnalysis={summarize};
  if(document.getElementById('city-filter')) {
    document.getElementById('city-filter').addEventListener('change',renderDashboard);
    document.getElementById('category-filter').addEventListener('change',renderDashboard);
    document.getElementById('reset-filters').addEventListener('click',()=>{
      document.getElementById('city-filter').value='All';document.getElementById('category-filter').value='All';renderDashboard();
    });
    renderDashboard();
  }
})();
