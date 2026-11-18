# 100x-Team (sebelumnya 10x-Team)

100x-Team adalah framework peningkatan kemampuan chatbot melalui *dynamic role switching*: satu chatbot yang sama dapat mengambil perspektif profesional yang berbeda sesuai pekerjaan. Ia menyediakan 14 role spesialis, domain knowledge, proses kerja per role, router untuk memilih role, dan konteks proyek yang berkesinambungan.

Satu percakapan dapat dimulai dari perspektif CTO, dilanjutkan ke Principal Architect, SDE, DBA, Security Engineer, lalu QA Engineer. Itu **satu chatbot yang berganti role**, bukan enam agent berbeda — 100x-Team bukan framework multi-agent.

Satu developer. Cakupan sebuah tim penuh.

> Berbasis [10x-Team](https://github.com/Jaan-Mustafa/10x-Team) karya Jaan-Mustafa (MIT). Lihat [Kredit & Lisensi](#kredit--lisensi).

## Instalasi

Kompatibilitas dan cara instalasi **bergantung pada platform chatbot** yang Anda pakai. Jalur yang saat ini didokumentasikan adalah integrasi skill native di Claude Code (di bawah). Chatbot lain (misalnya Grok, ChatGPT, atau Gemini) hanya dapat memakai 100x-Team jika platformnya mendukung mekanisme skill atau plugin yang kompatibel; jangan mengasumsikan semua chatbot memuat skill, menyimpan konteks, atau melakukan routing dengan cara yang sama. Aktivasi manual untuk chatbot tanpa dukungan skill adalah rencana masa depan dan belum tersedia.

Integrasi skill native di Claude Code, dari dalam Claude Code:

```
/plugin marketplace add Gilangbahrula/100x-vault
/plugin install 100x-team@100x-vault-dev
/reload-plugins
```

## Skill yang Tersedia

### Tim Penuh

| Skill | Use When |
|-------|----------|
| `/10x-team` | **Building projects end-to-end** — brainstorms first, then moves through strategy, design, planning, implementation, testing, and deployment with hard gates at every phase |
| `/router` | **Not sure who should handle it?** — classifies the intent (domain keywords, artifact wanted, project phase, active role) and recommends the best-fitting role at the start and again whenever the work shifts mid-conversation, or `/10x-team` for cross-role work |

### Role Individual

| Skill | Role | Use When |
|-------|------|----------|
| `/cto` | Chief Technology Officer | Build vs buy, business case, technical strategy |
| `/product-manager` | Product Manager | Feature prioritization, user stories, roadmap |
| `/dewa-frontend` | Dewa Frontend | Frontend design and specification from a project package — screen discovery, backend-to-UX traceability, design system spec, audit; documents only, no code |
| `/frontend-uiux-engineer` | Frontend UI/UX Engineer | UX flows, design system, accessibility, UI code |
| `/principal-architect` | Principal Architect | System design, data model, API contracts, ADRs |
| `/staff-engineer` | Staff Engineer | Cross-team technical decisions, code quality |
| `/engineering-manager` | Engineering Manager | Team processes, sprint planning, delivery |
| `/senior-engineer` | Senior Engineer | Implementation guidance, code review |
| `/sde` | Software Development Engineer | Hands-on coding, debugging |
| `/dba` | Database Administrator | Schema design, query optimization |
| `/security-engineer` | Security Engineer | Security review, threat modeling |
| `/qa-engineer` | QA Engineer | Testing strategy, test plans |
| `/devops-engineer` | DevOps Engineer | CI/CD, infrastructure, deployment |
| `/sre` | Site Reliability Engineer | Reliability, monitoring, incident response |

## Kesinambungan Konteks Antar-Role

Karena satu chatbot berganti role, kesinambungan dijaga lewat state proyek berbasis file di `.10x/` — bukan lewat komunikasi antar-agent. Setiap respons yang memakai 100x-Team diawali identitas skill aktif, misalnya `Using skill: "principal-architect"`; baris itu menyebut skill (bukan model), berganti saat role berganti, dan hanya muncul jika skill benar-benar termuat.

Pekerjaan juga memiliki **Depth L1–L5** yang menyesuaikan diri dengan kompleksitas dan risiko; di respons cukup tampil `Depth: L#`. Depth menggambarkan kedalaman pekerjaan, bukan peringkat kompetensi atau jaminan kualitas, dan tidak pernah menggantikan hard gate.

### Persiapan

```
/init-project
```

### Struktur State

State disimpan **satu folder per role** di bawah `.10x/decisions/` — setiap role menulis
file `<feature-slug>.md` beserta `_index.md` berisi prinsip lintas-fitur, dan
membaca dependensi hulunya sebelum bertindak. Jalankan `/init-project` untuk menyiapkannya.
Nama folder mengikuti "Role → State Folder Map" di `/10x-team` — misalnya `/principal-architect` menulis ke `architect/` dan `/security-engineer` ke `security/`. `/router` tidak punya folder state karena ia tidak membuat keputusan proyek.

### Cara Kerja

```
/cto memutuskan "Pakai Razorpay"
  → menulis keputusan ke .10x/decisions/cto/payments.md
  → menulis konteks handoff untuk PM dan Architect

/principal-architect merancang layanan pembayaran
  → membaca .10x/decisions/cto/payments.md dan product-manager/payments.md
  → merancang dengan konteks penuh
  → menulis arsitektur ke .10x/decisions/architect/payments.md, plus ADR di .10x/adrs/

/sde mengimplementasikan webhook pembayaran
  → membaca setiap folder hulu di bawah .10x/decisions/
  → menulis kode dengan konteks tim penuh
  → menulis apa yang dibangun ke .10x/decisions/sde/payments.md
```

Setiap kali chatbot mengambil sebuah role, ia membaca keputusan hulu sebelum bertindak dan menulis keputusannya setelah pekerjaan selesai; "handoff" hanyalah catatan untuk perspektif berikutnya di percakapan yang sama, bukan pesan antar-agent. Berpindah role tidak menghapus konteks dan tidak mengulang proyek dari awal. Pengguna dapat meminta pindah role kapan saja, dan `/router` dapat merekomendasikan pindah ketika kebutuhan berubah di tengah pekerjaan — tidak setiap pergantian topik berarti pergantian role. Orchestrator (`/10x-team`) menegakkan alur ini dengan hard gate di setiap transisi fase.

## Contoh Penggunaan

```
> /10x-team Buatkan pemendek URL dengan analitik

> /cto Sebaiknya kita bangun sistem pembayaran sendiri atau pakai Razorpay?

> /principal-architect Rancang layanan notifikasi yang menangani 10 juta event per hari

> /sre Latensi API kami melonjak 3x setelah deploy terakhir — bantu saya menyelidikinya

> /security-engineer Tinjau alur autentikasi ini untuk mencari kerentanan

> /dba Tabel kami 50 juta baris dan query ini lambat — optimalkan

> /dewa-frontend Rancang spesifikasi frontend lengkap dari paket proyek ini (backend, PRD, registry komponen)

> /router Pelanggan mengeluh checkout lambat, saya tidak tahu harus mulai dari role mana

> Pindah ke /dba — indeks apa yang tepat untuk query ini?
```

## Struktur Proyek

```
100x-vault/
├── .claude-plugin/
│   ├── plugin.json              # Manifest plugin
│   └── marketplace.json         # Registri marketplace (100x-vault-dev)
├── skills/
│   ├── 10x-team/SKILL.md       # Orchestrator — seluruh 14 role
│   ├── router/SKILL.md         # Dispatcher — mengarahkan permintaan ke satu role
│   ├── cto/SKILL.md
│   ├── product-manager/SKILL.md
│   ├── principal-architect/SKILL.md
│   ├── staff-engineer/SKILL.md
│   ├── senior-engineer/SKILL.md
│   ├── sde/SKILL.md
│   ├── devops-engineer/SKILL.md
│   ├── sre/SKILL.md
│   ├── security-engineer/SKILL.md
│   ├── dba/SKILL.md
│   ├── qa-engineer/SKILL.md
│   ├── engineering-manager/SKILL.md
│   ├── dewa-frontend/SKILL.md
│   └── frontend-uiux-engineer/SKILL.md
├── commands/
│   └── init-project.md          # Inisialisasi state proyek .10x/
├── tests/
│   └── validate-skills.test.js  # Validasi struktur skill
└── docs/
    └── adr/                     # Catatan keputusan arsitektur
```

## Berkontribusi

Kontribusi sangat diterima! Baik untuk memperbaiki skill yang ada, menambah role baru, memperbaiki bug, maupun memperbaiki dokumentasi.

### Menambah Skill Baru

1. Buat folder di bawah `skills/` berisi file `SKILL.md`:

```
skills/my-role/SKILL.md
```

2. Ikuti struktur ini (isi `SKILL.md` ditulis dalam bahasa Inggris, karena itulah yang dibaca AI untuk routing dan perilaku skill):

```markdown
---
name: my-role
description: "When this skill should be triggered and what it does."
---

# Role Title

One-line summary of what this skill helps with.

<HARD-GATE>
What must happen BEFORE giving recommendations.
</HARD-GATE>

## Anti-Pattern: "Common Mistake Title"
Why skipping the process causes problems.

## Checklist
Ordered steps the skill must follow.

## Process Flow
Visual flow of the decision process.

## The Process
Detailed guidance for each phase.

## Project State Protocol
### Before You Start (EVERY time)
Read relevant .10x/decisions/ files.
### Before You Finish (EVERY time)
Check your Definition of Done, then write your decisions to .10x/decisions/<role-folder>/<feature-slug>.md and update its _index.md.

## Key Principles
Core rules that guide the skill's behavior.

## Anti-Patterns to Flag
Common mistakes to call out.

## Tone
How the skill should communicate. Start responses with `Using skill: "my-role"` (see Skill Identity in /10x-team).
```

3. Jalankan tes:

```bash
node tests/validate-skills.test.js
```

4. Muat ulang plugin:

```
/reload-plugins
```

### Memperbarui Skill yang Ada

1. Edit `SKILL.md` di `skills/<role>/`
2. Pertahankan struktur yang sama — frontmatter, hard gate, checklist, process, state protocol, prinsip
3. Jalankan tes lalu muat ulang plugin

### Melaporkan Masalah

Menemukan bug atau punya ide? [Buka issue](https://github.com/Gilangbahrula/100x-vault/issues).

## Kredit & Lisensi

100x-Team berdasar pada **10x-Team** karya Jaan-Mustafa (Md Rizabul), yang dirilis di bawah Lisensi MIT, lalu dikembangkan ulang secara besar-besaran menjadi **100x-Team** oleh Gilangbahrula.

Dirilis di bawah Lisensi MIT — lihat [LICENSE](LICENSE). Teks lisensi tidak diubah: notice hak cipta asli tetap dipertahankan, dan satu baris hak cipta ditambahkan setelahnya untuk modifikasi dan pengembangan lanjutan.
