if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx PATH /opt/nanobrew/prefix/bin/ $PATH

    # 加载环境变量文件（如果存在）
    if test -f ~/.config/fish/.env
        # 逐行读取文件
        while read -l line
            # 跳过空行和注释行
            if string match -qr '^[^#]' -- "$line"
                # 分割键值对
                set -l kv (string split -m 1 = -- "$line")
                # 设置环境变量
                set -gx $kv[1] (string trim -- "$kv[2]")
            end
        end <~/.config/fish/.env
    end

    # 设置 shell 语言为中文
    set -gx LANG zh_CN.UTF-8
    set -gx LC_ALL zh_CN.UTF-8
    set -gx LC_CTYPE zh_CN.UTF-8

    # 默认编辑器
    set -gx EDITOR nvim

    # 真彩色
    set -gx COLORTERM truecolor

    # rust 环境变量
    set -gx PATH $HOME/.cargo/bin $PATH
    set -gx PATH $HOME/.local/bin $PATH

    # 添加pkg-config的环境路径
    set -gx PKG_CONFIG_PATH /opt/homebrew/opt/ruby/lib/pkgconfig

    # 配置pnpm的环境路径 -- node包管理器
    set -gx PATH /opt/homebrew/opt/pnpm/bin $PATH
    set -gx PATH $HOME/.local/share/pnpm $PATH

    # 配置 bun 环境路径
    set -gx PATH $HOME/.bun/bin $PATH

    # 配置安卓环境
    set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
    set -gx ANDROID_HOME $HOME/Library/Android/sdk
    set -gx PATH $ANDROID_HOME/platform-tools $PATH
    set -gx PATH $ANDROID_HOME/emulator $PATH
    set -gx PATH $ANDROID_HOME/tools $PATH

    # mise 包管理工具
    mise activate fish | source

    # 配置终端来初始化 starship -- shell美化工具
    starship init fish | source

    function yz
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    # nvim 别名
    alias v="nvim"
    alias n="neovide"

    # zellij 别名
    alias zj="zellij"

    # lsd 别名
    alias ls="lsd"

    # cat 别名
    alias cat="bat"

    alias cwd="pwd | pbcopy"

    alias op="opencode"

    # pnpm 别名
    # alias pi="pnpm run install"
    alias pd="pnpm run dev"
    alias pb="pnpm run build"
    alias ps="pnpm run start"

    # bun 别名
    alias bi="bun run install"
    alias bd="bun run dev"
    alias bb="bun run build"
    alias bs="bun run start"

    # 添加homebrew的环境路径
    set -gx PATH /opt/homebrew/bin $PATH
    set -gx PATH /opt/homebrew/sbin $PATH
end

# Added by ArcBox: command-line tools and integration
source "/Users/taterdoge/.arcbox/shell/init.fish" 2>/dev/null; or true

# >>> otty shell integration >>>
# Added by Otty — toggle in Settings > Shell > Shell Integration.
# Inert unless launched by Otty (it sets $OTTY_SHELL_INTEGRATION).
if test -n "$OTTY_SHELL_INTEGRATION" -a -r "$OTTY_SHELL_INTEGRATION/otty-integration.fish"
    source "$OTTY_SHELL_INTEGRATION/otty-integration.fish"
end
# <<< otty shell integration <<<
