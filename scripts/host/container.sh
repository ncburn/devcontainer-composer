readonly TRUE=1
readonly FALSE=0

check_app_exists() {
    local app_name=$1

    if which $app_name >/dev/null 2>&1; then
        echo $TRUE
    else
        echo $FALSE
    fi
}

get_container_app_name() {
    if [ $(check_app_exists "podman") -eq $TRUE ]; then
        echo "podman"
    elif [ $(check_app_exists "docker") -eq $TRUE ]; then
        echo "docker"
    else
        echo ""
    fi
}

get_compose_app_name() {
    if [ $(check_app_exists "podman-compose") -eq $TRUE ]; then
        echo "podman-compose"
    elif [ $(check_app_exists "docker") -eq $TRUE ]; then
        echo "docker-compose"
    else
        echo ""
    fi  
}

readonly CONTAINER_COMMAND=$(get_container_app_name)
readonly COMPOSE_COMMAND=$(get_compose_app_name)

check_volume_exists() {
    local volume_name=$1

    if $CONTAINER_COMMAND volume exists "${volume_name}"; then
        echo $TRUE
    else
        echo $FALSE
    fi
}

create_devcontainer_image() {
    local containerfile_path=$1
    local image_name=$2
    local context_path=$3
    local owner=$4
    local group=$5

    ${CONTAINER_COMMAND} build \
        -f ${containerfile_path} \
        -t ${image_name} \
        --build-arg DEVCONTAINER_IMAGE_NAME=$username \
        --build-arg OWNER=$owner \
        --build-arg GROUP=$group \
        ${context_path}
}

create_initializer_image() {
    local containerfile_path=$1
    local devcontainer_image_name=$2
    local context_path=$3
    local owner=$4
    local group=$5
    local intializer_name="${devcontainer_image_name}_initializer"

    ${CONTAINER_COMMAND} build \
        -f ${containerfile_path} \
        -t  $intializer_name \
        --build-arg OWNER=$owner \
        --build-arg GROUP=$group \
        --build-arg DEVCONTAINER_IMAGE_NAME=$devcontainer_image_name \
        ${context_path}

    echo $intializer_name
}

create_volume() {
    local volume_name=$1

    if check_volume_exists "${volume_name}"; then
        $CONTAINER_COMMAND volume create "$volume_name"

        return 0
    fi

    return 1
}

run_initializer() {
    local intializer_name=$1
    local home_volume_name=$2
    local install_dir=$3

    $CONTAINER_COMMAND run \
        --replace \
        --name $intializer_name \
        --mount type=volume,source=${home_volume_name},target=$install_dir
        "localhost/${intializer_name}" \
        "${install_dir}"
}
