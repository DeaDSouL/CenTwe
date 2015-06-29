#!/bin/bash
[[ -z "$__main__" || "$__main__" != 'CenTwe.sh' ]] && { echo 'Can not run this file directly'; exit 1; }





function __app_lighttable() {
	_dir_app="$__inc__/app.lighttable"

	[[ -n "$1" ]] && echo "$1"

	# Preparing the installation process
	[[ "$_osarch" == 'x86_64' ]] && _varch='64' || _varch=''

	_vltlink='http://lighttable.com'
	_vltfile="CenTwe_LightTableLinux_${_varch}.tar.gz"
	_vhtmlsrc=$(wget -qO- 'http://lighttable.com' | grep "LightTableLinux${_varch}.tar.gz")

	if [[ $_vhtmlsrc =~ \<a.*href=\"([^\"]*)LightTableLinux${_varch}.tar.gz\" ]]; then
		_vltlink="${BASH_REMATCH[1]}LightTableLinux${_varch}.tar.gz"
	else
		__a '[APP]: ERROR - Could not find the LightTable downloading link...'
		return 1
	fi

	[[ -e "${_tmp_dir}/${_vltfile}" ]] && rm -rvf "${_tmp_dir}/${_vltfile}"

	# Downloading the archived file
	echo "[APP]: Downloading LightTable (${_osarch})...."
	wget --user-agent="${_uagent}" "${_vltlink}" -O "${_tmp_dir}/${_vltfile}"

	if [[ ! -f "${_tmp_dir}/${_vltfile}" ]]; then
		__a "[APP]: ERROR - Could not download Light Table (${_osarch})..."
		return 1
	fi

	# Installing the package
	echo "[APP]: Installing LightTable (${_osarch})..."

	# Extracting the archived file
	tar -zxvf "${_tmp_dir}/${_vltfile}" -C "/opt"
	
	# Quick fix for 'libudev.so.0'
	if [[ "$_osarch" == 'x86_64' ]]; then
		# We have only these libs for udev
			# /usr/lib64/libudev.so.1			(which is link to the next line) [So, We will go with this one]
			# /usr/lib64/libudev.so.1.4.0
			# /usr/lib/libudev.so.1				(which is link to the next line)
			# /usr/lib/libudev.so.1.4.0
			# /usr/lib64/libgudev-1.0.so.0		(which is link to the next line) [Used to use this one, but now LightTable supports the libudev.so.1]
			# /usr/lib64/libgudev-1.0.so.0.1.3
			# /usr/lib/libgudev-1.0.so.0		(which is link to the next line)
			# /usr/lib/libgudev-1.0.so.0.1.3
		mv -v "/opt/LightTable/libudev.so.0" "/opt/LightTable/libudev.so.0.bkp"
		# Since '/lib64' is just a link to '/usr/lib64',... we're going to use the original dir
		ln -vs "/usr/lib64/libudev.so.1" "/opt/LightTable/libudev.so.0"
	fi

	# Creating the .desktop file
	cp -v "$_dir_app/lighttable.desktop" "/usr/share/applications/lighttable.desktop"

	# Creating symbolic link to binary file
	ln -vs "/opt/LightTable/LightTable" "/bin/LightTable"
	ln -vs "/opt/LightTable/LightTable" "/bin/lighttable"

	# Cleaning up temp things...
	echo '[APP]: Cleaning up temp things...'
	[[ -f "${_tmp_dir}/${_vltfile}" ]] && rm -rfv "${_tmp_dir}/${_vltfile}"
	unset _vhtmlsrc

	unset _dir_app
}
