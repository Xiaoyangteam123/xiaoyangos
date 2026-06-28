# XiaoyangOS - ~/.bashrc

alias ll='ls -lF'
alias la='ls -A'
alias l='ls -CF'
alias nano='nano -w'
alias xiaoyangos='neofetch'

# XiaoyangOS banner on terminal start
if [ -f /etc/os-release ]; then
    . /etc/os-release
fi
echo -e "\e[1;36m  XiaoyangOS \e[1;34m$PRETTY_NAME\e[0m"
echo -e "\e[0;36m  Based on Arch Linux with KDE Plasma\e[0m"
echo ""
