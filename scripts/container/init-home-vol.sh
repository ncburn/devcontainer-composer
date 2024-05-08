#!/bin/bash
destination_home_dir=$1
owner_name=$2
group_name=$3

if [ -z "${destination_home_dir}" ]; then
    echo "Please specify the home directory/path to initialize"

    exit 1
fi

if [ -z "${owner_name}" ]; then
    echo "Please specify the owner for the home directory"
fi

if [ -z "${group_name}" ]; then
    echo "Please specify the group for the home directory"
fi

echo "Copying files from /tmp/home to ${destination_home_dir}"
cp -R /tmp/home/* $destination_home_dir
mv "${destination_home_dir}/local" "${destination_home_dir}/.local"
mv "${destination_home_dir}/zshrc" "${destination_home_dir}/.zshrc"

echo "Setting file permissions"
chown -R "${owner_name}:${group_name}" $destination_home_dir
