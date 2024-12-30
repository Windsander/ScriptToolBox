#!/bin/bash

# define localization initial settings
localization_block="
#=============================== BELOW is Localizations ===============================
# only packaged scripts(init):
source ~/.apex/.apex_config
source ~/.apex/.bash_conda
source ~/.apex/.bash_repo
source ~/.apex/.bash_git
"

# check ${HOME}/.bash_profile exists
if [ ! -f "${HOME}/.bash_profile" ]; then
    touch "${HOME}/.bash_profile"
    echo "Created ${HOME}/.bash_profile"
fi

# check ${HOME}/.bash_profile do contain ${localization_block}
if [ -z "$(grep -Fx "${localization_block}" "${HOME}/.bash_profile")" ]; then
    # if not，add ${HOME}/.bash_profile to file last
    echo "${localization_block}" >> "${HOME}/.bash_profile"
    echo "Localization block added to ${HOME}/.bash_profile"
else
    echo "Localization block already exists in ${HOME}/.bash_profile"
fi