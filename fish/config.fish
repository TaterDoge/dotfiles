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
                set -gx $kv[1] (string trim -- $kv[2])
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

    function update
        nb upgrade
        and mise upgrade
        and bun update --global --latest
    end

    # Docker Compose 批量升级
    # 用法: dcu          — 升级 ~/docker/ 下所有服务
    #       dcu s1 s2    — 仅升级指定服务
    function dcu
        set -l docker_root ~/docker

        if not command -q docker; or not docker info &>/dev/null
            echo "⚠️  Docker 未运行，跳过容器升级"
            return 0
        end

        # 收集待升级的服务目录
        set -l services
        if test (count $argv) -gt 0
            # 指定了服务名，验证目录是否存在
            for svc in $argv
                set -l svc_dir "$docker_root/$svc"
                if test -f "$svc_dir/docker-compose.yml"
                    set -a services $svc_dir
                else
                    echo "⚠️  跳过 $svc: 未找到 $svc_dir/docker-compose.yml"
                end
            end
        else
            # 自动发现所有服务
            for compose_file in $docker_root/*/docker-compose.yml
                set -a services (path dirname $compose_file)
            end
        end

        if test (count $services) -eq 0
            echo "📭 没有找到需要升级的 Docker 服务"
            return 0
        end

        echo "🐳 准备升级 "(count $services)" 个 Docker 服务..."
        set -l failed 0

        for svc_dir in $services
            set -l svc_name (path basename $svc_dir)
            echo ""
            echo "━━━ 🔄 升级 $svc_name ━━━"

            if docker compose -f "$svc_dir/docker-compose.yml" pull
                and docker compose -f "$svc_dir/docker-compose.yml" up -d
                echo "✅ $svc_name 升级完成"
            else
                echo "❌ $svc_name 升级失败"
                set failed (math $failed + 1)
            end
        end

        echo ""
        docker image prune -f
        echo ""

        if test $failed -eq 0
            echo "🐳 全部服务升级完成"
        else
            echo "⚠️  $failed 个服务升级失败"
            return 1
        end
    end

    # nvim 别名
    alias v="nvim"
    alias n="neovide"

    # zellij 别名
    alias zj="zellij"

    # lsd 别名
    alias ls="lsd"

    alias cwd="pwd | pbcopy"

    alias op="opencode"

    # pnpm 别名
    alias pi="pnpm run install"
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

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
