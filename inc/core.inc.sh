#!/bin/bash
[[ -z "$__main__" || "$__main__" != 'CenTwe.sh' ]] && { echo 'Can not run this file directly'; exit 1; }





# Check whether it is good to proceed
function __isit_good2go() {
	if [[ ("$_iam" == "root") && ("$_scriptis" != 'safe2run' || -z "$_username") ]]; then
		echo 'You should run it as a normal user!'
		echo 'Exiting..'; exit 1
	elif [[ "$_iam" == "root" && "$_scriptis" == 'safe2run' && -n "$_username" ]]; then
		#if id -u "$_username" >/dev/null 2>&1; then
		# OR
		if [[ `grep -c "^$_username:" /etc/passwd` == 0 ]]; then
			echo "User: $_username doesn't exist !!"
			echo 'Exiting..'; exit 1
		fi
	else
			su -c "bash $__file__ 'safe2run' '$_iam'"
		exit 0
	fi
}


# Called as: __in_array "keyword" "${array_name[@]}"
function __in_array() {
	local e
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
	return 1 # not found
}


# TODO: Need to make it works
function __is_array() {
	#declare -p non-existing-var 2> /dev/null | grep -q '^declare \-a' && echo array || echo no array
}


# called: __write_file "contents" "path/to/file"
# TODO: make sure file is writable.
# TODO: if file doesn't exist, should we create it ?
function __write_file() {
	if [[ -n $1 && -f $2 ]]; then
		# Removing all leading and trailing whitespace and tabs
		echo "$1" | sed -e 's/^[ \t]*//' > "$2"
	else
		echo 'Missing contents Or file does not exist'
		echo 'Exiting..'; exit 1
	fi
}


