#!/bin/bash

set -u
set -e

source settings.sh

if [ -z ${NOISE_GPIO} ]; then
    echo "NOISE_GPIO env variable should be set"
    exit -1
fi

SYS_GPIO=/sys/class/gpio
NUM_NOISE_GENS=${#NOISE_GPIO[@]}

function noise_on {
    echo 0 > $SYS_GPIO/gpio${NOISE_GPIO[$1]}/value
}

function noise_off {
    echo 1 > $SYS_GPIO/gpio${NOISE_GPIO[$1]}/value
}

function noise_init {
    for gpio in "${NOISE_GPIO[@]}"; do
        PIN=$SYS_GPIO/gpio$gpio
        if [ ! -d $PIN ]; then
            sudo sh -c "echo $gpio > $SYS_GPIO/export"
        fi
        sudo sh -c "echo out > $PIN/direction"
        sudo sh -c "echo 1 > $PIN/value"
        sudo sh -c "chown odroid:odroid $PIN/value"
    done
}

function usage {
    echo "Usage: noise.sh init|on|off"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -eq 0 ]]; then
        usage
        exit 1
    fi

    case "$1" in
        init)
            noise_init
            ;;
        on)
            noise_on $2
            ;;
        off)
            noise_off $2
            ;;
        *)
            usage
            exit 1
            ;;
    esac
fi
