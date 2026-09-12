# Font
font_family      JetBrains Mono Nerd Font
font_size 11.0

# Cursor
cursor_shape beam
cursor_trail 1

# Padding (consistency with foot)
window_margin_width 21.75

# No close confirmation
confirm_os_window_close 0

# Use fish shell
shell fish

# Include generated theme colors
include current-theme.conf

#backgaund opacity
background_opacity 0.7

# Copy
map ctrl+c    copy_or_interrupt

# Search
map ctrl+f   launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id
map kitty_mod+f   launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id

# Scroll & Zoom
map page_up    scroll_page_up
map page_down    scroll_page_down

map ctrl+plus  change_font_size all +1
map ctrl+equal  change_font_size all +1
map ctrl+kp_add  change_font_size all +1
map ctrl+minus       change_font_size all -1
map ctrl+underscore       change_font_size all -1
map ctrl+kp_subtract       change_font_size all -1
map ctrl+0 change_font_size all 0
map ctrl+kp_0 change_font_size all 0
󰪢 0s 󰜥 󰉋  ••/mkhmtdots 󰜥 󰘬 main 
    cat ~/.config/fastfetch/config.jsonc
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
    "source": "/home/feli/Imágenes/fastfetch-imagenes/*.jpg",
    "type": "auto",
    "position": "left",
    "width": 20,
    "height": 10,
},
    "display": {
        "separator": "  ",
        "color": { "keys": "green", "output": "blue", "title": "green" },
        "constants": ["\u001b[32m", "\u001b[32m"]
    },
    "modules": [
        {
            "type": "custom",
            "key": "  ╭─Hodow-Feli─╮"
        },
        {
            "type": "command",
            "key": "  │ {$2}{$1}  usuario │",
            "text": "echo $USER"
        },
        {
            "type": "kernel",
            "key": "  │ {$2}{$1}  kernel  │"
        },
        {
            "type": "os",
            "key": "  │ {$2}{$1}  os      │"
        },
        {
            "type": "wm",
            "key": "  │ 󱂬  wm      │"
        },
        {
            "type": "terminal",
            "key": "  │   terminal│",
            "folder": "/"
        },
        {
            "type": "memory",
            "key": "  │ {$2}{$1}  memoria │"
        },
        {
            "type": "uptime",
            "key": "  │ 󰋊  Uptime  │"
        },
        {
            "type": "datetime",
            "key": "  │ 󰸗  fecha   │"
        },
        {
            "type": "packages",
            "key": "  │   Paquetes│"
        },
        {
            "type": "custom",
            "key": "  ╰────────────╯"
        },
        {
            "type": "colors",
            "key": "  ",
            "symbol": "circle"
        }
    ]
}
󰪢 0s 󰜥 󰉋  ••/mkhmtdots 󰜥 󰘬 main 
    cat ~/.config/fish/config.fish
if status is-interactive
    # No greeting
    set fish_greeting

    # Use starship prompt
    if command -v starship &>/dev/null
        starship init fish | source
    end

    # Apply terminal color sequences (Material You from wallpaper)
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias clear "printf '\033[2J\033[3J\033[1;1H'" # fix: kitty doesn't clear scrollback properly
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"
    if command -v eza &>/dev/null
        alias ls 'eza --icons'
    end
    alias q 'inir run'

    function ff
    set image (find ~/Imágenes/fastfetch-imagenes -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | shuf -n 1)

    fastfetch --logo "$image"
end

end
