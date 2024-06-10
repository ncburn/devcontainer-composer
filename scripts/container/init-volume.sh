#!/bin/bash
source /etc/os-release

user_script_path=""

if [ "${ID}" = "alpine" ]; then
    user_script_path="/tmp/user_busybox.sh"
else
    user_script_path="/tmp/user.sh"
fi

echo "User script: ${user_script_path}"
source ${user_script_path}

print_usage() {
    echo "Usage:"
    echo "  init-volume.sh [options]"
    echo "    -s source_dir    (Required)"
    echo "    -t target_dir    (Required)"
    echo "    -u username"
    echo "    -i user_id"
    echo "    -g group_id"
    echo "    -h help"
    echo ""
}

target_dir=""
source_dir=""
username=""
user_id=""
group_id=""

while getopts ':s:t:u:i:g:h' parameter; do
    case "$parameter" in
    s)
        source_dir="$OPTARG"
        ;;
    t)
        target_dir="$OPTARG"
        ;;
    u)
        username="$OPTARG"
        ;;
    i)
        user_id="$OPTARG"
        ;;
    g)
        group_id="$OPTARG"
        ;;
    h)
        print_usage
        ;;
    esac
done

if [ -z "${source_dir}" ]; then
    echo "Missing source directory where files will be copied from"
    print_usage

    exit 1
fi

if [ -z "${target_dir}" ]; then
    echo "Missing target directory where files will be copied from"
    print_usage

    exit 1
fi

echo "Copying files from ${source_dir} to ${target_dir}"
cp -R ${source_dir}/* ${target_dir}
mv ${target_dir}/local ${target_dir}/.local
mv ${target_dir}/bashrc ${target_dir}/.bashrc

if [ -z "${username}" ]; then
    exit 0
fi

if [ -z "${user_id}" ]; then
    exit 0
fi

if [ -z "${group_id}" ]; then
    exit 0
fi

create_group ${username} ${group_id}
create_user ${username} ${user_id} ${group_id}

chown -R ${user_id}:${group_id} ${target_dir}
