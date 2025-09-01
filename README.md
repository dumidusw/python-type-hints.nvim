# python-type-hints.nvim
A Neovim plugin that provides context-aware Python type completions

> Suggests relevant type annotations based on **parameter names**, **function names**, and **context** — no LSP required.

✨ What It Does

Example

When you type:

```python
def process_users(users_data:
```

→ It suggests:

```
list[dict[str, Any]]
UsersPayload
pd.DataFrame
Optional[list[User]]
```

When you type:

def get_user(user_id: int) -> 

→ It suggests:

```
Optional[User]
dict[str, Any]
User
```

All automatically, based on naming patterns and context.

**Features**

✅ Smart type suggestions based on variable/function names

✅ Parameter vs return type context detection

✅ Works offline — no LSP or AI needed

✅ LuaSnip integration for manual expansion (e.g. ldda<Tab>)

✅ Rich documentation in completion menu (with code examples)

✅ Tree-sitter + regex parsing for accurate context detection

✅ Configurable and lightweight

## Installation
Using Lazy.nvim (recommended)

```lua
{
  "dumidusw/python-type-hints.nvim",
  ft = "python",
  opts = {
    enable_snippets = true,  -- Load LuaSnip snippets (default: true)
    enable_logger = false,   -- Enable debug logs (default: false)
  },
  dependencies = {
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "nvim-treesitter/nvim-treesitter", -- for context parsing
  },
}
```

✅ Make sure you have python parser installed:

```
:TSInstall python
```

## Usage Examples


| You Type | Suggested Types |
|----------|-----------------|
| `users_` | `list[dict[str, Any]]`, `pd.DataFrame`, `UsersPayload` |
| `user_id:` | `int`, `str`, `Optional[int]` |
| `config:` | `dict[str, Any]`, `Config`, `Settings` |
| `->` after `get_user()` | `Optional[User]`, `dict[str, Any]` |

