# dotfiles

Configuración de shell, terminal y herramientas. Pensado para clonar y adaptar: `./install.sh` pide tu identidad de Git; `./als-install.sh` es la variante personal con `git/gitconfig` fijo del repo.

## Contenido

| Ruta | Destino |
|------|---------|
| `bash/bashrc` | `~/.bashrc` — **Oh My Bash** + tema **agnoster** |
| `bash/bash_aliases` | `~/.bash_aliases` (también cargado desde zsh) |
| `zsh/zshrc` | `~/.zshrc` — **Oh My Zsh** + **agnoster** + resaltado al escribir |
| `git/gitconfig` | `~/.gitconfig` — solo con `./als-install.sh` (identidad als-code) |
| `git/gitconfig.base` | Plantilla de defaults Git (sin `[user]`; la usa `./install.sh`) |
| `fastfetch/` | `~/.config/fastfetch/` (config + logo Sonic) |
| `konsole/` | perfiles en `~/.local/share/konsole/` |
| `konsole/konsolerc` | `~/.config/konsolerc` — perfil por defecto **Ale** |

### Scripts

| Script | Descripción |
|--------|-------------|
| `install.sh` | Instalación genérica (pregunta `user.name` / `user.email`) |
| `als-install.sh` | Instalación personal — enlaza `git/gitconfig` del repo |
| `bootstrap-deps.sh` | Solo dependencias (OMB, OMZ, fuentes, nala, …) |
| `lib/install-core.sh` | Lógica compartida de symlinks y bootstrap (no ejecutar a mano) |

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
| [nala](https://gitlab.com/volian/nala) | Front-end de `apt` (barra de progreso, salida legible) |
| [Konsole](https://apps.kde.org/konsole/) | Terminal KDE |

El prompt **agnoster** usa glifos Powerline; los scripts de instalación intentan instalar `fonts-powerline` además de **Hack** (Konsole).

Opcionales en aliases: `eza`, `bat`, `nvim`.

## Instalación

Clona el repo donde quieras. Hay dos scripts de instalación:

| Script | Uso |
|--------|-----|
| `./install.sh` | **Genérico** — pregunta `user.name` y `user.email` y **genera** `~/.gitconfig` (no guarda tokens ni credenciales) |
| `./als-install.sh` | **Personal (Ale)** — **enlaza** `git/gitconfig` del repo (als-code + noreply GitHub) |

```bash
git clone https://github.com/als-code/dotfiles.git
cd dotfiles
chmod +x install.sh als-install.sh bootstrap-deps.sh

# Cualquiera: pide nombre y email de Git
./install.sh

# Solo en mi máquina / identidad fija del repo
./als-install.sh

source ~/.zshrc
```

Sin TTY (CI, remoto), pasa identidad explícita:

```bash
./install.sh --git-name "tu-usuario" --git-email "tu@email.com"
# o
GIT_USER_NAME="tu-usuario" GIT_USER_EMAIL="tu@email.com" ./install.sh
```

Solo dependencias (sin symlinks) — válido con ambos scripts:

```bash
./install.sh --deps-only
# o
./als-install.sh --deps-only
# o
./bootstrap-deps.sh
```

Solo symlinks (si ya tienes OMB, Hack, etc.):

```bash
./install.sh --no-deps
./als-install.sh --no-deps
```

### Dependencias (Debian/Ubuntu)

`bootstrap-deps.sh` hace lo siguiente si falta algo:

1. **Oh My Bash** → clone en `~/.oh-my-bash`
2. **agnoster** (bash) → incluido en OMB
3. **zsh** → paquete `zsh`
4. **Oh My Zsh** → clone en `~/.oh-my-zsh`
5. **agnoster** (zsh) + plugins **syntax-highlighting** y **autosuggestions**
6. **Shell por defecto** → `chsh -s` a zsh (desde `install.sh` / `als-install.sh`)
7. **Hack** → paquete `fonts-hack`
8. **Powerline** (prompt agnoster) → paquete `fonts-powerline`
9. **nala** → paquete `nala` (front-end de apt)

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

Tras instalar, Konsole abre con el perfil **Ale** por defecto.

## Uso

- `sys` — fastfetch con Sonic (`fastfetch/sonic.txt`).
- `n` — Neovim en el directorio actual.
- `apt` — en bash y zsh redirige a **nala** (`apt update`, `sudo apt install …`, etc.). Tras instalar, recarga el shell (`exec zsh` o terminal nueva).
- Git: `g`, `gs`, `gd`, `gcm`, `gcam`.

`DOTFILES` se resuelve al cargar `bashrc` o `zshrc` (raíz del clone, vía symlink).

`install.sh` y `als-install.sh` dejan **zsh** como shell de login con `sudo usermod` (si sudo no pide contraseña) o `chsh` (pedirá tu contraseña de usuario). Abre terminal nueva tras instalar.
