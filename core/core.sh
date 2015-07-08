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

# Main function
function init.main() {
    # Checking whether it's ok or not ok to proceed
    init.chk_user
    init.chk_deps

    # Start loading the needed things
    init.mktemp
    init.plugins

    # Start the main script
    init.shell
}

# ------------------------------------------------------------------------------

# Check whether it is good or not to proceed
function init.chk_user() {
    if [[ ("$_iam" == "root") && ("$_scriptis" != 'safe2run' || -z "$_username") ]]; then
        echo 'You should run it as a normal user!'
        echo 'Exiting..'; __q 1
    elif [[ "$_iam" == "root" && "$_scriptis" == 'safe2run' && -n "$_username" ]]; then
        #if id -u "$_username" >/dev/null 2>&1; then
        # OR
        if [[ `grep -c "^$_username:" /etc/passwd` == 0 ]]; then
            echo "User: $_username doesn't exist !!"
            echo 'Exiting..'; __q 1
        fi
    else
            su -c "bash $__file__ 'safe2run' '$_iam'"
            __q 0
    fi
}

# ------------------------------------------------------------------------------

# How should we proceed?
function init.chk_deps() {
    # Preparing the needed variables
    local vDepsList vAllPkgs vDPkg vOpts vOpt

    echo '[Deps]: Checking the required dependencies..'
    vDepsList=('newt' 'wget')
    vAllPkgs=`rpm -qa`

    # Do we have the required dependencies
    for vDPkg in ${vDepsList[@]}; do
        if [[ -z `echo "$vAllPkgs" | grep -i "^${vDPkg}-[0-9*]"` ]]; then
            echo "[Deps]: Missing dependency '$vDPkg'"
            vOpts=("Install '$vDPkg' package." "Cancel and exit.")
            PS3="What would you like to do? "
            select vOpt in "${vOpts[@]}"; do
                case "$REPLY" in
                1 ) yum.upin $vDPkg; break;;
                2 ) echo "Exiting..!"; __q 1; break;;
                * ) echo "Invalid option !"; continue;;
                esac
            done
            init.chk_deps
            return 0 # Avoiding the double looping for the same package
        else
            echo "[Deps]: '$vDPkg' is available."
        fi
    done

    # Flushing the used variables
    unset vDepsList vAllPkgs vDPkg vOpts vOpt
}

# ------------------------------------------------------------------------------

# Making & checking the existence of the temp dir we're going to use
function init.mktemp() {
    [[ -z "$__tmpd__" || ! -d "$__tmpd__" ]] && __tmpd__=`mktemp -d`
    [[ `pwd -P` != "$__tmpd__" ]] && cd "$__tmpd__"
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# Loading available plugins
# TODO: Scan & load user plugins first, which they should be under:
# '~/.centwe_plugins/{applications,tweaks,fixes,repos}'
function init.plugins() {
    # Preparing the needed variables
    local plugin type
    declare -A plugins=([app]="$__apps__" [twk]="$__twks__" [fix]="$__fixs__" [repo]="$__repo__")
    # DO NOT declare with assigning initial values to a global associative array
    # (it's a bug in Bash 4.2. See: http://stackoverflow.com/a/21151984)
    # g: global, A: associative array
    # declare -gA imported
    # plugins=([app]="$__apps__" [twk]="$__twks__" [fix]="$__fixs__" [repo]="$__repo__")
    for type in "${!plugins[@]}"; do
        for plugin in "${plugins[$type]}/"*; do
            plugin=`basename "$plugin"`;
            if [[ "$plugin" != *' '* && -f "${plugins[$type]}/$plugin/run.sh" ]]; then
                source "${plugins[$type]}/$plugin/run.sh"
                imported[$type/$plugin]=0
            fi
        done
    done

    # Flushing the used variables
    unset plugin type plugins
}

# ------------------------------------------------------------------------------

# The main shell, which will read & execute all the inserted commands by user
function init.shell() {
    local cmd
    while [[ true ]]; do
        # echo -n "[root@CenTwe ]$ "
        echo -n "CenTwe> "
        # The words are assigned to sequential indexes of the array variable
        # ANAME, starting at 0. All elements are removed from ANAME before the
        # assignment. Other NAME arguments are ignored.
        # Check: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_08_02.html
        read -a cmd
        case ${cmd[0]} in
            app)    cmd.app ${cmd[@]:1};;
            twk)    cmd.twk ${cmd[@]:1};;
            fix)    cmd.fix ${cmd[@]:1};;
            repo)   cmd.repo ${cmd[@]:1};;
            help)   cmd.help ${cmd[1]};;
            clear)  clear;;
            quit|exit)
                    echo 'Goodbye!'; exit 0; break;;
            *)      echo 'Invalid command. Try: help'; continue;;
        esac
    done
}

# ------------------------------------------------------------------------------

# should always be used before setting or getting any value.
# $1 : type    -    $2 : name
function plugin.use() {
    [[ -n $1 ]] && plugin_type=$1
    [[ -n $2 ]] && plugin_name=$2
}

# ------------------------------------------------------------------------------

# $1 : key    -    $2 : value
function plugin.set() {
    plugin_info[$plugin_type/$plugin_name.$1]=$2
}

# ------------------------------------------------------------------------------

function plugin.get() {
    local ret=${plugin_info[$plugin_type/$plugin_name.$1]}
    [[ -n "$ret" ]] && echo "$ret"
}

# ------------------------------------------------------------------------------

function plugin.need2update() {
    __need2update `plugin.get 'verlocal'` `plugin.get 'veronline'`
}

# ------------------------------------------------------------------------------

function plugin.check_update() {
    # This is independent
    # local verlocal=`plugin.get 'verlocal'`
    # local veronline=`plugin.get 'veronline'`
    # if [[ `__need2update $verlocal $veronline` == 0 ]]; then
    #     plugin.set 'update' 'available'
    # else
    #     plugin.set 'update' 'unavailable'
    # fi

    # This depends on 'plugin.need2update'
    # May be we should delete 'plugin.need2update' and use previous commented code.
    if [[ `plugin.need2update` == 0 ]]; then
        plugin.set 'update' 'available'
    else
        plugin.set 'update' 'unavailable'
    fi
}

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
