#!/bin/bash
print_usage() {
    echo "Usage:"
    echo "  init-volume.sh [options] -d destination_home_dir"
    echo "    -u username"
    echo "    -i user_id"
    echo "    -g group_id"
    echo "    -d destination_home_dir"
    echo "    -h help"
    echo ""
}

destination_home_dir=""
username=""
user_id=""
group_id=""

while getopts ':u:i:g:d:h' parameter; do
    case "$parameter" in
    u)
        username="$OPTARG"
        ;;
    i)
        user_id="$OPTARG"
        ;;
    g)
        group_id="$OPTARG"
        ;;
    d)
        destination_home_dir="$OPTARG"
        ;;
    h)
        print_usage
        ;;
    esac
done

if [ -z "${destination_home_dir}" ]; then
    echo "Please specify the home directory/path to initialize"

    exit 1
fi

echo "Copying files from /tmp/home to ${destination_home_dir}"
cp -R /tmp/home/* $destination_home_dir
mv "${destination_home_dir}/local" "${destination_home_dir}/.local"
mv "${destination_home_dir}/zshrc" "${destination_home_dir}/.zshrc"

if [ -z "${username}" ]; then
    exit 0
fi

if [ -z "${user_id}" ]; then
    exit 0
fi

if [ -z "${group_id}" ]; then
    exit 0
fi

addgroup -g $user_id $username
adduser -D -H -u $user_id -G $group_id $username
