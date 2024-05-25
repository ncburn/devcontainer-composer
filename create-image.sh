#! /bin/sh
set -e

source ./scripts/host/container.sh
source ./scripts/host/file.sh

if [ -z "${CONTAINER_COMMAND}" ]; then
    echo "podman and docker were not found and are required."

    exit 1
fi

print_usage() {
    echo "create-image.sh [options] -i image_name"
    echo "  -i image_name            Name of the image to create (Required)"
    echo "  -f containerfile_path    Path to the Containerfile (Required)"
    echo "  -c context_path          Context path"
    echo "  -h                       Print the script usage"
}

context_path=""
containerfile_path=""
image_name=""

while getopts ':c:f:i:h' parameter; do
    case "$parameter" in
    i)
        image_name="$OPTARG"
        ;;
    f)
        containerfile_path="$OPTARG"
        ;;
    c)
        context_path="$OPTARG"
        ;;
    h)
        print_usage
        ;;
    esac
done

if [ -z "${context_path}" ]; then
    context_path="$(get_parent_dir $(readlink -f ${BASH_SOURCE}))"
fi

if [ -z "${image_name}" ]; then
    echo "Missing image name"
    print_usage

    exit 1
fi

if [ -z "${containerfile_path}" ]; then
    echo "Missing path to the Containerfile/Dockerfile"
    print_usage

    exit 1
fi

create_image \
    $containerfile_path \
    $image_name \
    $context_path \
