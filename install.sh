#!/usr/bin/env bash
# Dotfiles de terminal (kitty + fish + fastfetch + starship)
# Instalador para Debian/Kali/Ubuntu y Arch (y derivados).
#
#   ./install.sh                instalación completa
#   ./install.sh --no-packages  solo copia configuraciones
#   ./install.sh --uninstall    restaura la copia de seguridad más reciente

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${SCRIPT_DIR}/.config"
TARGET="${HOME}/.config"
BACKUP_DIR="${HOME}/.config/kitty-dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
FONT_DIR="${HOME}/.local/share/fonts"
FONT_RELEASE="v3.5.1"
FONT_ZIP_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_RELEASE}/JetBrainsMono.zip"
FONT_ZIP_SHA256="fab782a66f7d3019da64f6572db9fc5d3a4bcb19f9fa13e2d8a62e3693d6396e"
STARSHP_RELEASE="v1.26.0"

INSTALL_PACKAGES=1
UNINSTALL=0

log()  { printf '\033[1;36m[install]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[aviso]\033[0m %s\n' "$1"; }
die()  { printf '\033[1;31m[error]\033[0m %s\n' "$1" >&2; exit 1; }

usage() {
  cat <<'EOF'
Uso: ./install.sh [opciones]

Opciones:
  --no-packages   No instalar paquetes ni fuentes; solo copiar configuraciones
  --uninstall     Restaurar la copia de seguridad más reciente
  -h, --help      Mostrar esta ayuda
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-packages) INSTALL_PACKAGES=0 ;;
    --uninstall)   UNINSTALL=1 ;;
    -h|--help)     usage; exit 0 ;;
    *) printf 'Opción desconocida: %s\n\n' "$1" >&2; usage >&2; exit 1 ;;
  esac
  shift
done

# ---------------------------------------------------------------------------
# Uninstall: restaura la copia de seguridad más reciente
# ---------------------------------------------------------------------------
if [[ "$UNINSTALL" -eq 1 ]]; then
  latest="$(ls -1dt "${HOME}"/.config/kitty-dotfiles-backup-* 2>/dev/null | head -n1 || true)"
  [[ -n "$latest" ]] || die "No hay copias de seguridad para restaurar"
  log "Restaurando desde ${latest}"
  while IFS= read -r src; do
    rel="${src#"${latest}"/}"
    [[ -n "$rel" ]] || continue
    mkdir -p "$(dirname "${TARGET}/${rel}")"
    cp -a "$src" "${TARGET}/${rel}"
    log "Restaurado .config/${rel}"
  done < <(find "$latest" -mindepth 1 | sort)
  log "Listo. Reinicia kitty para ver los cambios."
  exit 0
fi

[[ -d "$CONFIG_DIR" ]] || die "No se encontró ${CONFIG_DIR}"

# ---------------------------------------------------------------------------
# Copia de seguridad (solo archivos que vamos a sobrescribir)
# ---------------------------------------------------------------------------
backup_file() {
  local rel="$1" dst="${TARGET}/$1"
  [[ -e "$dst" ]] || return 0
  mkdir -p "$(dirname "${BACKUP_DIR}/${rel}")"
  cp -a "$dst" "${BACKUP_DIR}/${rel}"
  log "Respaldo de .config/${rel}"
}

# ---------------------------------------------------------------------------
# Detección de distribución
# ---------------------------------------------------------------------------
pkg_install() {
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y "$@"
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed -- "$@"
  else
    return 1
  fi
}

