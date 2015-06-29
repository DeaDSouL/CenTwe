#!/bin/bash
[[ -z "$__main__" || "$__main__" != 'CenTwe.sh' ]] && { echo 'Can not run this file directly'; exit 1; }





# Un-installing:
#				rpm -e PKG-NAME
# 								ex: rpm -e nautilus-dropbox-2015.02.12-1.fc10.x86_64
# 								ex: rpm -e nautilus-dropbox-1.6.2-1.fc10.x86_64
function __app_dropbox() {
	_dir_app="$__inc__/app.dropbox"

	[[ -n "$1" ]] && echo "$1"

	# Preparing the installation process
	[[ "$_osarch" == 'x86_64' ]] && _varch='x86_64' || _varch='i386'

	_vdblink='https://www.dropbox.com'
	_vdbfile="CenTwe_Dropbox_${_varch}.rpm"
	_vhtmlsrc=$(wget -qO- 'https://www.dropbox.com/install?os=lnx' | grep "/download?dl=packages/fedora/nautilus-dropbox-.*.fedora.*.rpm")

	if [[ $_vhtmlsrc =~ \<a.*href=\"([^\"]*${_varch}.rpm)\" ]]; then
		_vdblink="${_vdblink}${BASH_REMATCH[1]}"
	else
		__a '[APP]: ERROR - Could not find the Dropbox downloading link...'
		return 1
	fi

	[[ -e "${_tmp_dir}/${_vdbfile}" ]] && rm -rvf "${_tmp_dir}/${_vdbfile}"

	# Downloading the archived file
	echo "[APP]: Downloading Dropbox (${_osarch})...."
	wget --user-agent="${_uagent}" "${_vdblink}" -O "${_tmp_dir}/${_vdbfile}"

	# Installing the package
	echo "[APP]: Installing Dropbox (${_osarch})..."
	[[ -z `rpm -qa | grep -i "libgnome-[0-9*]"` ]] && yum -y install libgnome
	rpm -Uvh "${_tmp_dir}/${_vdbfile}"

	# Cleaning up temp things...
	echo '[APP]: Cleaning up temp things...'
	[[ -f "${_tmp_dir}/${_vdbfile}" ]] && rm -rfv "${_tmp_dir}/${_vdbfile}"
	unset _vhtmlsrc

	unset _dir_app
}
