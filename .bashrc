# ble.sh initialization
[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --attach=none


# Command history tweaks:
# - Append history instead of overwriting
#   when shell exits.
# - When using history substitution, do not
#   exec command immediately.
# - Do not save to history commands starting
#   with space.
# - Do not save duplicated commands.
shopt -s histappend
shopt -s histverify
export HISTCONTROL=ignoreboth

# ignore case when using cd
bind 'set completion-ignore-case On'


export JAVA_HOME="/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk/"

# Load aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi     

# Default command line prompt.
# PROMPT_DIRTRIM=2
# PS1='\[\e[0;32m\]\w\[\e[0m\] \[\e[0;97m\]\$\[\e[0m\] '

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
      # We have color support; assume it's compliant with Ecma-48
      # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
      # a case would tend to support setf rather than setaf.)
      color_prompt=yes
    else
      color_prompt=
    fi
fi

color_red="\033[0;31m"
color_yellow="\033[0;33m"
color_green="\033[0;32m"
color_ochre="\033[38;5;95m"
color_blue="\033[0;34m"
color_white="\033[0;37m"
color_reset="\033[0m"

git_info() {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  local untracked_files="Untracked files:"
  local not_staged="Changes not staged for commit:"
  local staged="Changes to be committed:"
  local branch_is_ahead="Your branch is ahead of"

  if git status &>/dev/null; then
    local msg="("

    if [[ $git_status =~ $on_branch ]]; then
      local branch=${BASH_REMATCH[1]}
      msg+="${color_blue}${branch}${color_reset}"
    elif [[ $git_status =~ $on_commit ]]; then
      local commit=${BASH_REMATCH[1]}
      msg+="${color_blue}${commit}${color_reset}"
    fi

    if [[ $git_status =~ $branch_is_ahead ]]; then
      msg+="|${color_green}\u2191${color_reset}"
    fi

    msg+=")"

    if [[ $git_status =~ $untracked_files
      || $git_status =~ $not_staged 
      || $git_status =~ $staged ]]; then
    
      msg+=" "

      if [[ $git_status =~ $untracked_files ]]; then
        msg+="${color_red}\u271A${color_reset}"
      fi

      if [[ $git_status =~ $not_staged ]]; then
        msg+="${color_yellow}\u271A${color_reset}"
      fi

      if [[ $git_status =~ $staged ]]; then
        msg+=" ${color_green}\u25CF${color_reset}"
      fi

      msg+=" "
    fi
    echo -e "$msg"
  fi
}

export USERNAME="reich"

# user 
PS1="\[${color_red}\]$USERNAME\[${color_reset}\]"
# @ host
PS1+=" @ \[${color_yellow}\]\h\[${color_reset}\]"
# Current working directory
PS1+=" in \[${color_green}\]\w\[${color_reset}\]"
# (git_branch)
PS1+=" \$(git_info)"
# newline + '#' for root otherwise $
PS1+="\n\$ "
export PS1

# Handles nonexistent commands.
# If user has entered command which invokes non-available
# utility, command-not-found will give a package suggestions.
if [ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]; then
	command_not_found_handle() {
		/data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"
	}
fi

[ -r /data/data/com.termux/files/usr/share/bash-completion/bash_completion ] && . /data/data/com.termux/files/usr/share/bash-completion/bash_completion

if [ -z "$SSH_AUTH_SOCK" ] ; then
	  eval `ssh-agent -s`
	    ssh-add
fi

[[ ! ${BLE_VERSION-} ]] || ble-attach

