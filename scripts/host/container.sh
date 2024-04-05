has_app() {
    local app_name=$1

    IFS=':' local whereis_results=( $(whereis app_name) )

    echo ${#whereis_results[@]}

    if [ ${#whereis_results[@]} -lt 1 ]; then
        return 0
    else
        return 1
    fi
}

get_container_app_name() {
    if [ $(has_app "podman") -eq 1 ]; then
        echo "podman"
    elif [ $(has_app "docker") -eq 1]; then
        echo "docker"
    else
        echo ""
    fi
}

get_compose_app_name() {
    if [ $(has_app "podman-compose") -eq 1 ]; then
        echo "podman-compose"
    elif [ $(has_app "docker") -eq 1]; then
        echo "docker-compose"
    else
        echo ""
    fi  
}

create_volume() {
    local volume_name=$1
    local container_command=$(get_container_app_name)

    if ! $container_command volume exists "${volume_name}"; then
        $container_command volume create "$volume_name"  
    fi
}
