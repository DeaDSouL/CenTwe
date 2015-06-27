#!/bin/bash
[[ -z "$__main__" || "$__main__" != 'CenTwe.sh' ]] && { echo 'Can not run this file directly'; exit 1; }





# URL: https://wiki.archlinux.org/index.php/Browser_plugins#Fullscreen_fix_for_GNOME_3
function __fix_gsfsflash4ff() {
	_dir_fix="$__inc__/fix.gsfsflash4ff"
	[[ -n "$1" ]] && echo "$1"
	if [[ -z `rpm -qa | grep devilspie` ]]; then
		echo '[FIXING]: Going to install "devilspie"'
		yum -y update && yum -y install devilspie
		__fix_gsfsflash4ff
	else
		_dir_autostart="/home/$_username/.config/autostart"
		_dir_devilspie="/home/$_username/.devilspie"
		if [[ ! -f "$_dir_devilspie/flash-fullscreen-firefox.ds" ]]; then
			echo "[FIXING]: Creating: $_dir_devilspie/flash-fullscreen-firefox.ds"
			[[ ! -d "$_dir_devilspie" ]] && mkdir -p "$_dir_devilspie"
			cp "$_dir_fix/flash-fullscreen-firefox.ds" "$_dir_devilspie/flash-fullscreen-firefox.ds"
			chown -R $_username:$_username "$_dir_devilspie"
			chmod ugo-wx,ugo+r,ug+w "$_dir_devilspie/flash-fullscreen-firefox.ds"
		fi
		if [[ ! -f "$_dir_autostart/devilspie.desktop" ]]; then
			echo "[FIXING]: Creating: $_dir_autostart/devilspie.desktop"
			[[ ! -d "$_dir_autostart" ]] && mkdir -p "$_dir_autostart"
			cp "$_dir_fix/devilspie.desktop" "$_dir_autostart/devilspie.desktop"
			chown -R $_username:$_username "$_dir_autostart"
			chmod ugo-wx,ugo+r,ug+w "$_dir_autostart/devilspie.desktop"
		fi
		$(su - $_username -c 'devilspie')
		echo '[FIXING]: Firefox fullscreen flash for GNOME 3 is Completed'
	fi
	unset _dir_fix
}

