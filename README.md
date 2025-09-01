# python-type-hints.nvim
A Neovim plugin that provides context-aware Python type completions

> Suggests relevant type annotations based on **parameter names**, **function names**, and **context** — no LSP required.

✨ What It Does
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
