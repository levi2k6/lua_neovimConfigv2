## Prerequisites

Before using this Neovim config, install the following:

### Core build tools
- `build-essential` — compiles native plugin extensions (e.g. telescope-fzf-native)
```bash
  sudo apt install build-essential
```

### Search tools (required for Telescope)
- `ripgrep` — powers Telescope's live-grep
```bash
  sudo apt install ripgrep
```
- `fd-find` — extended file-finding for Telescope (optional but recommended)
```bash
  sudo apt install fd-find
  ln -s $(which fdfind) ~/.local/bin/fd
```

### Treesitter
- `Node.js` + `npm` — needed to install tree-sitter-cli
```bash
  sudo apt install npm
  sudo npm install -g tree-sitter-cli
```

### Clipboard support
- `xclip` — enables system clipboard integration (`"+y`, `"*y`)
```bash
  sudo apt install xclip
```

### Python provider (optional, for Python-based plugins)
- `python3-pip` (Ubuntu's Python 3 often doesn't ship with pip)
```bash
  sudo apt install python3-pip
```
- `pynvim`
```bash
  pip install pynvim --break-system-packages
```
- Verify:
```bash
  python3 -c "import pynvim; print(pynvim.__file__)"
```

### pyenv (optional — only if you need to manage multiple Python versions)
```bash
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

curl -fsSL https://pyenv.run | bash
```
Add to `~/.bashrc`:
```bash
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```
Then `source ~/.bashrc` and run `pyenv install 3.12.3 && pyenv global 3.12.3`.

### Post-install step
After installing the above, compile the Telescope native extension:
```bash
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
make
```

Run `:checkhealth` inside Neovim afterward to confirm everything passes.
