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
        useradd -d /home/${username} --gid $user_group_id --uid $user_id -s /bin/zsh $username
    fi
}

enable_sudo () {
    local username=$1
    
    if [ ! -d "/etc/sudoers.d" ]; then
        mkdir -p /etc/sudoers.d
    fi

    echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
    chmod 0440 /etc/sudoers.d/$USERNAME
}
