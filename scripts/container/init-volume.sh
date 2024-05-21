#!/bin/bash
destination_home_dir=$1

if [ -z "${destination_home_dir}" ]; then
    echo "Please specify the home directory/path to initialize"

    exit 1
fi

echo "Copying files from /tmp/home to ${destination_home_dir}"
cp -R /tmp/home/* $destination_home_dir
mv "${destination_home_dir}/local" "${destination_home_dir}/.local"
mv "${destination_home_dir}/zshrc" "${destination_home_dir}/.zshrc"
