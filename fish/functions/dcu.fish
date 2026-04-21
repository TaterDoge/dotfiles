function dcu
    set -l docker_root ~/docker

    if not command -q docker; or not docker info &>/dev/null
        echo "⚠️  Docker 未运行，跳过容器升级"
        return 0
    end

    set -l services
    if test (count $argv) -gt 0
        for svc in $argv
            set -l svc_dir "$docker_root/$svc"
            if test -f "$svc_dir/docker-compose.yml"
                set -a services $svc_dir
            else
                echo "⚠️  跳过 $svc: 未找到 $svc_dir/docker-compose.yml"
            end
        end
    else
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
