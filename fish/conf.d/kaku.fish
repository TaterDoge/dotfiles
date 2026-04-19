# Kaku shell integration -- managed. Remove with: kaku reset
set -l _kaku_fish_init "$HOME/.config/kaku/fish/kaku.fish"
if test -f $_kaku_fish_init
    source $_kaku_fish_init
end
