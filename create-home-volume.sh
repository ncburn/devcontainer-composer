#!/bin/bash
set -e

source ./scripts/host/container.sh
source ./scripts/host/file.sh

context_path="$(get_parent_dir $(readlink -f ${BASH_SOURCE}))"
devcontainer_image_name=''
devcontainer_username=''
containerfile_path="${context_path}/templates/home/Containerfile"

print_usage() {
    echo "create-image-volume.sh [options]"
    echo "  -i devcontainer_image_name"
    echo "  -u devcontainer_username"
    echo "  -f containerfile_path #Optional"
    echo "  -h help"
}

while getopts ':i:u:f:h' parameter; do
    case "$parameter" in
    i)
        devcontainer_image_name="$OPTARG"
        ;;
    u)
        devcontainer_username="$OPTARG"
        ;;
    f)
        containerfile_path="$OPTARG"
        ;;
    h)
        print_usage
        ;;
    esac
done

if [ -z "${devcontainer_image_name}" ]; then
    "Devcontainer image name is missing"
    print_usage

    exit 1
fi

if [ -z "${devcontainer_username}" ]; then
    "Devcontainer username is missing"
    print_usage

    exit 1
fi

if [ -z "${containerfile_path}" ]; then
    echo "Containerfile path can not be an empty string"

    exit 1
fi

home_volume_name="${devcontainer_image_name}_home"
initializer_image_name="${devcontainer_image_name}_initializer"

echo "Creating initializer image ${initializer_image_name}..."
echo ""
create_initializer_image \
    $containerfile_path \
    $devcontainer_image_name \
    $initializer_image_name \
    $context_path

if [ $(check_volume_exists "${home_volume_name}") -eq $FALSE ]; then
    echo "Creating volume: '${home_volume_name}'"
    echo ""
    if [ $(create_volume "${home_volume_name}") -eq $FALSE ]; then
        echo "Volume '${home_volume_name}' could not created"

        return 1
    fi
else
    echo "${home_volume_name} already exists. Skipping volume creation"
fi

echo "Running initializer ${initializer_image_name}..."
echo ""
run_initializer \
    "${initializer_image_name}" \
    "${home_volume_name}" \
    "/home/${devcontainer_username}" \
    $devcontainer_username \
    $devcontainer_username
