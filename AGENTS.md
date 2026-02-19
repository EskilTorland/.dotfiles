# AGENTS.md — Dotfiles Repository

## Repository Overview

Personal dotfiles for a macOS ARM64 development environment. Manages configuration
for Neovim, Zsh, Tmux, Git, and Ghostty terminal. The directory layout is GNU
Stow-compatible: each tool gets a top-level directory mirroring its home-directory
target paths (e.g., `nvim/.config/nvim/` maps to `~/.config/nvim/`).

Primary development stack: C#/.NET, TypeScript/JavaScript, Lua, YAML, Liquid (Shopify).

## Directory Structure

```
.dotfiles/
  ghostty/.config/ghostty/config   # Ghostty terminal config
  git/.gitconfig                   # Git identity, delta pager, merge settings
  git/.gitignore_global            # Global gitignore
  jj/.config/jj/config.toml       # Jujutsu (jj) VCS config
  nvim/.config/nvim/               # Neovim config (lazy.nvim)
    init.lua                       # Entry point: bootstraps lazy.nvim, sets leader
    lua/set.lua                    # Vim options (tabs, undo, numbers, scroll)
    lua/remap.lua                  # Key remappings
    lua/plugins/*.lua              # One file per plugin (lazy.nvim spec)
  tmux/.tmux.conf                  # Tmux config (prefix C-a, Catppuccin theme)
  tmux/plugins/                    # TPM and vendored tmux plugins
  zsh/.zshrc                       # Zsh config (Oh My Zsh, P10k, aliases, tools)
  install_mac.sh                   # macOS bootstrap script (Homebrew)
  install_ubuntu.sh                # Ubuntu bootstrap script (apt)
```

## Build / Install / Setup Commands

There is no traditional build system. Setup is handled by platform-specific scripts.

```bash
# macOS setup (requires Homebrew, installs all dependencies)
chmod +x install_mac.sh
./install_mac.sh

# Ubuntu setup
bash install_ubuntu.sh

# Neovim plugins are managed by lazy.nvim — open Neovim and run:
:Lazy sync

# Tmux plugins are managed by TPM — inside tmux press:
# prefix + I   (to install plugins)

# Symlink a tool config into the home directory
stow -d ~/.dotfiles -t ~ nvim
```

## Testing

There are no tests for this dotfiles repository. The Neovim config includes
`neotest` with `neotest-dotnet` (xUnit) for running tests in external projects.

## Linting and Formatting

Formatting is configured inside Neovim via `none-ls.nvim` (null-ls) with
format-on-save (`BufWritePre` autocmd). There is no CI or pre-commit enforcement.

| Language     | Formatter/Linter | Notes                                    |
|--------------|------------------|------------------------------------------|
| Lua          | Stylua           | Tabs, double quotes, trailing commas     |
| JS/TS        | Prettier         | Uses project-local `./node_modules/.bin` |
| YAML         | Prettier         | 2-space tab width                        |
| Liquid       | Prettier         | With `@shopify/prettier-plugin-liquid`   |
| JS/TS (lint) | ESLint           | Via none-ls-extras                       |

No `.editorconfig`, `.shellcheckrc`, or pre-commit hooks exist in this repo.

## Code Style — Lua (Neovim Config)

- **Indentation:** Tabs (stylua default). Do not use spaces.
- **String quotes:** Always double quotes (`"string"`), never single quotes.
- **Trailing commas:** Always include trailing commas in table literals.
- **Plugin files:** Each file in `lua/plugins/` returns a table of lazy.nvim specs:
  ```lua
  return {
  	{
  		"author/plugin-name",
  		dependencies = { "dep/plugin" },
  		opts = { ... },
  	},
  }
  ```
- **Config patterns** (in order of preference):
  1. `opts = { ... }` — declarative, for simple configs
  2. `config = function() ... end` — imperative, for complex setup
  3. `config = function(_, opts) ... end` — hybrid when both are needed
  4. `config = true` — when defaults suffice
- **Requires:** Use `require("module")` with double-quoted strings.
- **Comments:** `--` prefix. TODOs use `--TODO:` (no space after `--`).

## Code Style — Shell Scripts (Bash/Zsh)

- **Shebang:** `#!/bin/bash` for scripts. No shebang for sourced configs (`.zshrc`).
- **Indentation:** 2 spaces.
- **Variable naming:**
  - `UPPER_SNAKE_CASE` for exported/environment variables and constants
  - `lower_snake_case` for local/function-scoped variables
- **Function naming:**
  - `lower_snake_case` for utility functions (e.g., `command_exists`)
  - `_underscore_prefix` for framework integration functions (e.g., `_fzf_comprun`)
  - `lowercase` for short user functions (e.g., `projects`, `ghd`)
- **Quoting:** Always double-quote variable expansions (`"$HOME"`, `"$var"`).
- **Command substitution:** Always use `$()`, never backticks.
- **Idempotency:** Guard installs with `command -v <tool> &> /dev/null` or
  `[ ! -d "..." ]` checks before installing or cloning.
- **Error handling:** No `set -e` or `set -o pipefail` is used.
  Suppress expected errors with `2>/dev/null`.
- **Comments:** `# Comment text` with a space after `#`. Comments go above code.

## File and Directory Naming

- All lowercase for directories and files.
- Hyphens (`-`) as word separators in Lua plugin filenames:
  `tmux-navigator.lua`, `dap-ui.lua`, `render-markdown.lua`.
- Single-word filenames where possible: `lsp.lua`, `snacks.lua`, `trouble.lua`.
- Install scripts follow `install_<platform>.sh` pattern.
- Top-level directories match the tool they configure: `nvim/`, `zsh/`,
  `git/`, `tmux/`, `ghostty/`.

## Commit Message Conventions

Use Conventional Commits format. Sentence case after the prefix. Single line.

```
feat: Add Ghostty terminal configuration file
fix: Resolve lazy.nvim initialization circular dependency
refactor: Simplify Neotree configuration and update toggle keymap
chore: Update tools and plugin lockfile
```

Prefixes: `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`, `style:`.

## Secrets and Sensitive Files

- `.env` contains API keys and is gitignored. **Never commit secrets.**
- `.claude/` is gitignored (Claude Code local config).
- `git/.gitignore_global` ignores `.aider*` files globally.

## Key Architecture Patterns

- **Stow-compatible layout:** Each tool directory mirrors the home-directory
  structure. `nvim/.config/nvim/init.lua` maps to `~/.config/nvim/init.lua`.
- **Neovim plugin organization:** One file per plugin in `lua/plugins/`, each
  auto-discovered by lazy.nvim via `{ import = "plugins" }` in `init.lua`.
- **Leader key:** Space (`<leader>` = `" "`), set in `init.lua` before plugins load.
- **Color theme:** Gruvbox Material (soft) across Neovim, Ghostty, and bat.
- **Tmux:** `vim-tmux-navigator` for Ctrl+hjkl pane navigation. Prefix is `C-a`.
- **LSP servers:** Managed by Mason. Configured in `lua/plugins/lsp.lua`.
- **DAP (debugging):** netcoredbg for .NET on macOS ARM64, with VS Code
  `launch.json` support. Config across `dap.lua`, `dap-ui.lua`, `dap-mason.lua`.
- **AI tools:** GitHub Copilot (`copilot.lua`) and Claude Code (`claude.lua`).
- **Zsh workflow:** Oh My Zsh + Powerlevel10k. Key tools: fzf, fd, bat, eza,
  zoxide, delta. Custom `projects()` for fzf-powered tmux session switching.