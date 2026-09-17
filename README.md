# kitty dotfiles

Mi terminal: **kitty + fish + fastfetch + starship**, con paleta fija (no depende de ningún
tema dinámico del escritorio) y 15 imágenes para el logo de fastfetch.

```text
.config/
├── kitty/
│   ├── kitty.conf
│   └── themes/current-theme.conf
├── fish/
│   ├── config.fish
│   ├── fish_plugins
│   └── functions/fish_greeting.fish
├── fastfetch/
│   ├── config.jsonc
│   └── logo/          # imágenes que rotan en cada arranque
└── starship.toml
install.sh
```

## Instalación

### Kali / Debian / Ubuntu

```bash
sudo apt update
sudo apt install -y git curl
git clone https://github.com/hodowdf/dotfiles-terminal.git
cd dotfiles-terminal
chmod +x install.sh
./install.sh
```

El instalador:

- Instala `kitty`, `fish`, `fzf` y utilidades con `apt`.
- Instala **fastfetch** desde el `.deb` oficial y **starship** desde su release oficial
  (no están garantizados en los repos de Debian/Kali).
- Descarga e instala **JetBrains Mono Nerd Font** en `~/.local/share/fonts`.
- Instala los plugins de fish (`fisher`, `autopair`, `fzf.fish`).
- Copia las configuraciones a `~/.config` haciendo respaldo previo de lo que sobrescribe.

### Arch / CachyOS / derivados

```bash
sudo pacman -S --needed git curl
git clone https://github.com/hodowdf/dotfiles-terminal.git
cd dotfiles-terminal
./install.sh
```

Todo sale de los repos oficiales (`kitty fish starship fastfetch fzf xxd unzip`).

## Opciones

```bash
./install.sh --no-packages   # solo copia configuraciones (sin instalar nada)
./install.sh --uninstall     # restaura la copia de seguridad más reciente
```

## Después de instalar

1. Abre kitty (usa Fish como shell automáticamente).
2. Cada arranque muestra fastfetch con una imagen aleatoria de `~/.config/fastfetch/logo`.
3. El prompt lo dibuja Starship con la paleta incluida en `starship.toml`.

Añade más imágenes `.jpg` a `~/.config/fastfetch/logo/` para que roten también.

## Notas

- **Transparencia** (`background_opacity 0.7`): en Wayland/X11 con compositor se ve
  translúcido; sin compositor kitty la ignora. El desenfoque depende del escritorio.
- Opcionales pero recomendados: `eza` (para `ls --icons`), `zoxide` y `atuin`
  (se activan solos si están instalados).
- Si los iconos del prompt o de fastfetch salen como cuadros, falta la Nerd Font:
  ejecuta el instalador de nuevo o revísalo con `fc-list | grep -i jetbrains`.
- La escala/DPI del escritorio afecta al tamaño aparente; `font_size` está en 11.
