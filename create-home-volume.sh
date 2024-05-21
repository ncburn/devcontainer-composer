#!/bin/bash
set -e

source ./scripts/host/container.sh
source ./scripts/host/file.sh

context_path="$(get_parent_dir $(readlink -f ${BASH_SOURCE}))"
containerfile_path="${context_path}/templates/home/Containerfile"
image_name="home-files"
volume_name=""

print_usage() {
    echo "Usage:"
    echo "  create-image-volume.sh [options] -v volume_name"
    echo "    -i image_name"
    echo "    -v volume_name"
    echo "    -f containerfile_path"
    echo "    -h help"
    echo ""
}

while getopts ':i:f:v:h' parameter; do
    case "$parameter" in
    i)
        image_name="$OPTARG"
        ;;
    f)
        containerfile_path="$OPTARG"
        ;;
    v)
        volume_name="$OPTARG"
        ;;
    h)
        print_usage
        ;;
    esac
done

if [ -z "${volume_name}" ]; then
    echo "Volume name is missing"
    print_usage

    exit 1
fi

echo "Creating initializer image ${image_name}..."
echo ""
create_image \
    $containerfile_path \
    $image_name \
    $context_path

if [ $(check_volume_exists "${volume_name}") -eq $TRUE ]; then
    echo "Volume '${volume_name}' already exists"

    return 1
fi

echo "Creating volume: '${volume_name}'"
echo ""
if [ $(create_volume "${volume_name}") -eq $FALSE ]; then
    echo "Volume '${volume_name}' could not created"

    return 1
fi

echo "Running initializer ${initializer_image_name}..."
echo ""
run_container \
    "${image_name}" \
    "${image_name}_init" \
    "sh /tmp/init_volume.sh /tmp/vol" \
    "${volume_name}" \
    "/tmp/vol"
