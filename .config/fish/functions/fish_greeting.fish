function fish_greeting
    set -l images ~/.config/fastfetch/logo/*.jpg
    if command -v fastfetch >/dev/null
        if set -q images[1]
            fastfetch --logo $images[(random 1 (count $images))]
        else
            fastfetch
        end
    end
end
