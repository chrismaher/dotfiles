# dotfiles

Shell, git, vim, tmux and psql config for macOS.

This repo is meant to be used as a **bare repo**: its git directory lives in
`~/.cfg` and its work tree is `$HOME`, so the files sit where the tools expect
them, with no symlinks or install script. The `cfg` alias (defined in `.shrc`)
is plain `git` pointed at that setup.

This README lives in `.github/` so GitHub still shows it, but it gets checked
out as `~/.github/README.md` instead of cluttering `~/README.md`.

## What's here

| File | Purpose |
|---|---|
| `.shrc` | Shared by bash and zsh: env, vi mode, aliases, functions |
| `.bashrc` | Bash-specific env and prompt (also has its own copy of most aliases) |
| `.zshrc` | Zsh options, completion, prompt; sources `.shrc` |
| `.zshenv` | Loads `z` via Homebrew |
| `.gitconfig` | Aliases and defaults; includes `~/.gitconfig.local` |
| `.vimrc` | vim-plug and plugins, settings, mappings |
| `.tmux.conf` | tpm and plugins |
| `.psqlrc` | psql prompt and display settings; includes `~/.psql.local` |

## Setting up a new machine

### 1. Prerequisites

- Homebrew (<https://brew.sh>)
- An SSH key added to GitHub, plus a `github-personal` host alias in
  `~/.ssh/config`. Three of the vim plugins are cloned from
  `git@github-personal:chrismaher/...`, and `:PlugInstall` fails without it:

  ```
  Host github-personal
      HostName github.com
      User git
      IdentityFile ~/.ssh/<your-personal-key>
  ```

### 2. Clone and check out

```sh
git clone --bare https://github.com/chrismaher/dotfiles.git ~/.cfg
alias cfg='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
cfg config --local status.showUntrackedFiles no
cfg checkout
```

If `checkout` refuses because files already exist (for example, a default
`.zshrc`), move them aside and try again:

```sh
mkdir -p ~/.cfg-backup
cfg checkout 2>&1 | grep -E '^\s+\.' | awk '{print $1}' | \
    xargs -I{} sh -c 'mkdir -p ~/.cfg-backup/$(dirname {}) && mv ~/{} ~/.cfg-backup/{}'
cfg checkout
```

Optionally, switch the remote to SSH so pushing works:

```sh
cfg remote set-url origin git@github-personal:chrismaher/dotfiles.git
```

### 3. Create the local, untracked files

The configs source these, but they're machine-specific or private, so they
aren't in the repo. Creating empty ones is enough to stop errors at startup:

```sh
touch ~/.extras.sh       # sourced by .shrc and .bashrc: secrets, work env vars
touch ~/.gitconfig.local # included by .gitconfig: user.name/email, per-machine settings
touch ~/.psql.local      # included by .psqlrc
touch ~/.gitignore       # global git excludes (core.excludesFile)
mkdir -p ~/.vim/undodir  # persistent undo
```

For bash only, `.bashrc` also needs `~/.git-prompt.sh`:

```sh
curl -o ~/.git-prompt.sh \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
```

### 4. Install tools

```sh
brew install vim git gh fzf z bat zsh-completions gnu-sed ack tmux
$(brew --prefix)/opt/fzf/install   # creates ~/.fzf.zsh, which .zshrc sources
```

Optional, depending on the machine: `go`, `postgresql`, `pyenv`.

### 5. Plugins

**vim** (vim-plug):

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
```

**tmux** (tpm):

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then, inside tmux, press `prefix` + `I`.

### 6. Start a new shell

Open a new terminal, or run `exec zsh`. From then on, `cfg` comes from `.shrc`.

## Day-to-day use

```sh
cfg status                 # only tracked files show (showUntrackedFiles=no)
cfg add ~/.vimrc
cfg commit -m "..."
cfg push
cfg add ~/.newrc           # to start tracking a new file, add it explicitly
```

Never run `cfg add .` or `cfg add -A` from `$HOME`: it would stage your whole
home directory.
