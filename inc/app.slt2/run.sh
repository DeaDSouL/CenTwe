#!/bin/bash
[[ -z "$__main__" || "$__main__" != 'CenTwe.sh' ]] && { echo 'Can not run this file directly'; exit 1; }





function __app_slt2() {
	_dir_app="$__inc__/app.slt2"

	[[ -n "$1" ]] && echo "$1"

	[[ `pwd -P` != "$_temp_dir" ]] && cd "$_temp_dir"

	[[ "$_osarch" == 'x86_64' ]] && _varch='%20x64' || _varch=''

	_slt2file="Sublime%20Text%202.0.2${_varch}.tar.bz2"
	_slt2link="http://c758482.r82.cf2.rackcdn.com/${_slt2file}"

	[[ -e "${_tmp_dir}/CenTwe_${_slt2file}" ]] && rm -rvf "${_tmp_dir}/CenTwe_${_slt2file}"

	# Downloading the archived file
	echo "[APP]: Downloading Sublime Text 2 (${_osarch})...."
	wget --user-agent="${_uagent}" "${_slt2link}" -O "${_tmp_dir}/CenTwe_${_slt2file}"

	echo "[APP]: Installing Sublime Text 2 (${_osarch})..."

	# Extracting the archived file
	tar -jxvf "${_tmp_dir}/CenTwe_${_slt2file}" -C /opt

	# Renaming the main Sublime Text 2
	[[ -d "/opt/Sublime Text 2" ]] && mv -v "/opt/Sublime Text 2" "/opt/sublime_text_2"

	# Creating the .desktop file
	cp -v "$_dir_app/sublime2.desktop" "/usr/share/applications/sublime2.desktop"

	# Creating symbolic link to binary file
	[[ -f "/opt/sublime_text_2/sublime_text" ]] && ln -vs "/opt/sublime_text_2/sublime_text" "/bin/sublime2"

	# Removing the archived file
	echo '[APP]: Cleaning up temp things...'
	[[ -f "${_tmp_dir}/CenTwe_${_slt2file}" ]] && rm -rfv "${_tmp_dir}/CenTwe_${_slt2file}"

	unset _dir_app
}
