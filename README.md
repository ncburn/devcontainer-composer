This repo is an initial attempt at making utility scripts for creating dev container images. "create-image.sh" was created to enable more control over the initial image including automatically making a home volume which can be shared between containers and built-in user with sudo access.

The create-image script does the following...
- Creates a home volume named "${image_name}_home" where image_name is specified with the "-n" argument
- Passes USER_NAME, USER_ID, and USER_GROUP_ID as build arguments to podman/docker. Where USER_NAME is "developer", USER_ID is the user ID of the user executing the script, and USER_GROUP_ID is the group ID of the user executing the script.

Usage:
create-image -d directory -n image_name

Example:
./create-image -d ./templates/rust -n rust-devcontainer
