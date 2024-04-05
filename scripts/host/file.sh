get_absolute_path() {
    local relative_path=$1

    echo $(realpath "${relative_path}")
}

get_parent_dir() {
    local path=$1

    echo $(dirname "${path}")
}

get_base_name() {
    local path=$1

    echo $(basename "${path}")
}

get_script_path() {
    echo "$(readlink -f "${BASH_SOURCE}")"
}

has_containerfile() {
    local path=$1

    if [ -d $path ] && [ -f "${path}/Containerfile" ]; then
        echo true
    else
        echo false
    fi
}
