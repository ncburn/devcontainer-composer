#! /bin/bash
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

container_app_name=$(get_container_app_name)
if [ -z "${container_app_name}" ]; then
    echo "podman and/or docker were not found and are required."

    exit 1
fi

context_path="$(get_parent_dir $(readlink -f ${BASH_SOURCE}))"
username=developer
user_id=$(id -u)
user_group_id=$(id -g)

home_volume_name="${image_name}_home"
create_volume "${home_volume_name}"

${container_app_name} \
    build \
    -f ${containerfile_path} \
    -t ${image_name} \
    --build-arg USERNAME=$username \
    --build-arg USER_ID=$user_id \
    --build-arg USER_GROUP_ID=$user_group_id \
    ${context_path}
