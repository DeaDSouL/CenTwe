#!/bin/bash

# Resources:
#	http://www.dedoimedo.com/computers/centos-7-perfect-desktop.html
#	http://www.tecmint.com/things-to-do-after-minimal-rhel-centos-7-installation/
#	http://linuxg.net/how-to-add-the-remi-epel-and-rpmfusion-repositories-on-centos-7/


# What repos you would like to install ?
_vrepo_epel='yes'	# Extra Package for Enterprise Linux (EPEL) Repository.
_vrepo_elrepo='yes'	# Community Enterprise Linux Repository
_vrepo_nux_dextop='yes'	# Nux Dextop Repository
_vrepo_remi='yes'	# Remi Repository
_vrepo_rpmforge='yes'	# RepoForge Repository


# ------------------------------------------------------------------------------
#		What fixes you would like to apply ?
# ------------------------------------------------------------------------------

#
_vfix_gsfsflash4ff='yes'	# fix the firefox fullscree adobe-flash for GNOME

# ------------------------------------------------------------------------------
#		What tweaks you would like to apply ?
# ------------------------------------------------------------------------------

# Categorizing GNOME Dash applications:
#
# The available categories you may choose from, are:
# 'Utilities' 'Sundry' 'Office' 'Network' 'Internet' 'Graphics' 'Multimedia'
# 'System' 'Development' 'Accessories' 'System Settings' 'Other' 'chrome-apps'
#
# Or choose one of the following preset groups
# All		: Which will categorize everything.
# Chrome	: Which will categorize only Google Chrome apps
# Default	: Which will categorize only 'Utilities' and 'Sundry'
#
# Please note that:
#	1. The selected category should be surrounded by a single quotation
#		marks, for ex: 'System Settings'.
#	2. If you chose more than one category, you should separate them by
#		single space, for ex: 'Utilities' 'Development'
#	3. The whole value of the following variable should be entered between
#		round brackets -parentheses- like "(" and ")" with no quotation
#		marks, for ex: ('Utilities' 'Sundry' 'Office').
#	4. You can NOT mix preset groups with categories.
#	5. To apply this tweak, simply un-comment the following line.
_twks_gsdapps=('Utilities' 'Sundry' 'Office' 'Network' 'Internet' 'Graphics' 'Multimedia' 'System' 'Development' 'Accessories' 'System Settings' 'Other' 'chrome-apps')
# CMD: gsettings set org.gnome.shell app-folder-categories "['Utilities', 'Sundry', 'Office', 'Network', 'Internet', 'Graphics', 'Multimedia', 'System', 'Development', 'Accessories', 'System Sett 'chrome-apps']"


# Allow https://extensions.gnome.org to talk to firefox about your existing 
# Gnome Shell extensions ?
_twks_gse4ff='yes'


# ------------------------------------------------------------------------------
# THAT'S IT ... DO NOT CHANGE ANYTHING BELOW, UNLESS YOU KNOW WHAT YOU'RE DOING
# ------------------------------------------------------------------------------

pushd `dirname $0` > /dev/null
__path__=`pwd -P`
popd > /dev/null
__main__=`basename "$0"`
__file__="$__path__/$0"
__inc__="$__path__/inc"
source "$__inc__/core.init.sh.dev"
