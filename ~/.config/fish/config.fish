if status is-interactive
    # No greeting
    set fish_greeting

    # Use starship prompt
    if command -v starship &>/dev/null
        starship init fish | source
    end

    # zoxide — smart cd (z + fragment)
    if command -v zoxide &>/dev/null
        zoxide init fish | source
    end

    # atuin — cross-session history (Ctrl+R, already handled by fzf.fish fallback)
    if command -v atuin &>/dev/null
        atuin init fish --disable-up-arrow | source
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

    # fzf.fish (conf.d) binds Ctrl+T files, Alt+C cd, GitLog/Status, procesos y variables.
    # atuin toma control de Ctrl+R para búsqueda en historial.
    alias q 'inir run'

    function ff
    set image (find ~/Imágenes/fastfetch-imagenes -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | shuf -n 1)

    fastfetch --logo "$image"
end

end
