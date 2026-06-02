# dotfiles

Personal configuration files for shell environments, terminal emulators, and development tools.

## Configuration Mapping

| Source Path | Target Destination | Description |
|:---|:---|:---|
| `bash/bashrc` | `~/.bashrc` | Integrates **Oh My Bash** with the **agnoster** theme. |
| `bash/bash_aliases` | `~/.bash_aliases` | General aliases, additionally sourced by Zsh. |
| `zsh/zshrc` | `~/.zshrc` | Integrates **Oh My Zsh**, **agnoster**, and syntax highlighting. |
| `git/gitconfig` | `~/.gitconfig` | Git global configurations (identity, noreply email, defaults). |
| `fastfetch/` | `~/.config/fastfetch/` | Custom fastfetch configurations and assets (Sonic logo). |
| `konsole/` | `~/.local/share/konsole/` | Terminal emulator profiles. |
| `konsole/konsolerc` | `~/.config/konsolerc` | Sets **Ale** as the default Konsole profile. |

## Technology Stack

| Component | Purpose |
|:---|:---|
| [Oh My Bash](https://github.com/ohmybash/oh-my-bash) | Bash framework infrastructure (`~/.oh-my-bash`). |
| [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) | Zsh framework infrastructure (`~/.oh-my-zsh`). |
| **agnoster** Theme | Powerline-based prompt theme utilized in both Bash and Zsh. |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Real-time command validation and visual feedback. |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Asynchronous history-based command suggestions (Accept via `→`). |
| **Hack** Font | Monospace typeface for the **Ale** Konsole profile (Size 13). |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | Backend for the custom system information command (`sys`). |
| [Konsole](https://apps.kde.org/konsole/) | Default terminal emulator for the KDE desktop environment. |

> **Note:** The **agnoster** prompt requires Powerline glyphs. The installation script attempts to provision `fonts-powerline` along with the **Hack** font automatically.
> *Optional aliases support:* `eza`, `bat`, and `nvim`.

## Installation

Clone the repository to any preferred directory. The execution of `install.sh` resolves missing dependencies and configures the appropriate symbolic links.

```bash
git clone [https://github.com/als-code/dotfiles.git](https://github.com/als-code/dotfiles.git)
cd dotfiles
chmod +x install.sh bootstrap-deps.sh
./install.sh
source ~/.bashrc

```

### Advanced Installation Flags

To provision dependencies exclusively without modifying symbolic links:

```bash
./install.sh --deps-only
# Alternative syntax
./bootstrap-deps.sh

```

To establish symbolic links exclusively (applicable if frameworks and fonts are pre-installed):

```bash
./install.sh --no-deps

```

### Dependency Verification (Debian/Ubuntu)

The `bootstrap-deps.sh` script automates the verification and setup of the following components:

1. **Oh My Bash** — Cloned into `~/.oh-my-bash`.
2. **agnoster (Bash)** — Native component within Oh My Bash.
3. **Zsh** — Provisions the `zsh` package.
4. **Oh My Zsh** — Cloned into `~/.oh-my-zsh`.
5. **Plugins & Themes** — Configures Zsh agnoster, `syntax-highlighting`, and `autosuggestions`.
6. **Default Shell** — Updates the default user shell to Zsh (handled via `install.sh`).
7. **Typography** — Installs `fonts-hack` and `fonts-powerline`.

### Manual Installation (Other Distributions)

For non-Debian based systems, dependencies can be provisioned manually using the following sequences:

```bash
# Provision Oh My Bash
bash -c "$(curl -fsSL [https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh](https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh))" --unattended

# Provision Oh My Zsh and associated plugins
RUNZSH=no CHSH=no sh -c "$(curl -fsSL [https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh](https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh))" --unattended
git clone --depth=1 [https://github.com/zsh-users/zsh-syntax-highlighting.git](https://github.com/zsh-users/zsh-syntax-highlighting.git) "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone --depth=1 [https://github.com/zsh-users/zsh-autosuggestions.git](https://github.com/zsh-users/zsh-autosuggestions.git) "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Font Resources: [https://sourcefoundry.org/hack/](https://sourcefoundry.org/hack/)
```

Upon successful execution of `./install.sh`, Konsole will initialize using the **Ale** profile by default.

## Usage and Shortcuts

* `sys` — Executes `fastfetch` utilizing the custom configuration (`fastfetch/sonic.txt`).
* `n` — Launches Neovim within the current working directory.
* **Git Aliases** — Presets include `g`, `gs`, `gd`, `gcm`, and `gcam`.

The `$DOTFILES` environment variable dynamically resolves to the root folder of the cloned repository during the initialization of `bashrc` or `zshrc`.

> **System Configuration Note:** The installation script changes the login shell to Zsh using either `sudo usermod` (if passwordless sudo is configured) or `chsh` (which prompts for user authentication). A terminal restart is required post-installation to apply these changes.



