#!/bin/bash
print_usage() {
    echo "Usage:"
    echo "  init-volume.sh [options]"
    echo "    -s source_dir    (Required)"
    echo "    -t target_dir    (Required)"
    echo "    -h help"
    echo ""
}

target_dir=""
source_dir=""

while getopts ':s:t:h' parameter; do
    case "$parameter" in
    s)
        source_dir="$OPTARG"
        ;;
    t)
        target_dir="$OPTARG"
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
