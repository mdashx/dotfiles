# Copier Installation & Integration Plan

## Overview
**Copier** is a modern project scaffolding tool for quickly generating new projects from reusable templates. It's being added to core dev tools for Go, TypeScript, and full-stack projects.

**Why Copier:**
- Lightweight (Python-based, no Node dependency)
- Flexible (Jinja2 templating)
- Language-agnostic (Go, TypeScript, monorepos)
- Simple config (YAML-based)
- Perfect for tutorials, learning, repeated patterns

---

## Installation

### Phase 1: System Installation
**Approach:** Install via package manager (Debian)

```bash
# Check if available
apt-cache policy copier

# If available (recommended)
sudo apt install copier

# Fallback: pip install
pip install copier
# or
pip install --user copier
```

**Add to:** `scripts/install_dev_tools.sh` or equivalent

### Phase 2: Configuration
**Location:** `~/.config/copier/` (create if needed)

Add to `~/.bashrc` or `~/.config/copier/config.yml`:
```yaml
# Optional: default template directories
template_paths:
  - ~/projects/templates/
  - ~/dotfiles/templates/
```

### Phase 3: Core Templates
Create standard templates in `~/projects/templates/`:

```
~/projects/templates/
├── go-cli/           # CLI tool with Cobra
├── go-api/           # REST API with database
├── go-lib/           # Reusable library
├── go-tutorials/     # Tutorial/learning project
├── ts-web/           # TypeScript + React/Vite
└── full-stack/       # Go backend + TS frontend
```

---

## Template Roadmap

### Priority 1 (Immediate)
1. **go-tutorials** — Matches your existing tutorial structure
   - cmd/ layout
   - Simple go.mod
   - Empty main.go templates
   - Used for: learning, prototyping

2. **go-cli** — CLI tool scaffold
   - Cobra setup
   - Multiple commands
   - CI/CD workflow
   - Used for: command-line tools

### Priority 2 (Month 1)
3. **go-api** — REST API service
   - Handler structure
   - Database setup (postgres/mysql)
   - Docker support
   - Migrations framework

4. **ts-web** — TypeScript web project
   - Vite + React template
   - Tailwind CSS
   - ESLint + Prettier
   - Tests (Vitest)

### Priority 3 (Month 2)
5. **full-stack** — Go + TypeScript
   - Backend: go-api structure
   - Frontend: ts-web structure
   - Shared types
   - Docker Compose setup

6. **go-lib** — Reusable library
   - Package structure (pkg/)
   - CI/CD for testing
   - GoDoc generation
   - Example tests

---

## Installation Script

**File:** `scripts/install_dev_tools.sh`

```bash
#!/bin/bash
set -e

echo "Installing Copier..."

# Try package manager first
if command -v apt &> /dev/null; then
    sudo apt update
    sudo apt install -y copier
elif command -v brew &> /dev/null; then
    brew install copier
else
    # Fallback: pip
    python3 -m pip install --user copier
fi

# Verify installation
copier --version

# Create template directories
mkdir -p ~/projects/templates
echo "✓ Copier installed"
echo "✓ Template directory created at ~/projects/templates"
echo ""
echo "Next: Clone or create templates in ~/projects/templates/"
```

---

## Integration with Dotfiles

### Additions to dotfiles:
```
dotfiles/
├── reference/
│   ├── COPIER-PLAN.md (this file)
│   └── COPIER-USAGE.md (usage guide)
├── scripts/
│   ├── install_copier.sh
│   └── setup_templates.sh
└── templates/
    ├── go-cli/
    ├── go-api/
    └── ts-web/
```

### Makefile additions (if any):
```makefile
install-copier:
	bash scripts/install_copier.sh

setup-templates:
	bash scripts/setup_templates.sh

scaffold-cli:
	copier copy ~/dotfiles/templates/go-cli ~/$(PROJECT)

scaffold-api:
	copier copy ~/dotfiles/templates/go-api ~/$(PROJECT)
```

---

## Workflow Integration

### Quick Start Usage:
```bash
# Create new CLI project
copier copy ~/dotfiles/templates/go-cli ~/myproject

# Create new API project
copier copy ~/dotfiles/templates/go-api ~/myapi

# Create tutorial project
copier copy ~/dotfiles/templates/go-tutorials ~/learn-go
```

### Keybindings (if desired):
Add to `.bashrc`:
```bash
alias scaffold-cli='copier copy ~/dotfiles/templates/go-cli'
alias scaffold-api='copier copy ~/dotfiles/templates/go-api'
alias scaffold-ts='copier copy ~/dotfiles/templates/ts-web'
```

---

## Implementation Checklist

- [ ] **Phase 1:** Install Copier via apt/pip
- [ ] **Phase 1:** Verify `copier --version` works
- [ ] **Phase 2:** Create `~/projects/templates/` directory
- [ ] **Phase 3:** Create `go-tutorials` template (based on existing structure)
- [ ] **Phase 3:** Create `go-cli` template with Cobra
- [ ] **Phase 4:** Add Copier to nvim research docs
- [ ] **Phase 4:** Document templates in `COPIER-USAGE.md`
- [ ] **Phase 5:** Create `go-api` template
- [ ] **Phase 5:** Create `ts-web` template
- [ ] **Phase 6:** Create `full-stack` template
- [ ] **Optional:** Add Copier to CI/CD for template validation

---

## Related Documentation

- `research/copier-go-scaffolding.md` (nvim config) — Deep dive on template design
- `COPIER-USAGE.md` — How to use templates
- Go Tutorial Repo — Reference for `go-tutorials` template structure

---

## Notes

- Copier plays well with Go tooling (no Node dependency)
- Templates can be versioned in a separate repo
- Consider centralizing templates in org/personal GitHub repo later
- Update templates as your patterns evolve

---

## Success Criteria

✅ Copier installed and working
✅ At least 2 templates created (go-tutorials, go-cli)
✅ Documented in README
✅ Team members can scaffold projects in <2 minutes
