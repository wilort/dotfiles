[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export PATH=~/.local/bin:$PATH
export PATH=~/bin:$PATH

# Making the prompt look like "wilort@gotids12p$"
PS1="[\u@\h \W]$ "

# Aliases
alias l='ls -l'
alias fpc='cd /users/wilort/work/fpc'
alias work='cd /users/wilort/work'
alias s='cd /users/wilort/work/fpc/sulu2'
alias wiki='cd /users/wilort/work/fpc/wiki'
alias stt='cd /users/wilort/work/fpc/sulu2_tt'
alias ots='cd /users/wilort/work/Customization/ots-crew-planning'
alias dsulu='/users/wilort/work/fpc/sulu2/build/sulu configfile=/carm/softwaredevelopment/Trains/fpx/sulu/sulu2-devel/etc/config_dev.standard'
alias diffs='diff --side-by-side --suppress-common-lines'
# alias python='python2'
# alias tmux="TERM=screen-256color-bce tmux"

myfunction () {
  cov-build --dir ./coverity make -j 32 -C build-coverity sulu\
  && cov-analyze --dir ./coverity --strip-path "$(pwd)" \
  && rm -rf coverity-html \
  && cov-format-errors --dir ./coverity --html-output ./coverity-html
}

# press r followed by control + p to get to latest command that begins with r
bind "\C-p history-search-backward"
bind "\C-n history-search-forward"

# Functions
# Search the glossaries for what an abbreviation means
what() {
  # This function searches the abbreviations column. If the string matches a
  # substring in the abbreviations column the line is printed. grep command at
  # the end is for color highlighting

  abbreviation=$1
  file1=/users/wilort/work/fpc/wiki/glossary.md
  file2=/users/wilort/work/my_git_projects/abbreviations/README.md
  echo "----- $file1 -----"
  awk -F '|' -v var=$abbreviation '{IGNORECASE = 1} {if ($2 ~ var) print $0}' $file1 | grep -i $abbreviation
  echo "----- $file2 -----"
  awk -F '|' -v var=$abbreviation '{IGNORECASE = 1} {if ($2 ~ var) print $0}' $file2 | grep -i $abbreviation

  # echo "----- /users/wilort/work/my_git_projects/abbreviations/README.md -----"
  # grep -i $1 /users/wilort/work/fpc/wiki/glossary.md
  # echo "----- /users/wilort/work/my_git_projects/abbreviations/README.md -----"
  # grep -i $1 /users/wilort/work/my_git_projects/abbreviations/README.md
}

# get sulu to "grep" for RAD IDs
# output is a srad file (including the srad header)
# on purpose doesn't match " after the RAD ID, so that
# e.g. sulugreprad EN5548 will return EN5548A/B/C/D/E/F
sulugreprad() {
    dsulu writerad - | grep -v ^Loaded | egrep "(SuluRad|Restriction \"$1)"
}

# search for a specific RAD
# List all rads and search for the line with specific rad name
# and print until the next rad begins. $1 represents first argument
# to the function. Example usage: "srad LK5540A"
# frad is an abbreviation for find rad
frad() {
    dsulu list rad | sed -n -e "/$1/,/-----/ p"
}

# Add nice coloring when using the ls command

LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS

. /etc/os-release
if [ "$VERSION_ID" == "7.9" ]; then
  [ -f /opt/rh/devtoolset-11/enable ] && . /opt/rh/devtoolset-11/enable
  [ -f /opt/rh/llvm-toolset-12.0/enable ] && . /opt/rh/llvm-toolset-12.0/enable
  [ -f /opt/rh/rh-python38/enable ] && . /opt/rh/rh-python38/enable
  [ -f /carm/proj/sulu/root/el7/enable ] && . /carm/proj/sulu/root/el7/enable
fi
if [ "$VERSION_ID" == "8.5" ]; then
  [ -f /opt/rh/gcc-toolset-11/enable ] && . /opt/rh/gcc-toolset-11/enable
  [ -f /carm/proj/sulu/root/el8/enable ] && . /carm/proj/sulu/root/el8/enable
fi

