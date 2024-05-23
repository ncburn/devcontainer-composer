#!/bin/bash
set -e

source ./scripts/host/container.sh
source ./scripts/host/file.sh

context_path="$(get_parent_dir $(readlink -f ${BASH_SOURCE}))"
containerfile_path="${context_path}/templates/home/Containerfile"
image_name="home-initializer"

print_usage() {
    echo "Usage:"
    echo "  create-home-initializer.sh [options]"
    echo "    -i image_name"
    echo "    -f containerfile_path"
    echo "    -h help"
    echo ""
}

while getopts ':i:f:h' parameter; do
    case "$parameter" in
    i)
        image_name="$OPTARG"
        ;;
    f)
        containerfile_path="$OPTARG"
        ;;
    h)
        print_usage
        ;;
    esac
done

echo "Creating home initializer ${image_name}..."
echo ""
create_image \
    $containerfile_path \
    $image_name \
    $context_path
