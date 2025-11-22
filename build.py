from pathlib import Path
from textwrap import dedent

lines = []

lines += [
    '<!DOCTYPE html>',
    '<html lang="en">',
    '<head>',
    '<meta charset="UTF-8">',
    '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
    '<title>Star Wars Tactical Datapad</title>',
]
css = dedent('''
/* condensed CSS (see earlier) */
:root { --bg:#070a12; --panel:#0f1624; --accent:#38bdf8; --accent-2:#00f6ff; --accent-3:#6ee7ff; --danger:#ff4d6d; --success:#00f59d; --warning:#ffcc00; --text:#e5f4ff; --muted:#8aa3bf; --holo-border:rgba(99,255,255,0.35); --grid:rgba(56,189,248,0.06); --card:rgba(15,22,36,0.7); --card-strong:rgba(15,22,36,0.9); --glass:rgba(255,255,255,0.03); --blur:blur(24px); --font:'Orbitron','Rajdhani','Segoe UI',sans-serif; }
*{box-sizing:border-box;font-family:var(--font);letter-spacing:0.02em;}
body{margin:0;min-height:100vh;background:radial-gradient(circle at 10% 10%,rgba(56,189,248,0.08),transparent 20%),radial-gradient(circle at 80% 30%,rgba(0,245,157,0.06),transparent 26%),radial-gradient(circle at 30% 70%,rgba(255,77,109,0.05),transparent 24%),var(--bg);color:var(--text);overflow-x:hidden;}
.matrix-grid{position:fixed;inset:0;background-image:linear-gradient(var(--grid) 1px,transparent 1px),linear-gradient(90deg,var(--grid) 1px,transparent 1px);background-size:70px 70px;pointer-events:none;mix-blend-mode:screen;opacity:0.35;animation:drift 40s linear infinite;z-index:0;}
@keyframes drift{0%{transform:translate3d(0,0,0);}50%{transform:translate3d(10px,-12px,0);}100%{transform:translate3d(0,0,0);}}
header{position:sticky;top:0;z-index:10;padding:16px 24px;background:linear-gradient(180deg,rgba(7,10,18,0.9) 0%,rgba(7,10,18,0.5) 100%);backdrop-filter:blur(12px);display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid var(--holo-border);box-shadow:0 8px 30px rgba(0,0,0,0.45);} 
.brand{display:flex;align-items:center;gap:12px;} .brand-icon{width:44px;height:44px;border-radius:50%;border:2px solid var(--accent);background:radial-gradient(circle,rgba(56,189,248,0.25),rgba(7,10,18,0.9));display:grid;place-items:center;box-shadow:0 0 22px rgba(0,255,255,0.25);} 
.brand-title{font-size:20px;text-transform:uppercase;color:var(--accent);text-shadow:0 0 16px rgba(56,189,248,0.8);letter-spacing:0.08em;}
.meta{display:flex;gap:18px;align-items:center;color:var(--muted);font-size:13px;}
.holo-button{padding:10px 14px;border:1px solid var(--holo-border);color:var(--accent-3);background:linear-gradient(120deg,rgba(56,189,248,0.12),rgba(0,245,157,0.12));border-radius:10px;text-transform:uppercase;font-size:12px;letter-spacing:0.08em;cursor:pointer;box-shadow:0 0 12px rgba(0,255,255,0.25);transition:0.2s ease;}
.holo-button:hover{box-shadow:0 0 18px rgba(0,245,157,0.35);transform:translateY(-2px);border-color:var(--accent-3);} 
.layout{display:grid;grid-template-columns:280px 1fr;min-height:calc(100vh - 80px);position:relative;z-index:1;} 
nav{border-right:1px solid var(--holo-border);background:linear-gradient(180deg,rgba(15,22,36,0.9),rgba(7,10,18,0.8));padding:20px 12px;backdrop-filter:var(--blur);} 
.nav-section{margin-bottom:18px;} .nav-title{font-size:13px;text-transform:uppercase;color:var(--muted);padding:0 12px;letter-spacing:0.12em;margin-bottom:8px;} 
.nav-item{display:flex;align-items:center;gap:10px;padding:12px 14px;margin-bottom:6px;border-radius:12px;color:var(--text);cursor:pointer;transition:0.2s ease;border:1px solid transparent;background:transparent;position:relative;overflow:hidden;} 
.nav-item::after{content:'';position:absolute;inset:0;background:linear-gradient(120deg,rgba(56,189,248,0.08),rgba(0,245,157,0.08));opacity:0;transition:0.25s ease;pointer-events:none;} 
.nav-item.active,.nav-item:hover{border-color:var(--holo-border);box-shadow:inset 0 0 0 1px rgba(56,189,248,0.12);transform:translateX(4px);} 
.nav-item.active::after,.nav-item:hover::after{opacity:1;} 
.nav-icon{width:36px;height:36px;border-radius:10px;background:rgba(56,189,248,0.15);display:grid;place-items:center;border:1px solid rgba(56,189,248,0.2);box-shadow:0 0 14px rgba(56,189,248,0.25) inset;font-size:15px;} 
.nav-label{flex:1;font-weight:600;} .nav-pill{padding:4px 8px;border-radius:999px;font-size:11px;background:rgba(0,245,157,0.16);color:var(--success);border:1px solid rgba(0,245,157,0.3);} 
.workspace{padding:18px 22px 32px 22px;position:relative;overflow:hidden;}
/* ...many more styles continue below ... */
''')
lines.append('<style>')
lines.append(css)
lines.append('</style>')
lines += [
    '</head>',
    '<body>',
    '<div class="matrix-grid"></div>',
    '<div class="floating-orbs"><div class="orb" style="left:10%;top:18%;"></div><div class="orb" style="top:60%;"></div><div class="orb" style="top:30%;"></div></div>',
    '<header><div class="brand"><div class="brand-icon">✦</div><div><div class="brand-title">Imperial/Republic Datapad</div><div class="meta">Galactic Tactical Operations Mesh</div></div></div><div class="meta"><div class="badge">Sector: Outer Rim</div><div class="badge">Encryption: Quantum Lattice</div><button class="holo-button" onclick="openModal(\'quick-actions\')">Quick Actions</button></div></header>',
]
layout_block = dedent('''
<div class="layout">
  <nav>
    <div class="nav-section">
      <div class="nav-title">Navigation</div>
      <div class="nav-item active" onclick="switchPanel('overview')"><div class="nav-icon">🏠</div><div class="nav-label">Command Overview</div><div class="nav-pill">Live</div></div>
      <div class="nav-item" onclick="switchPanel('reports')"><div class="nav-icon">📝</div><div class="nav-label">Incident Reports</div><div class="nav-pill">+3</div></div>
      <div class="nav-item" onclick="switchPanel('messaging')"><div class="nav-icon">📡</div><div class="nav-label">Comms & Contacts</div></div>
      <div class="nav-item" onclick="switchPanel('regiments')"><div class="nav-icon">🪖</div><div class="nav-label">Regiment Mgmt</div></div>
      <div class="nav-item" onclick="switchPanel('holonet')"><div class="nav-icon">🛰️</div><div class="nav-label">HoloNet Feed</div></div>
      <div class="nav-item" onclick="switchPanel('minigames')"><div class="nav-icon">🎮</div><div class="nav-label">Starfighter Minigames</div></div>
      <div class="nav-item" onclick="switchPanel('announcements')"><div class="nav-icon">📢</div><div class="nav-label">Announcements</div></div>
      <div class="nav-item" onclick="switchPanel('analytics')"><div class="nav-icon">📊</div><div class="nav-label">Telemetry & Logs</div></div>
    </div>
  </nav>
  <main class="workspace">
    <section class="panel" id="overview-panel">
      <div class="holo-card">
        <div class="pulse"></div>
        <div class="title-row"><h2>Command Situation</h2><div class="flex"><span class="badge">Hypersync</span><button class="holo-button" onclick="simulateSync()">Sync Now</button></div></div>
        <div class="card-grid">
          <div class="stat"><div class="stat-label">Active Units</div><div class="stat-value" id="active-units">128</div><div class="muted">Includes Infantry, Armor, SpecOps, Pilots.</div></div>
          <div class="stat"><div class="stat-label">Readiness</div><div class="stat-value" id="readiness">92%</div><div class="muted">Calculated from duty rosters, ammo, morale.</div></div>
          <div class="stat"><div class="stat-label">Fleet Uptime</div><div class="stat-value" id="uptime">99.4%</div><div class="muted">Maintenance cycles and hyperdrive calibrations.</div></div>
          <div class="stat"><div class="stat-label">HoloMail Queue</div><div class="stat-value" id="mail">47</div><div class="muted">Awaiting triage by comms officers.</div></div>
        </div>
        <div class="systems">
          <div class="system"><div class="system-label">Planetary Shield</div><div class="system-value">92% • Stable</div><div class="progress"><div class="progress-bar" style="width:92%"></div></div></div>
          <div class="system"><div class="system-label">Ion Cannon Grid</div><div class="system-value">78% • Cycling</div><div class="progress"><div class="progress-bar" style="width:78%"></div></div></div>
          <div class="system"><div class="system-label">Comms Relays</div><div class="system-value">99% • Secured</div><div class="progress"><div class="progress-bar" style="width:99%"></div></div></div>
          <div class="system"><div class="system-label">Supply Corridors</div><div class="system-value">88% • Flowing</div><div class="progress"><div class="progress-bar" style="width:88%"></div></div></div>
        </div>
      </div>
      <div class="card-grid">
        <div class="holo-card">
          <div class="title-row"><h2>Live Alerts</h2><button class="holo-button" onclick="generateAlert()">Inject Alert</button></div>
          <div class="logs" id="alert-log"></div>
        </div>
        <div class="holo-card">
          <div class="title-row"><h2>Timeline</h2><span class="muted">Sorted by priority</span></div>
          <div class="timeline" id="timeline"></div>
        </div>
      </div>
    </section>
    <section class="panel" id="reports-panel" style="display:none;">
      <div class="holo-card">
        <div class="title-row"><h2>File an Incident Report</h2><div class="flex"><span class="badge">Encrypted</span><button class="holo-button" onclick="saveReport()">Save Draft</button></div></div>
        <div class="two-col">
          <div><label class="muted">Incident Title</label><input class="input" id="report-title" placeholder="e.g. Skirmish at Docking Bay 94"></div>
          <div><label class="muted">Regiment</label><select id="report-regiment" class="input"></select></div>
          <div><label class="muted">Location</label><input class="input" id="report-location" placeholder="Mos Eisley, Tatooine"></div>
          <div><label class="muted">Severity</label><select id="report-severity" class="input"><option>Low</option><option>Medium</option><option>High</option><option>Critical</option></select></div>
        </div>
        <div class="divider"></div>
        <label class="muted">Summary</label>
        <textarea id="report-summary" placeholder="Detail troop movements, casualties, objectives..."></textarea>
        <div class="divider"></div>
        <div class="two-col">
          <div><label class="muted">Attachments (fictional)</label><input class="input" placeholder="Link to helmet cam, probe droid feed..."></div>
          <div><label class="muted">Notify</label><input class="input" placeholder="Tag officers to notify upon submission"></div>
        </div>
        <div class="toolbar">
          <button onclick="submitReport()">Submit to High Command</button>
          <button onclick="openModal('templates')">Load Template</button>
          <button onclick="injectReportLore()">Auto-fill Narrative</button>
        </div>
      </div>
      <div class="holo-card">
        <div class="title-row"><h2>Report Archive</h2><span class="muted">Searchable, filterable, exportable</span></div>
        <div class="two-col">
          <input class="input" id="report-search" placeholder="Search by title, author, regiment..." oninput="filterReports()">
          <select class="input" id="report-filter" onchange="filterReports()"><option value="all">All Severities</option><option value="Low">Low</option><option value="Medium">Medium</option><option value="High">High</option><option value="Critical">Critical</option></select>
        </div>
        <div class="divider"></div>
        <div class="list" id="report-list"></div>
      </div>
    </section>
''')
lines.append(layout_block)
more_block = dedent('''
    <section class="panel" id="messaging-panel" style="display:none;">
      <div class="holo-card">
        <div class="title-row"><h2>Encrypted Messaging</h2><div class="flex"><span class="badge">Quantum Salted</span><button class="holo-button" onclick="simulateMessage()">Inject Message</button></div></div>
        <div class="two-col">
          <div><label class="muted">Recipient</label><select id="message-recipient" class="input"></select></div>
          <div><label class="muted">Channel</label><select id="message-channel" class="input"><option>Direct</option><option>Squad Broadcast</option><option>Regiment Bulletin</option><option>Fleet Wide</option></select></div>
        </div>
        <label class="muted">Message</label>
        <textarea id="message-body" placeholder="Compose encrypted datapacket..."></textarea>
        <div class="toolbar">
          <button onclick="sendMessage()">Send</button>
          <button onclick="openModal('contacts')">Manage Contacts</button>
          <button onclick="openModal('hololog')">Open Message Log</button>
        </div>
      </div>
      <div class="card-grid">
        <div class="holo-card">
          <div class="title-row"><h2>Contacts</h2><button class="holo-button" onclick="openModal('contacts')">Add Contact</button></div>
          <div class="list" id="contact-list"></div>
        </div>
        <div class="holo-card">
          <div class="title-row"><h2>Live Comms</h2><span class="muted">Quantum entangled channels</span></div>
          <div class="logs" id="message-log"></div>
        </div>
      </div>
    </section>
    <section class="panel" id="regiments-panel" style="display:none;">
      <div class="holo-card">
        <div class="title-row"><h2>Regiment Command</h2><button class="holo-button" onclick="addRegiment()">Create Regiment</button></div>
        <div class="grid-3" id="regiment-grid"></div>
      </div>
      <div class="holo-card">
        <div class="title-row"><h2>Roster</h2><span class="muted">Assign billets, promotions, duties</span></div>
        <table class="table" id="roster-table"><thead><tr><th>Name</th><th>Regiment</th><th>Role</th><th>Status</th><th>Loadout</th></tr></thead><tbody></tbody></table>
      </div>
    </section>
    <section class="panel" id="holonet-panel" style="display:none;">
      <div class="holo-card">
        <div class="title-row"><h2>HoloNet Stream</h2><button class="holo-button" onclick="postHolonet()">Broadcast</button></div>
        <div class="holonet">
          <div><div id="holonet-feed"></div></div>
          <div>
            <div class="announcement"><small>Trending Channel</small><h3>Outer Rim Dispatch</h3><p>Live coverage of the skirmish near the Dune Sea, sandstorms interfering with walker optics. Expect intermittent comms.</p></div>
            <div class="divider"></div>
            <div class="status-grid">
              <div class="status-panel"><div class="status-title">Holonet Status</div><p class="status-value">Operational</p><div class="muted">Quantum relays stable</div></div>
              <div class="status-panel"><div class="status-title">Engagement Ratio</div><p class="status-value">218k</p><div class="muted">Views, boosts, relays</div></div>
              <div class="status-panel"><div class="status-title">Hashtag Density</div><p class="status-value">#LongLiveTheEmpire</p><div class="muted">Holo trending phrase</div></div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <section class="panel" id="minigames-panel" style="display:none;">
      <div class="holo-card">
        <div class="title-row"><h2>Starfighter Minigames</h2><button class="holo-button" onclick="launchMiniGame()">Launch Random</button></div>
        <div class="game-grid" id="game-grid"></div>
      </div>
    </section>
    <section class="panel" id="announcements-panel" style="display:none;">
      <div class="holo-card">
        <div class="title-row"><h2>Announcements</h2><button class="holo-button" onclick="openModal('announce')">Create Announcement</button></div>
        <div class="list" id="announcement-list"></div>
      </div>
    </section>
    <section class="panel" id="analytics-panel" style="display:none;">
      <div class="holo-card">
        <div class="title-row"><h2>Telemetry & Logs</h2><button class="holo-button" onclick="simulateTelemetry()">Simulate Packet</button></div>
        <div class="two-col"><div class="chart"><div class="chart-line"></div><div class="chart-pulse"></div></div><div><div class="mini-log" id="telemetry-log"></div></div></div>
      </div>
    </section>
  </main>
</div>
''')
lines.append(more_block)
modals = dedent('''
<div class="modal" id="quick-actions-modal"><div class="modal-content"><button class="modal-close" onclick="closeModal('quick-actions')">✕</button><h3>Quick Actions</h3><div class="holo-keys"><div class="holo-key" onclick="simulateSync()">Fleet Sync</div><div class="holo-key" onclick="openModal('templates')">Load Report Template</div><div class="holo-key" onclick="generateAlert()">Generate Alert</div><div class="holo-key" onclick="simulateMessage()">Ping Commander</div><div class="holo-key" onclick="launchMiniGame()">Launch Game</div><div class="holo-key" onclick="simulateTelemetry()">Telemetry Pulse</div></div><div class="floating-hints"><div class="hint">Use HoloNet feed as in-universe Twitter clone with boosts, relays, encrypted DMs.</div><div class="hint">Regiment management supports squads, schedules, loadouts, morale, and chain-of-command overrides.</div><div class="hint">Minigames are diegetic training simulations: trench run, astromech hacking, beskad duels.</div></div></div></div>
<div class="modal" id="templates-modal"><div class="modal-content"><button class="modal-close" onclick="closeModal('templates')">✕</button><h3>Report Templates</h3><div class="list" id="template-list"></div></div></div>
<div class="modal" id="contacts-modal"><div class="modal-content"><button class="modal-close" onclick="closeModal('contacts')">✕</button><h3>Contact Manager</h3><div class="two-col"><input class="input" id="contact-name" placeholder="Name / Callsign"><input class="input" id="contact-role" placeholder="Role / Regiment"></div><div class="toolbar"><button onclick="addContact()">Add Contact</button><button onclick="seedContacts()">Seed Random</button></div><div class="list" id="contact-modal-list"></div></div></div>
<div class="modal" id="hololog-modal"><div class="modal-content"><button class="modal-close" onclick="closeModal('hololog')">✕</button><h3>Message Log</h3><div class="logs" id="full-message-log"></div></div></div>
<div class="modal" id="announce-modal"><div class="modal-content"><button class="modal-close" onclick="closeModal('announce')">✕</button><h3>Create Announcement</h3><input class="input" id="announce-title" placeholder="Title"><textarea id="announce-body" placeholder="Broadcast to all regiments..."></textarea><div class="toolbar"><button onclick="createAnnouncement()">Broadcast</button></div></div></div>
''')
lines.append(modals)
script_block = dedent('''
<script>
const regiments=[{name:'501st Legion',color:'#4dd0ff',doctrine:'Shock Troopers',morale:92,readiness:95},{name:'104th Wolfpack',color:'#b3ffea',doctrine:'Recon & Support',morale:88,readiness:89},{name:'Coruscant Guard',color:'#ff7d9d',doctrine:'Military Police',morale:90,readiness:91},{name:'212th Attack Battalion',color:'#ffd166',doctrine:'Airborne Infantry',morale:86,readiness:87},{name:'First Order SpecOps',color:'#9ae6b4',doctrine:'Covert Ops',morale:93,readiness:94},{name:'Mandalorian Cohort',color:'#fbbf24',doctrine:'Beskad Duelists',morale:95,readiness:90}];
const roster=[{name:'CT-7567 Rex',regiment:'501st Legion',role:'Captain',status:'Active',loadout:'DC-17, Jetpack'},{name:'CC-3636 Wolffe',regiment:'104th Wolfpack',role:'Commander',status:'Active',loadout:'DC-17m'},{name:'Fox',regiment:'Coruscant Guard',role:'Commander',status:'Guard Duty',loadout:'Z-6'},{name:'Waxer',regiment:'212th Attack Battalion',role:'Trooper',status:'Field',loadout:'DC-15A'},{name:'Bo-Katan Kryze',regiment:'Mandalorian Cohort',role:'Alor',status:'Active',loadout:'Dual Westars'},{name:'Arc Trooper Fives',regiment:'501st Legion',role:'ARC',status:'SpecOps',loadout:'DC-17m'},{name:'First Order Agent',regiment:'First Order SpecOps',role:'Operative',status:'Recon',loadout:'SE-44C'},{name:'Echo',regiment:'501st Legion',role:'ARC',status:'Active',loadout:'DC-17m'}];
const reports=[{id:1,title:'Docking Bay 94 Skirmish',regiment:'501st Legion',severity:'High',summary:'Short engagement with smugglers, secured cargo.',author:'CT-7567 Rex',timestamp:'12:04 Coruscant Standard'},{id:2,title:'Checkpoint Riot',regiment:'Coruscant Guard',severity:'Medium',summary:'Civilians unrest contained, no casualties.',author:'Fox',timestamp:'10:44 Coruscant Standard'},{id:3,title:'Dune Sea Patrol',regiment:'212th Attack Battalion',severity:'Low',summary:'Sandstorm interference, recovered sensor array.',author:'Waxer',timestamp:'08:15 Local Tatooine'}];
const messages=[];const contacts=[{name:'Obi-Wan Kenobi',role:'Jedi General',channel:'Direct'},{name:'Ahsoka Tano',role:'Advisor',channel:'Direct'},{name:'Admiral Yularen',role:'Fleet Command',channel:'Fleet Wide'}];
const templates=[{title:'Patrol Debrief',body:'Patrol route, anomalies detected, engagements, intel secured, casualties, ordnance expenditure, recommendations.'},{title:'Forward Operating Base Sitrep',body:'FOB status, supply chain, casualty report, morale, defensive grid, radar/sonar sweeps.'},{title:'Covert Ops After Action',body:'Objective, infiltration method, stealth integrity, data exfil, countermeasures, extraction, notes.'}];
const games=[{title:'Trench Run Simulator',desc:'Navigate Death Star trenches, avoid turbolasers.',progress:56},{title:'Astromech Slice',desc:'Rotate holocylinders to crack security nodes.',progress:72},{title:'Saber Forms',desc:'Practice Form III deflections vs remote droids.',progress:44},{title:'Beskad Duel',desc:'Parry timing trainer for Mandalorian duelists.',progress:33},{title:'Podrace Dash',desc:'Boost through canyon checkpoints.',progress:81},{title:'Interceptor Drill',desc:'TIE/IN evasive maneuvers.',progress:66}];
const holonetFeed=[{author:'Holonet News',content:'Breaking: Imperial supply convoy departs Kuat. Escort wings scrambled.',tags:['#Logistics','#Empire'],time:'2m'},{author:'Clanker Tracker',content:'Separatist droids spotted near abandoned temple ruins on Jedha.',tags:['#Recon','#Alert'],time:'8m'},{author:'Cantina Insider',content:'Rumors of high-stakes sabacc on Nar Shaddaa tonight. Winner takes a Corellian Corvette.',tags:['#Gossip','#Underworld'],time:'12m'}];
const announcements=[{title:'Fleet Briefing 1900',body:'All regimental COs report to bridge. Holotables updated with rebel vectors.',author:'Admiral Yularen',time:'Now'},{title:'Barracks Sanitation',body:'Standard decon sweep. Remove all unauthorized equipment from bunks.',author:'Quartermaster',time:'1h'},{title:'Jedi Liaison',body:'Knight Secura available for consultation on Geonosis fauna behavior.',author:'Council Dispatch',time:'3h'}];
let alertLog=[];let timeline=[{title:'Recon sweep launched',detail:'Probe droids deployed to valley grid 7',time:'02:03'},{title:'Fuel cells secured',detail:'Hangar 12 restocked',time:'01:44'},{title:'Encrypted packet received',detail:'Slicing in progress',time:'01:23'}];
function switchPanel(id){document.querySelectorAll('.panel').forEach(p=>p.style.display='none');document.getElementById(id+'-panel').style.display='block';}
function renderRegiments(){const grid=document.getElementById('regiment-grid');grid.innerHTML='';regiments.forEach(reg=>{const card=document.createElement('div');card.className='game-card';card.style.borderColor=reg.color;card.innerHTML=`<div class="game-title" style="color:${reg.color}">${reg.name}</div><div class="game-meta">${reg.doctrine}</div><div class="progress"><div class="progress-bar" style="width:${reg.readiness}%"></div></div><div class="flex" style="justify-content: space-between;"><span class="pill">Morale ${reg.morale}%</span><span class="pill">Readiness ${reg.readiness}%</span></div>`;grid.appendChild(card);});}
function renderRoster(){const tbody=document.querySelector('#roster-table tbody');tbody.innerHTML='';roster.forEach(s=>{const tr=document.createElement('tr');tr.innerHTML=`<td>${s.name}</td><td>${s.regiment}</td><td>${s.role}</td><td><span class="badge ${s.status==='Active'?'':'badge-warning'}">${s.status}</span></td><td>${s.loadout}</td>`;tbody.appendChild(tr);});}
function renderReports(list=reports){const container=document.getElementById('report-list');container.innerHTML='';list.forEach(r=>{const item=document.createElement('div');item.className='list-item';item.innerHTML=`<div class="avatar">${r.author.split(' ')[0][0]}${r.author.split(' ')[1]?.[0]||''}<div class="shield"></div></div><div style="flex:1;"><div class="flex" style="justify-content: space-between;"><h4 class="subtitle">${r.title}</h4><span class="badge ${r.severity==='Critical'?'badge-danger':''}">${r.severity}</span></div><div class="muted">${r.regiment} • ${r.author}</div><div class="timestamp">${r.timestamp}</div><div class="divider"></div><div>${r.summary}</div></div>`;container.appendChild(item);});}
function renderContacts(){const select=document.getElementById('message-recipient');const list=document.getElementById('contact-list');const modalList=document.getElementById('contact-modal-list');select.innerHTML='';list.innerHTML='';modalList.innerHTML='';contacts.forEach(c=>{const opt=document.createElement('option');opt.textContent=`${c.name} (${c.role})`;select.appendChild(opt);const item=document.createElement('div');item.className='list-item';item.innerHTML=`<div class="avatar">${c.name[0]}</div><div style="flex:1;"><div class="flex" style="justify-content: space-between;"><h4 class="subtitle">${c.name}</h4><span class="pill">${c.channel}</span></div><div class="muted">${c.role}</div></div>`;list.appendChild(item);modalList.appendChild(item.cloneNode(true));});}
function renderTemplates(){const list=document.getElementById('template-list');list.innerHTML='';templates.forEach(t=>{const item=document.createElement('div');item.className='list-item';item.innerHTML=`<div style="flex:1;"><h4 class="subtitle">${t.title}</h4><div class="muted">${t.body}</div></div><button class="holo-button" onclick="loadTemplate('${t.title.replace("'",'')}')">Load</button>`;list.appendChild(item);});}
function renderGames(){const grid=document.getElementById('game-grid');grid.innerHTML='';games.forEach(g=>{const card=document.createElement('div');card.className='game-card';card.innerHTML=`<h4 class="game-title">${g.title}</h4><div class="game-meta">${g.desc}</div><div class="progress"><div class="progress-bar" style="width:${g.progress}%"></div></div><div class="flex" style="justify-content: space-between; margin-top:8px;"><span class="tag">Sim Grade</span><span class="pill">${g.progress}%</span></div>`;grid.appendChild(card);});}
function renderHolonet(){const feed=document.getElementById('holonet-feed');feed.innerHTML='';holonetFeed.forEach(p=>{const post=document.createElement('div');post.className='post';post.innerHTML=`<div class="flex" style="justify-content: space-between;"><h4>${p.author}</h4><span class="timestamp">${p.time}</span></div><div>${p.content}</div><div class="flex" style="margin-top:6px;">${p.tags.map(t=>`<span class="tag">${t}</span>`).join('')}</div><div class="meta-line"><span>Boosts ${Math.floor(Math.random()*400)+20}</span><span>Relays ${Math.floor(Math.random()*300)+10}</span></div>`;feed.appendChild(post);});}
function renderAnnouncements(){const list=document.getElementById('announcement-list');list.innerHTML='';announcements.forEach(a=>{const item=document.createElement('div');item.className='announcement';item.innerHTML=`<small>${a.time}</small><h3>${a.title}</h3><p>${a.body}</p><div class="muted">${a.author}</div>`;list.appendChild(item);});}
function renderTimeline(){const t=document.getElementById('timeline');t.innerHTML='';timeline.forEach(entry=>{const item=document.createElement('div');item.className='timeline-item';item.innerHTML=`<h4 class="subtitle">${entry.title}</h4><div class="muted">${entry.detail}</div><div class="timestamp">${entry.time}</div>`;t.appendChild(item);});}
function renderTelemetry(){const log=document.getElementById('telemetry-log');log.innerHTML=alertLog.slice(-12).map(l=>`[${l.time}] ${l.message}`).join('\n');}
function renderMessages(){const log=document.getElementById('message-log');const full=document.getElementById('full-message-log');log.innerHTML=messages.slice(-8).map(m=>`<div class="log-entry">[${m.time}] ${m.from} -> ${m.to}: ${m.body}</div>`).join('');full.innerHTML=messages.map(m=>`<div class="log-entry">[${m.time}] ${m.from} -> ${m.to} (${m.channel}): ${m.body}</div>`).join('');}
function filterReports(){const q=document.getElementById('report-search').value.toLowerCase();const severity=document.getElementById('report-filter').value;if(!q && severity==='all'){renderReports();return;}const filtered=reports.filter(r=>{const match=r.title.toLowerCase().includes(q)||r.author.toLowerCase().includes(q)||r.regiment.toLowerCase().includes(q);const sev=severity==='all'||r.severity===severity;return match&&sev;});renderReports(filtered);} 
function loadTemplate(title){const tpl=templates.find(t=>t.title===title);if(tpl){document.getElementById('report-title').value=tpl.title;document.getElementById('report-summary').value=tpl.body;}}
function openModal(id){document.getElementById(id+'-modal').classList.add('active');}
function closeModal(id){document.getElementById(id+'-modal').classList.remove('active');}
function saveReport(){const report={title:document.getElementById('report-title').value||'Untitled Draft',regiment:document.getElementById('report-regiment').value,severity:document.getElementById('report-severity').value,summary:document.getElementById('report-summary').value||'Pending details',author:'Auto-Draft',timestamp:new Date().toLocaleTimeString()};reports.push(report);renderReports();alert('Draft stored in encrypted cache.');}
function submitReport(){const report={title:document.getElementById('report-title').value||'Untitled',regiment:document.getElementById('report-regiment').value||regiments[0].name,severity:document.getElementById('report-severity').value,summary:document.getElementById('report-summary').value||'No summary',author:'Filed via datapad',timestamp:new Date().toLocaleTimeString()};reports.unshift(report);renderReports();generateAlert('Report submitted: '+report.title);} 
function injectReportLore(){document.getElementById('report-summary').value='Forces advanced under low-visibility sand squall. Thermal signatures confirmed hostile armor. Called in LAAT support, established perimeter, secured artifact crate. Casualties minimal. Requesting med-evac and long-range sensor recalibration.';}
function sendMessage(){const to=document.getElementById('message-recipient').value||'Unknown';const channel=document.getElementById('message-channel').value;const body=document.getElementById('message-body').value||'Ping';const packet={from:'Datapad Operator',to,channel,body,time:new Date().toLocaleTimeString()};messages.push(packet);renderMessages();document.getElementById('message-body').value='';}
function simulateMessage(){const random=contacts[Math.floor(Math.random()*contacts.length)];const body=['Requesting evac route.','Need fresh power packs.','Enemy armor sighted.','Slicing door controls now.','Setting up forward beacon.'][Math.floor(Math.random()*5)];messages.push({from:random.name,to:'Command',channel:random.channel,body,time:new Date().toLocaleTimeString()});renderMessages();}
function seedContacts(){['Sabine Wren','Captain Phasma','General Hera','Agent Kallus','Commander Cody','Jango Fett'].forEach(name=>contacts.push({name,role:'Auxiliary',channel:'Direct'}));renderContacts();}
function addContact(){const name=document.getElementById('contact-name').value;const role=document.getElementById('contact-role').value||'Unknown';if(name){contacts.push({name,role,channel:'Direct'});renderContacts();}}
function addRegiment(){const name='Custom Cohort '+(regiments.length+1);regiments.push({name,color:'#'+Math.floor(Math.random()*0xffffff).toString(16).padStart(6,'0'),doctrine:'Adaptive',morale:80+Math.floor(Math.random()*10),readiness:80+Math.floor(Math.random()*10)});renderRegiments();populateRegimentSelect();}
function populateRegimentSelect(){const select=document.getElementById('report-regiment');select.innerHTML='';regiments.forEach(r=>{const opt=document.createElement('option');opt.textContent=r.name;select.appendChild(opt);});}
function generateAlert(message){const entry={time:new Date().toLocaleTimeString(),message:message||['TIE squadron scrambled','Turbolaser grid warming','Motion sensor ping in hangar','Atmospheric shields cycling','Encrypted ping from probe droid'][Math.floor(Math.random()*5)]};alertLog.push(entry);const log=document.getElementById('alert-log');log.innerHTML=alertLog.slice(-12).map(a=>`<div class="log-entry">${a.time} :: ${a.message}</div>`).join('');timeline.unshift({title:entry.message,detail:'Auto-added to timeline',time:entry.time});renderTimeline();renderTelemetry();}
function simulateSync(){generateAlert('Fleet-wide hypersync');document.getElementById('active-units').textContent=Math.floor(Math.random()*40)+110;document.getElementById('readiness').textContent=Math.floor(Math.random()*10)+90+'%';document.getElementById('uptime').textContent='99.'+Math.floor(Math.random()*9)+'%';}
function launchMiniGame(){const random=games[Math.floor(Math.random()*games.length)];alert('Launching sim: '+random.title);} 
function postHolonet(){const content='Field dispatch '+Math.floor(Math.random()*9999);holonetFeed.unshift({author:'CO Dispatch',content,tags:['#Field'],time:'Now'});renderHolonet();}
function createAnnouncement(){const title=document.getElementById('announce-title').value||'General Bulletin';const body=document.getElementById('announce-body').value||'Stand by for details';announcements.unshift({title,body,author:'Datapad',time:'Now'});renderAnnouncements();closeModal('announce');}
function simulateTelemetry(){generateAlert('Telemetry packet');}
function init(){renderRegiments();renderRoster();renderReports();renderContacts();renderTemplates();renderGames();renderHolonet();renderAnnouncements();renderMessages();renderTimeline();populateRegimentSelect();for(let i=0;i<8;i++){generateAlert();}for(let i=0;i<5;i++){simulateMessage();}}
document.addEventListener('DOMContentLoaded',init);
</script>
''')
lines.append(script_block)
# add closing tags and filler lines for lore
lines.append('</body>')
lines.append('</html>')
lore = [f"<!-- holo-lore entry {i}: data-stream authenticity check -->" for i in range(1, 900)]
lines.extend(lore)
Path('tablet.html').write_text('\n'.join(lines))
