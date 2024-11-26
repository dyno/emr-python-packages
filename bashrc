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
fi

if [[ -d ~/.bash_completion.d ]]; then
  for completion in $(find ~/.bash_completion.d -maxdepth 1 -type f); do
    source ${completion}
  done
fi

# ------------------------------------------------------------------------------

# increase history size
export HISTSIZE=9999
export HISTFILESIZE=9999

# https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export HISTTIMEFORMAT="%Y-%m-%d %T "

# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
shopt -s checkwinsize
# make sure all terminals save history - append to history, don't overwrite it
shopt -s histappend
# https://askubuntu.com/questions/70750/how-to-get-bash-to-stop-escaping-during-tab-completion
shopt -s direxpand

# ------------------------------------------------------------------------------

# User specific aliases and functions
export PATH=$PATH:~/.local/bin
# e.g. python3.11
_PYTHON_VERSION=$(python3 -c 'import sys; print(f"python{sys.version_info.major}.{sys.version_info.minor}")')
export PYTHONPATH=~/scripts/py:$HOME/.local/lib/${_PYTHON_VERSION}/site-packages

if [ -z "${AWS_SHARED_CREDENTIALS_FILE}" ]; then
  # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
  # https://aws.amazon.com/blogs/security/defense-in-depth-open-firewalls-reverse-proxies-ssrf-vulnerabilities-ec2-instance-metadata-service/
  _MDS_TOKEN=$(curl --silent -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
  AWS_DEFAULT_REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region -H "X-aws-ec2-metadata-token: $_MDS_TOKEN")
  export AWS_DEFAULT_REGION
fi
