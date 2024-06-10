get_group_name() {
    local group_info=$1

    echo $(getent group $group_info | awk -F : '{print $1}')
}

get_username() {
    local user_info=$1

    echo $(getent passwd $user_info | awk -F : '{print $1}')
}

create_group () {
    local group_name=$1
    local group_id=$2

    addgroup -g $group_id $group_name
}

create_user () {
    local username=$1
    local user_id=$2
    local group_info=$3

    group_name=$(get_group_name $group_info)

    adduser -D -H -h /home/${username} -G $group_name -u $user_id $username
}

enable_sudo () {
    local username=$1
    
    echo "enable_sudo: ${username}"

    if [ ! -d "/etc/sudoers.d" ]; then
        mkdir -p /etc/sudoers.d
    fi

    echo "${username} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${username}
    chmod 440 /etc/sudoers.d/${username}
}
