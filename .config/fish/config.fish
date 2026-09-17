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

    # Aliases
    alias clear "printf '\033[2J\033[3J\033[1;1H'" # fix: kitty doesn't clear scrollback properly
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"
    if command -v eza &>/dev/null
        alias ls 'eza --icons'
    end

    # fzf.fish (conf.d) binds Ctrl+T files, Alt+C cd, GitLog/Status, procesos y variables.
    # atuin toma control de Ctrl+R para búsqueda en historial.

    function ff
        set -l images ~/.config/fastfetch/logo/*.jpg
        if set -q images[1]
            fastfetch --logo $images[(random 1 (count $images))]
        else
            fastfetch
        end
    end
end
