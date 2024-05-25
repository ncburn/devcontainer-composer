#!/bin/sh
username=$1
user_id=$2
user_group_id=$3

source /tmp/user.sh

echo "Creating user: ${username}"

create_group $username $user_group_id
create_user $username $user_id
enable_sudo $username
