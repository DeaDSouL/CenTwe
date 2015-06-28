#!/bin/bash
[[ -z "$__main__" || "$__main__" != 'CenTwe.sh' ]] && { echo 'Can not run this file directly'; exit 1; }





function __app_slt3() {
	_dir_app="$__inc__/app.slt3"

	[[ -n "$1" ]] && echo "$1"

	# Check the latest available build.no
	_slt3build=`wget -qO- 'http://www.sublimetext.com/3' | grep -i 'The latest build is'`
	_slt3build="${_slt3build##* }"
	_slt3build="${_slt3build%.*}"

	[[ "$_osarch" == 'x86_64' ]] && _varch='x64' || _varch='x32'

	_slt3file="sublime_text_3_build_${_slt3build}_${_varch}.tar.bz2"
	_slt3link="http://c758482.r82.cf2.rackcdn.com/${_slt3file}"

	[[ -e "${_tmp_dir}/CenTwe_${_slt3file}" ]] && rm -rvf "${_tmp_dir}/CenTwe_${_slt3file}"

	# Downloading the archived file
	echo "[APP]: Downloading Sublime Text 3 (${_osarch})...."
	wget --user-agent="${_uagent}" "${_slt3link}" -O "${_tmp_dir}/CenTwe_${_slt3file}"

	echo "[APP]: Installing Sublime Text 3 (${_osarch})..."

	# Extracting the archived file
	tar -jxvf "${_tmp_dir}/CenTwe_${_slt3file}" -C /opt

	# Creating the .desktop file
	cp -v "$_dir_app/sublime3.desktop" "/usr/share/applications/sublime3.desktop"

	# Creating symbolic link to binary file
	[[ -f "/opt/sublime_text_3/sublime_text" ]] && ln -vs "/opt/sublime_text_3/sublime_text" "/bin/sublime3"

	# Removing the archived file
	echo '[APP]: Cleaning up temp things...'
	[[ -f "${_tmp_dir}/CenTwe_${_slt3file}" ]] && rm -rfv "${_tmp_dir}/CenTwe_${_slt3file}"

	unset _dir_app
}
