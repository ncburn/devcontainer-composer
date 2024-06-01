#!/bin/bash
set -e

source ./scripts/host/container.sh

if [ -z "${CONTAINER_COMMAND}" ]; then
    echo "podman and docker were not found and are required."

    exit 1
fi

print_usage() {
    echo "create-volume.sh [options]"
    echo "  -v volume_name   Name of the volume to create (Required)"
    echo "  -i image_name    Name of the image used to mount volume and execute init scripts"
    echo "  -c command       Command to execute in the started container"
    echo "  -m mount_path    Path which the volume will be mounted to"
    echo "  -h               Print the script usage"
}

volume_name=""
image_name=""
command=""
mount_path=""

while getopts ':i:v:c:m:h' parameter; do
    case "$parameter" in
    i)
        image_name="$OPTARG"
        ;;
    v)
        volume_name="$OPTARG"
        ;;
    c)
        command="$OPTARG"
        ;;
    m)
        mount_path="$OPTARG"
        ;; 
    h)
        print_usage
        ;;
    esac
done

if [ -z "${volume_name}" ]; then
    echo "Missing the name of the volume to create"
    print_usage

    exit 1
fi

if [ $(check_volume_exists "${volume_name}") -eq $TRUE ]; then
    echo "Volume '${volume_name}' already exists"

    exit 1
fi

echo "Creating volume: '${volume_name}'"
if [ $(create_volume "${volume_name}") -eq $FALSE ]; then
    echo "Volume '${volume_name}' could not created"

    exit 1
fi

if [ -n "${image_name}" ] && [ -n "${command}" ] && [ -n "${mount_path}" ]; then
    echo "Running: ${command}"

    run_container \
        "${image_name}" \
        "${volume_name}_init" \
        "${command}" \
        "${volume_name}" \
        "${mount_path}"

    delete_container "${volume_name}_init" >1
fi
