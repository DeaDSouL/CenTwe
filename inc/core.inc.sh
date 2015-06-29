#!/bin/bash
[[ -z "$__main__" || "$__main__" != 'CenTwe.sh' ]] && { echo 'Can not run this file directly'; exit 1; }





# ------------------------------------------------------------------------------

# Check whether it is good to proceed
function __isit_good2go() {
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
function __is_deps_ok() {
    echo '[Deps]: Checking the required dependencies..'
    _deps_list=('newt' 'wget')
    _all_pkgs=`rpm -qa`
    # Do we have the required dependencies
    for _dpkg in ${_deps_list[@]}; do
        if [[ -z `echo "$_all_pkgs" | grep -i "^${_dpkg}-[0-9*]"` ]]; then
            echo "[Deps]: Missing dependency '$_dpkg'"
            _opts=("Install '$_dpkg' package." "Cancel and exit.")
            PS3="What would you like to do? "
            select _opt in "${_opts[@]}"; do
                case "$REPLY" in
                # 1 ) echo "yum -y install $_dpkg"; break;;
                1 ) yum -y install $_dpkg; break;;
                2 ) echo "Exiting..!"; __q 1; break;;
                * ) echo "Invalid option !"; continue;;
                esac
            done
            __is_deps_ok
            return 0 # Avoiding the double looping for the same package
        else
            echo "[Deps]: '$_dpkg' is available."
        fi
    done
}

# ------------------------------------------------------------------------------

# Custom exit function
function __q() {
	echo 'Cleaning up the generated temporary files..'
	[[ -d "$_tmp_dir" ]] && rm -rfv "$_tmp_dir"
	exit $1
}

# ------------------------------------------------------------------------------

# Aborting function: Should abort the sub-script process, if anything goes wrong
# TODO: see if there is a way to implement this to make force the function to exit
#		instead of exiting the whole script.
function __a() {
	echo "[APORTING]: $1"
	return 1
}

# ------------------------------------------------------------------------------

# Making & checking the existence of the temp dir we're going to use
function __mktemp_d() {
    [[ -z "$_tmp_dir" || ! -d "$_tmp_dir" ]] && _tmp_dir=`mktemp -d`
    [[ `pwd -P` != "$_tmp_dir" ]] && cd "$_tmp_dir"
}

# ------------------------------------------------------------------------------

# URL: http://stackoverflow.com/a/4025065
# We should not call it directly, instead we should use `__need2update $1 $2`
function __ver_comp () {
    if [[ $1 == $2 ]]; then
        return 0
    fi
    local OIFS=$IFS
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            IFS=$OIFS
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            IFS=$OIFS
            return 2
        fi
    done
    return 0
}

# ------------------------------------------------------------------------------

# usage ex: [[ `__need2update $1 $2` == 1 ]] && echo 'yes' || echo 'no'
function __need2update() {
    # $1 : installed version
    # $2 : avilable version
    __ver_comp $1 $2
    [[ $? == 2 ]] && echo 1 || echo 0
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
