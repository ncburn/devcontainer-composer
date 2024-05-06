#!/bin/bash
expected_container_app_name=$1
expected_compose_app_name=$2

source ./container.sh
source ../host/file.sh

readonly PASSED="passed"
readonly FAILED="failed"

assert_string() {
    local actual_value=$1
    local expected_value=$2

    if [[ $actual_value == $expected_value ]]; then
        echo "${PASSED}"
        
        return 0
    else
        echo "${FAILED}, expected '${expected_value}' instead of '${actual_value}'"

        return 1
    fi
}

assert_value() {
    local actual_value=$1
    local expected_value=$2

    if [[ $actual_value -eq $expected_value ]]; then
        echo "${PASSED}"
        
        return 0
    else
        echo "${FAILED}, expected '${expected_value}' instead of '${actual_value}'"

        return 1
    fi
}

test_check_app_exists_returns_true() {
    echo -n "test_check_app_exists_returns_true: "
    local expected_value=$TRUE

    local result=$(check_app_exists "sh")
    
    assert_value $result $expected_value
}

test_check_app_exists_returns_false() {
    echo -n "test_check_app_exists_returns_false: "
    local expected_value=$FALSE

    local result=$(check_app_exists "asdf")

    assert_value $result $expected_value
}

test_get_container_app_name_returns_expected_app_name() {
    echo -n "test_get_container_app_name_returns_expected_app_name: "

    local result=$(get_container_app_name)

    assert_string $result $expected_container_app_name
}

test_get_compose_app_name_returns_expected_app_name() {
    echo -n "test_get_compose_app_name_returns_expected_app_name: "

    local result=$(get_compose_app_name)

    assert_string $result $expected_compose_app_name
}

test_check_volume_exists_when_vol_not_exist_returns_false() {
    echo -n "test_check_volume_exists_when_vol_not_exist_returns_false: "
    local expected_value=$FALSE

    local result=$(check_volume_exists 'asdf')

    assert_value $result $expected_value 
}

test_check_volume_exists_when_vol_exists_returns_true() {
    echo -n "test_check_volume_exists_when_vol_exists_returns_true: "

    local volume_name="test_check_volume_exists_expect_exists_vol"
    local expected_value=$TRUE
    $expected_container_app_name volume rm $volume_name >/dev/null 2>&1
    $expected_container_app_name volume create $volume_name >/dev/null 2>&1

    local result=$(check_volume_exists $volume_name)

    assert_value $result $expected_value

    #Cleanup
    $expected_container_app_name volume rm $volume_name >/dev/null 2>&1
}

test_create_volume_expect_volume_created() {
    echo -n "test_create_volume_expect_volume_created: "

    local volume_name="test_create_volume_expect_volume_created_vol"
    local expected_value=$TRUE
    $expected_container_app_name volume rm $volume_name >/dev/null 2>&1
    
    local result=$(create_volume $volume_name)

    assert_value $result $expected_value

    #Cleanup
    $expected_container_app_name volume rm $volume_name >/dev/null 2>&1
}

test_create_volume_expect_volume_not_created() {
    echo -n "test_create_volume_expect_volume_not_created: "

    local volume_name="test_create_volume_expect_volume_not_created_vol"
    local expected_value=$FALSE
    $expected_container_app_name volume create $volume_name >/dev/null 2>&1

    local result=$(create_volume $volume_name)

    assert_value $result $expected_value

    #Cleanup
    $expected_container_app_name volume rm $volume_name >/dev/null 2>&1
}

test_check_app_exists_returns_true
test_check_app_exists_returns_false
test_get_container_app_name_returns_expected_app_name
test_get_compose_app_name_returns_expected_app_name
test_check_volume_exists_when_vol_not_exist_returns_false
test_check_volume_exists_when_vol_exists_returns_true
test_create_volume_expect_volume_created
test_create_volume_expect_volume_not_created

test2=$(create_initializer_image)
echo "Init: ${test2}"