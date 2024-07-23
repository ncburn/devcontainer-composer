#!/bin/sh
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
    echo "  -h               Print the script usage"
}

volume_name=""
image_name=""
mount_path="/tmp/vol"
username="developer"
user_id="$(id -u)"
group_id="$(id -g)"

while getopts ':i:v:h' parameter; do
    case "$parameter" in
    i)
        image_name="$OPTARG"
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
    echo "Missing the name of the volume to create"
    print_usage

    exit 1
fi

command_params="-s /tmp/home -t /tmp/vol -u ${username} -i ${user_id} -g ${group_id}"

if [ $(check_volume_exists "${volume_name}") -eq $TRUE ]; then
    echo "Volume '${volume_name}' already exists"

    exit 1
fi

echo "Creating volume: '${volume_name}'"
if [ $(create_volume "${volume_name}") -eq $FALSE ]; then
    echo "Volume '${volume_name}' could not created"

    exit 1
fi

run_container \
    "${image_name}" \
    "${volume_name}_init" \
    "${command_params}" \
    "${volume_name}" \
    "${mount_path}"

echo -n "Deleting: "
delete_container "${volume_name}_init"
