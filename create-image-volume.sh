#!/bin/bash
set -e

source ./scripts/host/container.sh
source ./scripts/host/file.sh

context_path="$(get_parent_dir $(readlink -f ${BASH_SOURCE}))"
base_image_name=''
devcontainer_username=''
containerfile_path=''

while getopts ':i:u:f:' parameter; do
    case "$parameter" in
    i)
        base_image_name="$OPTARG"
        ;;
    u)
        devcontainer_username="$OPTARG"
        ;;
    f)
        containerfile_path="$OPTARG"
        ;;
    esac
done

home_volume_name="${base_image_name}_home"
created_image=$(create_initializer_image $containerfile_path $base_image_name $context_path $devcontainer_username 2>&1)

if [ $(check_volume_exists "${home_volume_name}") -eq $FALSE ]; then
    create_volume "${home_volume_name}"
    run_initializer $created_image "${home_volume_name}" "/home/${devcontainer_username}"
fi
