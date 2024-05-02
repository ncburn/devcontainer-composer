#! /bin/bash
set -e

print_usage() {
    echo -e "\nUsage: -d path/to/devcontainer/files -n name_of_image"
}

source ./scripts/host/container.sh
source ./scripts/host/file.sh

devcontainer_dir_path=''
image_name=''
while getopts ':d:n:' parameter; do
    case "$parameter" in
    d)
        devcontainer_dir_path="$OPTARG"
        ;;
    n)
        image_name="$OPTARG"
        ;;
    esac
done

if [ -z "${devcontainer_dir_path}" ]; then
    echo "Missing path to directory containing devcontainer Containerfile"
    print_usage

    exit 1
fi

if [ -z "${image_name}" ]; then
    echo "Missing image name"
    print_usage

    exit 1
fi

containerfile_path="${devcontainer_dir_path}/Containerfile"
if [ ! -e "${containerfile_path}" ]; then
    echo "${devcontainer_dir_path} does not contain a Containerfile"

    exit 1
fi

if [ -z "${CONTAINER_COMMAND}" ]; then
    echo "podman and/or docker were not found and are required."

    exit 1
fi

context_path="$(get_parent_dir $(readlink -f ${BASH_SOURCE}))"
username=developer
user_id=$(id -u)
user_group_id=$(id -g)

create_devcontainer_image \
    $containerfile_path \
    $image_name \
    $context_path \
    $username \
    $user_id \
    $user_group_id

home_volume_name="${image_name}_home"

if ! check_volume_exists "${home_volume_name}"; then
    intializer_name=$(create_initializer_image \
        "templates/home-vol-initializer/Containerfile" \
        $image_name \
        $context_path \
        $username \
        $username)

    create_volume "${home_volume_name}"
    run_initializer $intializer_name "${home_volume_name}" "/home/${username}"
fi
