#
# usage: source arm_env.sh
#

# setup CROSS_COMPILE environment variable so we can cross compile for the arm SoC
export CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-
export ARCH=arm

# change the shell prompt so we can distinguish between the cross_compile shell and the other normal ones
# info on prompt syntax: https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
export PS1="\[\e[01;33m\]arm|\[\e[01;35m\]\w \[\e[01;31m\]>> \[\e[0m\]"

