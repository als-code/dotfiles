# dotfiles

Configuración personal de shell, terminal y herramientas.

## Contenido

| Ruta | Destino |
|------|---------|
| `bash/bashrc` | `~/.bashrc` — **Oh My Bash** + tema **agnoster** |
| `bash/bash_aliases` | `~/.bash_aliases` (también cargado desde zsh) |
| `zsh/zshrc` | `~/.zshrc` — **Oh My Zsh** + **agnoster** + resaltado al escribir |
| `git/gitconfig` | `~/.gitconfig` (nombre, email noreply GitHub, defaults) |
| `fastfetch/` | `~/.config/fastfetch/` (config + logo Sonic) |
| `konsole/` | perfiles en `~/.local/share/konsole/` |
| `konsole/konsolerc` | `~/.config/konsolerc` — perfil por defecto **Ale** |

## Stack

| Componente | Uso |
|------------|-----|
| [Oh My Bash](https://github.com/ohmybash/oh-my-bash) | Framework bash (`~/.oh-my-bash`) |
| [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) | Framework zsh (`~/.oh-my-zsh`) |
| Tema **agnoster** | Prompt en bash y zsh |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Colorea comandos mientras escribes (válido / inválido) |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Sugerencias grises del historial (→ para aceptar) |
| Fuente **Hack** | Perfil Konsole Ale (tamaño 13) |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | Comando `sys` |
| [Konsole](https://apps.kde.org/konsole/) | Terminal KDE |

El prompt **agnoster** usa glifos Powerline; `install.sh` intenta instalar `fonts-powerline` además de **Hack** (Konsole).

Opcionales en aliases: `eza`, `bat`, `nvim`.

## Instalación

Clona el repo donde quieras. `install.sh` instala dependencias que falten y crea symlinks.

```bash
git clone https://github.com/als-code/dotfiles.git
cd dotfiles
chmod +x install.sh bootstrap-deps.sh
./install.sh
source ~/.bashrc
```

Solo dependencias (sin symlinks):

```bash
./install.sh --deps-only
# o
./bootstrap-deps.sh
```

Solo symlinks (si ya tienes OMB, Hack, etc.):

```bash
./install.sh --no-deps
```

### Dependencias (Debian/Ubuntu)

`bootstrap-deps.sh` hace lo siguiente si falta algo:

1. **Oh My Bash** → clone en `~/.oh-my-bash`
2. **agnoster** (bash) → incluido en OMB
3. **zsh** → paquete `zsh`
4. **Oh My Zsh** → clone en `~/.oh-my-zsh`
5. **agnoster** (zsh) + plugins **syntax-highlighting** y **autosuggestions**
6. **Shell por defecto** → `chsh -s` a zsh (desde `install.sh`)
7. **Hack** → paquete `fonts-hack`
8. **Powerline** (prompt agnoster) → paquete `fonts-powerline`

En otras distros, instala manualmente:

```bash
# Oh My Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended

# Oh My Zsh + plugins de resaltado
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Hack: https://sourcefoundry.org/hack/
```

Tras `./install.sh`, Konsole abre con el perfil **Ale** por defecto.

## Uso

- `sys` — fastfetch con Sonic (`fastfetch/sonic.txt`).
- `n` — Neovim en el directorio actual.
- Git: `g`, `gs`, `gd`, `gcm`, `gcam`.

`DOTFILES` se resuelve al cargar `bashrc` o `zshrc` (raíz del clone, vía symlink).

`install.sh` deja **zsh** como shell de login con `sudo usermod` (si sudo no pide contraseña) o `chsh` (pedirá tu contraseña de usuario). Abre terminal nueva tras instalar.
