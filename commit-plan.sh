#!/usr/bin/env bash
# commit-plan.sh — 100x-team v1.2.2 (histori commit rapi: satu concern per commit)
# Jalankan dari ROOT repo Termux yang SUDAH punya .git dan origin, setelah isi zip disalin ke working tree.
# Script ini tidak menjalankan git init, remote add, maupun push.
# Pratinjau tanpa eksekusi:  DRY_RUN=1 bash commit-plan.sh
# Pengaman: berhenti jika bukan repo git, jika ada perubahan ter-stage, atau jika satu commit gagal.
# Jika berhenti di tengah: git log --oneline (lihat commit yang sudah jadi), git restore --staged . ,
# hapus baris commit yang sudah selesai dari script ini, lalu jalankan ulang.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Bukan repo git, dihentikan."; exit 1; }
git diff --cached --quiet || { echo "Ada perubahan yang sudah di-stage. Jalankan: git restore --staged .  (atau commit dulu), lalu ulangi."; exit 1; }
START=$(git rev-parse HEAD 2>/dev/null || true)
if [ "${DRY_RUN:-0}" = "1" ]; then git() { echo "[dry-run] git $*"; }; fi

# 1) add depth levels to orchestrator
git add skills/10x-team/SKILL.md && git commit -m 'add depth levels to orchestrator' || exit 1

# 2) add depth setting and deepen to router
git add skills/router/SKILL.md && git commit -m 'add depth setting and deepen to router' || exit 1

# 3) add depth rule to role skills
git add skills/cto/SKILL.md skills/product-manager/SKILL.md skills/frontend-uiux-engineer/SKILL.md skills/principal-architect/SKILL.md skills/staff-engineer/SKILL.md skills/engineering-manager/SKILL.md skills/senior-engineer/SKILL.md skills/sde/SKILL.md skills/dba/SKILL.md skills/security-engineer/SKILL.md skills/qa-engineer/SKILL.md skills/devops-engineer/SKILL.md skills/sre/SKILL.md && git commit -m 'add depth rule to role skills' || exit 1

# 4) document depth levels in readme
git add README.md && git commit -m 'document depth levels in readme' || exit 1

if [ "${DRY_RUN:-0}" != "1" ]; then
  NOW=$(git rev-list --count "${START:-HEAD}"..HEAD 2>/dev/null || echo 0)
  echo "Selesai: $NOW commit baru dari 4 yang direncanakan."
  [ "$NOW" = "4" ] || echo "PERIKSA: jumlah commit tidak sesuai rencana."
  git status --short
fi
