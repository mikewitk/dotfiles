# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a LazyVim-based Neovim configuration built on the LazyVim starter template. The configuration uses the lazy.nvim plugin manager for plugin loading and management.

### Key Structure
- `init.lua` - Entry point that bootstraps lazy.nvim
- `lua/config/` - Core configuration files
  - `lazy.lua` - Plugin manager setup and LazyVim configuration
  - `options.lua` - Vim options (tab size set to 4 spaces)
  - `keymaps.lua` - Custom keymaps (includes diagnostic clipboard copy)
  - `autocmds.lua` - Custom autocommands (currently empty)
- `lua/plugins/` - Custom plugin configurations
  - `formatting.lua` - Code formatting setup using conform.nvim
- `stylua.toml` - Lua formatter configuration

### LazyVim Integration
- Uses LazyVim base configuration with custom overrides
- Plugin auto-updates enabled but notifications disabled
- Performance optimizations with disabled default vim plugins
- Default colorschemes: tokyonight, habamax

## Development Commands

### Code Formatting
- **Lua files**: Uses stylua with 2-space indentation, 120 column width
- **Web files**: Uses prettier for HTML, JavaScript, TypeScript, JSX/TSX, JSON, CSS, SCSS
- **Tailwind CSS**: Prettier configured for Tailwind class sorting (requires `@prettier/plugin-tailwindcss` in project)
- Configuration in `lua/plugins/formatting.lua` and `stylua.toml`

### Manual Setup Required
- **For Tailwind projects**: Install `prettier @prettier/plugin-tailwindcss` in your project:
  ```bash
  npm install -D prettier @prettier/plugin-tailwindcss
  # OR
  yarn add -D prettier @prettier/plugin-tailwindcss
  ```

### Tailwind CSS Features
- **LSP**: tailwindcss-language-server provides autocompletion and hover info
- **Colorizer**: Inline color indicators (●) for Tailwind color classes via tailwind-tools.nvim
- **Class Sorting**: Automatic Tailwind class reordering on save (when prettier plugin installed)
- **Commands**: `:TailwindColorEnable`/`:TailwindColorDisable` to toggle color indicators

### Custom Keymaps
- `<leader>zy` - Copy current line diagnostics to system clipboard (lua/config/keymaps.lua:6)

## Configuration Files
- `lazyvim.json` - LazyVim version and extras tracking
- `lazy-lock.json` - Plugin version lockfile (managed by lazy.nvim)
- `stylua.toml` - Lua code formatting rules

## Customization Patterns
- Override LazyVim defaults in respective config files
- Add new plugins in `lua/plugins/` directory
- Custom options go in `lua/config/options.lua`
- Custom keymaps go in `lua/config/keymaps.lua`