# ---------------------------------------------------------------------------
# Paquetes base
# ---------------------------------------------------------------------------
if [[ "$INSTALL_PACKAGES" -eq 1 ]]; then
  command -v sudo >/dev/null 2>&1 || die "Se necesita sudo para instalar paquetes"

  if command -v apt-get >/dev/null 2>&1; then
    log "Instalando paquetes (Debian/Kali/Ubuntu)..."
    pkg_install kitty fish curl unzip xxd fzf
    # starship y fastfetch no siempre están en los repos; se instalan aparte.
  elif command -v pacman >/dev/null 2>&1; then
    log "Instalando paquetes (Arch)..."
    pkg_install kitty fish starship fastfetch curl unzip xxd fzf
  else
    warn "No se detectó apt ni pacman; instala kitty, fish, starship, fastfetch, xxd, fzf y unzip a mano."
  fi

  # fastfetch desde .deb oficial si no está instalado (Debian/Kali/Ubuntu)
  if ! command -v fastfetch >/dev/null 2>&1 && command -v apt-get >/dev/null 2>&1; then
    case "$(uname -m)" in
      x86_64)  ff_arch="amd64" ;;
      aarch64) ff_arch="aarch64" ;;
      *) ff_arch="" ;;
    esac
    if [[ -n "$ff_arch" ]]; then
      tmp="$(mktemp -d)"
      log "Descargando fastfetch (${ff_arch})..."
      curl -fsSLo "${tmp}/fastfetch.deb" "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-${ff_arch}.deb"
      sudo dpkg -i "${tmp}/fastfetch.deb" || sudo apt-get install -f -y
      rm -rf "$tmp"
    fi
  fi

  # starship oficial si no está instalado (Debian/Kali/Ubuntu)
  if ! command -v starship >/dev/null 2>&1; then
    case "$(uname -m)" in
      x86_64)  st_arch="x86_64" ;;
      aarch64) st_arch="aarch64" ;;
      *) st_arch="" ;;
    esac
    if [[ -n "$st_arch" ]]; then
      log "Descargando starship (${st_arch})..."
      curl -fsSLo /tmp/starship.tar.gz "https://github.com/starship/starship/releases/download/${STARSHP_RELEASE}/starship-${st_arch}-unknown-linux-musl.tar.gz"
      sudo tar -xzf /tmp/starship.tar.gz -C /usr/local/bin starship
      rm -f /tmp/starship.tar.gz
    fi
  fi

  # JetBrains Mono Nerd Font (la necesitan los iconos del prompt y de fastfetch)
  if ! fc-list 2>/dev/null | grep -i "JetBrainsMono Nerd" >/dev/null; then
    log "Instalando JetBrains Mono Nerd Font..."
    mkdir -p "$FONT_DIR"
    tmp="$(mktemp -d)"
    curl -fsSLo "${tmp}/JetBrainsMono.zip" "$FONT_ZIP_URL"
    echo "$FONT_ZIP_SHA256  ${tmp}/JetBrainsMono.zip" | sha256sum -c - >/dev/null \
      || { rm -rf "$tmp"; die "El zip de la fuente no coincide con el SHA256 esperado"; }
    unzip -oq "${tmp}/JetBrainsMono.zip" -d "${FONT_DIR}/JetBrainsMonoNerdFont"
    rm -rf "$tmp"
    fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true
  else
    log "JetBrains Mono Nerd Font ya está instalada"
  fi

  # Plugins de fish (fisher) — autopair y fzf.fish
  if command -v fish >/dev/null 2>&1; then
    log "Instalando plugins de fish (fisher)..."
    fish -c 'curl -fsSL https://git.io/fisher | source && fisher install jorgebucaran/fisher' >/dev/null 2>&1 || \
      warn "No se pudo instalar fisher; instala los plugins de fish_plugins a mano"
    fish -c 'fisher update' >/dev/null 2>&1 || true
  fi
fi

# ---------------------------------------------------------------------------
# Copiar configuraciones
# ---------------------------------------------------------------------------
[[ "$INSTALL_PACKAGES" -eq 1 ]] || log "Modo --no-packages: solo se copian configuraciones"

while IFS= read -r src; do
  rel="${src#"${CONFIG_DIR}"/}"
  backup_file "$rel"
  mkdir -p "$(dirname "${TARGET}/${rel}")"
  cp -a "$src" "${TARGET}/${rel}"
  log "Instalado .config/${rel}"
done < <(find "$CONFIG_DIR" -mindepth 1 \( -path '*/fish/logo/*' -o -path '*/fastfetch/logo/*' \) -prune -o -type f -print | sort)

# Images live outside .config/<tool> so they survive a full fish/fastfetch sync
if [[ -d "${CONFIG_DIR}/fastfetch/logo" ]]; then
  mkdir -p "${TARGET}/fastfetch/logo"
  for img in "${CONFIG_DIR}/fastfetch/logo/"*; do
    [[ -e "$img" ]] || continue
    backup_file "fastfetch/logo/$(basename "$img")"
    cp -a "$img" "${TARGET}/fastfetch/logo/"
  done
  log "Instalado .config/fastfetch/logo (${img##*/} y anteriores)"
fi

# ---------------------------------------------------------------------------
# Verificación
# ---------------------------------------------------------------------------
log "Verificación:"
for cmd in kitty fish fastfetch starship; do
  if command -v "$cmd" >/dev/null 2>&1; then
    log "  $cmd ✓"
  else
    warn "  $cmd no está instalado"
  fi
done
if fc-list 2>/dev/null | grep -i "JetBrainsMono Nerd" >/dev/null; then
  log "  JetBrains Mono Nerd Font ✓"
else
  warn "  JetBrains Mono Nerd Font no encontrada (los iconos se verán mal)"
fi

log "Listo. Abre kitty para ver tu configuración."
[[ -d "$BACKUP_DIR" ]] && log "Copia de seguridad: ${BACKUP_DIR}"
