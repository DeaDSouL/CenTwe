#!/bin/bash


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#  _________________________________________________________________________  # 
# |                                                                         | # 
# | Package......CenTwe (0.0.1)                                             | # 
# | Author.......Mubarak Alrashidi (DeaDSouL)                               | # 
# | License......GNU/GPL v2                                                 | # 
# | URL..........https://github.com/DeaDSouL/CenTwe                         | # 
# |_________________________________________________________________________| # 
#                                                                             # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 






# ------------------------------------------------------------------------------
#   DO NOT CHANGE ANYTHING BELOW THIS LINE, UNLESS YOU KNOW WHAT YOU'RE DOING
# ------------------------------------------------------------------------------

pushd `dirname $0` > /dev/null
__path__=`pwd -P`
popd > /dev/null
__main__=`basename "$0"`
__file__="$__path__/$__main__"
__core__="$__path__/core"
__apps__="$__path__/plugins/apps"
__twks__="$__path__/plugins/tweaks"
__fixs__="$__path__/plugins/fixes"
__repo__="$__path__/plugins/repos"
source "$__core__/core.sh"
init.main
