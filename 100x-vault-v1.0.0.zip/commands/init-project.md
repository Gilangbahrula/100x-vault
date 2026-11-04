# /init-project — Initialize Project State for 100x-Team

Set up the shared project state files that enable communication between all 13 skills.

## Steps

1. **Check if state already exists** — Look for a `.10x/` directory in the project root. If it exists, tell the user and ask if they want to reset it.

2. **Create the folder structure** (bash):

```bash
mkdir -p .10x/decisions/{cto,product-manager,architect,staff-engineer,engineering-manager,senior-engineer,sde,dba,security,qa,devops,sre,frontend-uiux-engineer}
mkdir -p .10x/adrs .10x/specs .10x/reviews
```

3. **Create an `_index.md` inside each decisions folder**, so every role has a home for cross-cutting principles from day one:

```bash
for role in cto product-manager architect staff-engineer engineering-manager senior-engineer sde dba security qa devops sre frontend-uiux-engineer; do
  cat > ".10x/decisions/$role/_index.md" <<'EOF'
# <Role> — Cross-Cutting Principles & Active Features

## Principles
(none yet)

## Active Features
(none yet)
EOF
done
```

### `.10x/status.md`

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
- [ ] CTO: Strategic direction and tech decisions
- [ ] PM: Requirements and scope definition
- [ ] Frontend UI/UX Engineer: UX strategy, site map, design system
- [ ] Architect: System design + ADR
- [ ] Staff Engineer: Coding standards and patterns
- [ ] EM: Task breakdown and estimation
- [ ] Senior Engineer: Implementation planning
- [ ] SDE: Code implementation
- [ ] DBA: Schema and data modeling
- [ ] Security: Threat model and security review
- [ ] QA: Test strategy and verification
- [ ] DevOps: CI/CD and deployment
- [ ] SRE: Monitoring and reliability

### Blocked
(none)

## Risks
(none identified yet)
```

### `.10x/handoff.md`

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

4. **Confirm to the user** that state is initialized and remind them: the orchestrator (`/10x-team`) hard-gates every phase transition on these files being written.
