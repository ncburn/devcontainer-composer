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

if [ -z "${base_image_name}" ]; then
    exit 1
fi

if [ -z "${devcontainer_username}" ]; then
    exit 1
fi

if [ -z "${containerfile_path}" ]; then
    exit 1
fi

home_volume_name="${base_image_name}_home"
initializer_image_name="${base_image_name}_initializer"

echo "Creating initializer image ${initializer_image_name}"
echo ""
create_initializer_image \
    $containerfile_path \
    $base_image_name \
    $initializer_image_name \
    $context_path

if [ $(check_volume_exists "${home_volume_name}") -eq $FALSE ]; then
    echo "Creating volume: ${home_volume_name}"
    echo ""
    if [ $(create_volume "${home_volume_name}") -eq $FALSE ]; then
        echo "Volume '${home_volume_name}' not created"

        return 1
    fi

    echo "Running initializer ${initializer_image_name}"
    echo ""
    run_initializer \
        "${initializer_image_name}" \
        "${home_volume_name}" \
        "/home/${devcontainer_username}" \
        $devcontainer_username \
        $devcontainer_username
fi
