create_group () {
    local group_name=$1
    local group_id=$2

    if [ -z "$(getent group $group_name)" ]; then
        groupadd --gid $group_id $group_name
    fi
}

create_user () {
    local username=$1
    local user_id=$2

    if ! id $username &> /dev/null; then
        useradd -d /home/${username} --gid $user_group_id --uid $user_id $username
    fi
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
