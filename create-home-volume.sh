#!/bin/bash
set -e

source ./scripts/host/container.sh

username=developer
user_id=$(id -u)
user_group_id=$(id -g)
image_name="home-initializer"
volume_name=""

print_usage() {
    echo "Usage:"
    echo "  create-home-volume.sh [options] -v volume_name"
    echo "    -i image_name"
    echo "    -v volume_name"
    echo "    -h help"
    echo ""
}

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

if [ $(check_volume_exists "${volume_name}") -eq $TRUE ]; then
    echo "Volume '${volume_name}' already exists"

    exit 1
fi

echo "Creating volume: '${volume_name}'"
echo ""
if [ $(create_volume "${volume_name}") -eq $FALSE ]; then
    echo "Volume '${volume_name}' could not created"

    exit 1
fi

echo "Running initializer ${initializer_image_name}..."
echo ""
run_container \
    "${image_name}" \
    "${image_name}_init" \
    "sh /tmp/init-volume.sh -d /tmp/vol " \
    "${volume_name}" \
    "/tmp/vol"
