#!/bin/bash
[[ -z "$__main__" || "$__main__" != 'CenTwe.sh' ]] && { echo 'Can not run this file directly'; exit 1; }





# TODO:
# 1) Using local variables in function
# 2)
# ------------------------------------------------------------------------------

_iam=`whoami`
_scriptis="$1"
_username="$2"
_osarch=`arch`
# Some websites block wget, so we're going to fool them ;P
_uagent="Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0"

declare -A imported plugin_info
declare plugin_type plugin_name

# ------------------------------------------------------------------------------




# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# May be we should delete the following functions, since they're not being used.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------






# ------------------------------------------------------------------------------

# echo the value of the appArrayKey
# usage: app_info app-name array-key (ex: app_info sublime2 ver_local)
function app_info() {
    local app=$1
    local key=$2
    local ret=${app}[$key]
    if [[ -n ${!ret} ]]; then
        echo ${!ret}
    else
        # TODO: check if "$app" in plugins_array
        if [[ -z $3 ]]; then
            app.${app}_info_set
            app_info $app $key 'avoid_loop'
        fi
    fi
}

# ------------------------------------------------------------------------------

# Called as: __in_array "keyword" "${array_name[@]}"
function __in_array() {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1 # not found
}

# ------------------------------------------------------------------------------

# TODO: Need to make it works
function __is_array() {
    echo ''
    #declare -p non-existing-var 2> /dev/null | grep -q '^declare \-a' && echo array || echo no array
}

# ------------------------------------------------------------------------------

# called: __write_file "contents" "path/to/file"
# TODO: make sure file is writable.
# TODO: if file doesn't exist, should we create it ?
function __write_file() {
    if [[ -n $1 && -f $2 ]]; then
        # Removing all leading and trailing whitespace and tabs
        echo "$1" | sed -e 's/^[ \t]*//' > "$2"
    else
        echo 'Missing contents Or file does not exist'
        echo 'Exiting..'; __q 1
    fi
}

# ------------------------------------------------------------------------------
