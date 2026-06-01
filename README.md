# dotfiles

Configuración personal de shell, terminal y herramientas.

## Contenido

| Ruta | Destino |
|------|---------|
| `bash/bashrc` | `~/.bashrc` — **Oh My Bash** + tema **agnoster** |
| `bash/bash_aliases` | `~/.bash_aliases` |
| `git/gitconfig` | `~/.gitconfig` (nombre, email noreply GitHub, defaults) |
| `fastfetch/` | `~/.config/fastfetch/` (config + logo Sonic) |
| `konsole/` | perfiles en `~/.local/share/konsole/` |
| `konsole/konsolerc` | `~/.config/konsolerc` — perfil por defecto **Ale** |

## Stack

| Componente | Uso |
|------------|-----|
| [Oh My Bash](https://github.com/ohmybash/oh-my-bash) | Framework del shell (`~/.oh-my-bash`) |
| Tema **agnoster** | Prompt en `bash/bashrc` (`OSH_THEME=agnoster`) |
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
2. **agnoster** → incluido en OMB; se comprueba `themes/agnoster/`
3. **Hack** → paquete `fonts-hack`
4. **Powerline** (prompt agnoster) → paquete `fonts-powerline`

En otras distros, instala manualmente:

```bash
# Oh My Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended

# Hack: https://sourcefoundry.org/hack/
```

Tras `./install.sh`, Konsole abre con el perfil **Ale** por defecto.

## Uso

- `sys` — fastfetch con Sonic (`fastfetch/sonic.txt`).
- `n` — Neovim en el directorio actual.
- Git: `g`, `gs`, `gd`, `gcm`, `gcam`.

`DOTFILES` se resuelve al cargar `bashrc` (raíz del clone, vía symlink `~/.bashrc`).
