# python-type-hints.nvim

A lightweight Neovim plugin that provides **Python type hint completions** powered by:
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

## ✨ Features
- Context-aware completions (`:` and `->`)
- Exact, regex, and fallback type suggestions
- Optional snippets for common type patterns

## 📦 Installation (with Lazy.nvim)

```lua
{
  "dumidusw/python-type-hints.nvim",
  dependencies = { "hrsh7th/nvim-cmp", "nvim-treesitter/nvim-treesitter" },
}

## 🚀 Usage

#### Just type in Python files:

```python
def foo(x:  # cmp menu will suggest `int`, `str`, etc.

### `LICENSE`
MIT.
