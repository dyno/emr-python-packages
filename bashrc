# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# ------------------------------------------------------------------------------

if [[ -f /etc/profile.d/bash_completion.sh ]]; then
  source /etc/profile.d/bash_completion.sh

  if [[ -d ~/.bash_completion.d ]]; then
    for completion in $(find ~/.bash_completion.d -maxdepth 1 -type f); do
      source ${completion}
    done
  fi
fi

# User specific aliases and functions
export PATH=$PATH:~/.local/bin

