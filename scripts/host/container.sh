#!/bin/bash
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

create_image() {
    local containerfile_path=$1
    local image_name=$2
    local context_path=$3
    local image_username=$4
    local image_user_id=$5
    local image_user_group_id=$6

    local username_arg=""
    local user_id_arg=""
    local user_group_id_arg=""

    if [ -n "${image_username}" ]; then
        username_arg="--build-arg USERNAME=${image_username}"
    fi

    if [ -n "${image_user_id}" ]; then
        user_id_arg="--build-arg USER_ID=${image_user_id}"
    fi

    if [ -n "${image_user_group_id}" ]; then
        user_group_id_arg="--build-arg USER_GROUP_ID=${image_user_group_id}"
    fi

    ${CONTAINER_COMMAND} build \
        -f ${containerfile_path} \
        -t ${image_name} \
        ${username_arg} \
        ${user_id_arg} \
        ${user_group_id_arg} \
        ${context_path}
}

create_volume() {
    local volume_name=$1

    if [[ $(check_volume_exists "${volume_name}") -eq $FALSE ]]; then
        if $CONTAINER_COMMAND volume create "$volume_name" >/dev/null 2>&1; then
            echo $TRUE
        else
            echo $FALSE
        fi
    else
        echo $FALSE
    fi
}

run_container() {
    local image_name=$1
    local container_name=$2
    local command=$3
    local volume_name=$4
    local volume_mount_dir=$5

    local mount_arg=""

    if [ -n "${volume_name}" ] && [ -n "${volume_mount_dir}" ]; then
        mount_arg="--mount type=volume,src=${volume_name},target=${volume_mount_dir}"
    fi

    $CONTAINER_COMMAND run \
        --replace \
        --user root \
        --name $container_name \
        ${mount_arg} \
        ${image_name} \
        ${command}
}

delete_container() {
    local container_name=$1

    $CONTAINER_COMMAND container rm $container_name
}