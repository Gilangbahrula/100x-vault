# /init-project — Initialize Project State for 100x-Team

Set up the shared project state files that enable communication between all 13 skills.

## Steps

1. **Check if state already exists** — Look for a `.10x/` directory in the project root. If it exists, tell the user and ask if they want to reset it.

2. **Create the folder structure** (bash). Folder names are fixed — they match the Role → State Folder Map in the `/10x-team` orchestrator (for example `architect`, not `principal-architect`):

```bash
mkdir -p .10x/decisions/{cto,product-manager,architect,staff-engineer,engineering-manager,senior-engineer,sde,dba,security,qa,devops,sre,frontend-uiux-engineer}
mkdir -p .10x/adrs .10x/specs .10x/reviews
```

3. **Create an `_index.md` inside each decisions folder**, so every role has a home for cross-cutting principles from day one:

```bash
for role in cto product-manager architect staff-engineer engineering-manager senior-engineer sde dba security qa devops sre frontend-uiux-engineer; do
  cat > ".10x/decisions/$role/_index.md" <<EOF
# $role — Cross-Cutting Principles & Active Features

## Principles
(none yet)

## Active Features
(none yet)
EOF
done
```

4. **Create `.10x/status.md`** — ask the user for the project name, fill in the bracketed placeholders, and write:

```markdown
# Project Status

## Project: [Ask user for project name]
**Current Phase:** Brainstorming
**Last Updated:** [Today's date] by init-project
**Health:** On Track

## Progress

### Done
(none yet)

### In Progress
(none yet)

### Pending
- [ ] Phase 1 — CTO: Strategic direction and tech decisions
- [ ] Phase 1 — PM: Requirements and scope definition
- [ ] Phase 2 — Frontend UI/UX Engineer (if there is a UI): UX strategy, site map, design system (UI build follows in Phase 4)
- [ ] Phase 2 — Architect: System design + ADR
- [ ] Phase 2 — Staff Engineer: Coding standards and patterns
- [ ] Phase 3 — EM: Task breakdown and estimation
- [ ] Phase 3 — Senior Engineer: Implementation planning
- [ ] Phase 4 — DBA: Schema and data modeling (physical schema goes before SDE)
- [ ] Phase 4 — SDE: Code implementation
- [ ] Phase 5 — QA: Test strategy and verification
- [ ] Phase 5 — Security: Threat model and security review
- [ ] Phase 6 — DevOps: CI/CD and deployment
- [ ] Phase 6 — SRE: Monitoring and reliability

### Blocked
(none)

## Risks
(none identified yet)
```

5. **Create `.10x/handoff.md`** with this content:

```markdown
# Current Handoff

> Each role overwrites the "Current Handoff" section when passing work forward.
> Previous handoffs are preserved in the History section below.

## From: init-project → To: First active role
**Date:** [Today's date]
**Phase:** Setup → Brainstorming

### Context
Project state initialized with folder-per-role decisions. Ready for the first role.
Every role MUST read `.10x/decisions/` before acting and write its decisions
to its own folder before finishing.

## History
(none yet)
```

6. **Confirm to the user** that state is initialized and remind them: the orchestrator (`/10x-team`) hard-gates every phase transition on these files being written.
