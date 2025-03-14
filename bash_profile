# First run script for ManjaroWSL2.

blu=$(tput setaf 4)
cyn=$(tput setaf 6)
grn=$(tput setaf 2)
mgn=$(tput setaf 5)
red=$(tput setaf 1)
ylw=$(tput setaf 3)
txtrst=$(tput sgr0)

test -e /mnt/c/Users/Public/shutdown.cmd && rm /mnt/c/Users/Public/shutdown.cmd
test -e ~/shutdown.cmd && rm ~/shutdown.cmd
figlet -t -k -f /usr/share/figlet/fonts/mini.flf "Welcome to ManjaroWSL2 for arm64" | lolcat
echo -e "\033[33;7mDo not interrupt or close the terminal window till script finishes execution!!!\n\033[0m"

echo -e ${grn}"Initializing and populating keyring..."${txtrst}
pacman-key --init >/dev/null 2>&1
pacman-key --populate >/dev/null 2>&1
setcap cap_net_raw+p /usr/sbin/ping
getent passwd builder >/dev/null && (userdel builder && rm -rf /home/builder && sed -i '/builder ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers)
sudo systemctl daemon-reload
sudo systemctl enable wslg-init.service >/dev/null 2>&1

echo -e ${grn}"Do you want to create a new user?"${txtrst}
select yn in "Yes" "No"; do
    case $yn in
        Yes)
            echo " "
            while read -p "Please enter the username you wish to create : " username; do
                if [ "x$username" = "x" ]; then
                    echo -e ${red}" Blank username entered. Try again!!!"${txtrst}
                    echo -en "\033[1A\033[1A\033[2K"
                    username=""
                elif grep -q "^$username" /etc/passwd; then
                    echo -e ${red}"Username already exists. Try again!!!"${txtrst}
                    echo -en "\033[1A\033[1A\033[2K"
                    username=""
                else
                    useradd -m -g users -G wheel -s /bin/bash "$username"
                    echo -en "\033[1B\033[1A\033[2K"
                    passwd $username
                    sed -i "/\[user\]/a default = $username" /etc/wsl.conf >/dev/null
                    echo "@echo off" | sudo tee -a ~/shutdown.cmd >/dev/null 2>&1
                    echo "wsl.exe --terminate $WSL_DISTRO_NAME" | sudo tee -a ~/shutdown.cmd >/dev/null 2>&1
                    if env | grep "WT_SESSION" >/dev/null 2>&1; then
                        echo "wt.exe -w 0 nt wsl.exe -d $WSL_DISTRO_NAME" | sudo tee -a ~/shutdown.cmd >/dev/null 2>&1
                    else
                        echo "cmd /c start \"$WSL_DISTRO_NAME\" wsl.exe --cd ~ -d $WSL_DISTRO_NAME" | sudo tee -a ~/shutdown.cmd >/dev/null 2>&1
                    fi
                    echo "del C:\Users\Public\shutdown.cmd" | sudo tee -a ~/shutdown.cmd >/dev/null 2>&1
                    cp ~/shutdown.cmd /mnt/c/Users/Public

                    if echo $(wsl.exe --version | tr -d '\0' | sed -n 1p | cut -f3 -d " " | cut -f1 -d ".") >0 || echo $(wsl.exe --version | tr -d '\0' | sed -n 1p | cut -f3 -d " " | cut -f2 -d ".") >0 || (($(echo $(wsl.exe --version | tr -d '\0' | sed -n 1p | cut -f3 -d " " | cut -f2-3 -d ".") '>' 67.5 | bc))); then
                        commandline="systemd=true"
                        echo "$commandline" >>/etc/wsl.conf
                    else
                        commandline="command = \"/usr/bin/env -i /usr/bin/unshare --fork --mount --propagation shared --mount-proc --pid -- sh -c 'mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc; [ -x /usr/lib/systemd/systemd ] && exec /usr/lib/systemd/systemd --unit=multi-user.target || exec /lib/systemd/systemd --unit=multi-user.target'\""
                        echo "$commandline" >>/etc/wsl.conf
                        wget https://raw.githubusercontent.com/diddledani/one-script-wsl2-systemd/main/src/sudoers -O /etc/sudoers.d/wsl2-systemd
                        sed -i 's/%sudo/%wheel/g' /etc/sudoers.d/wsl2-systemd
                        wget https://raw.githubusercontent.com/diddledani/one-script-wsl2-systemd/4dc64fba72251f1d9804ec64718bb005e6b27b62/src/00-wsl2-systemd.sh -P /etc/profile.d/
                        sed -i '/\\nSystemd/d' /etc/profile.d/00-wsl2-systemd.sh
                    fi

                    secs=3
                    printf ${ylw}"\nTo set the new user as the default user, ManjaroWSL2 will shutdown and restart!!!\n\n"${txtrst}
                    while [ $secs -gt 0 ]; do
                        printf "\r\033[KShutting down in %.d seconds. " $((secs--))
                        sleep 1
                    done

                    rm ~/.bash_profile
                    powershell.exe -command "Start-Process -Verb Open -FilePath 'shutdown.cmd' -WorkingDirectory 'C:\Users\Public' -WindowStyle Hidden"
                    exec sleep 0
                fi
            done
            ;;
        No)
            break
            ;;
    esac
done

if echo $(wsl.exe --version | tr -d '\0' | sed -n 1p | cut -f3 -d " " | cut -f1 -d ".") >0 || echo $(wsl.exe --version | tr -d '\0' | sed -n 1p | cut -f3 -d " " | cut -f2 -d ".") >0 || (($(echo $(wsl.exe --version | tr -d '\0' | sed -n 1p | cut -f3 -d " " | cut -f2-3 -d ".") '>' 67.5 | bc))); then
    commandline="systemd=true"
    echo "$commandline" >>/etc/wsl.conf
else
    commandline="command = \"/usr/bin/env -i /usr/bin/unshare --fork --mount --propagation shared --mount-proc --pid -- sh -c 'mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc; [ -x /usr/lib/systemd/systemd ] && exec /usr/lib/systemd/systemd --unit=multi-user.target || exec /lib/systemd/systemd --unit=multi-user.target'\""
    echo "$commandline" >>/etc/wsl.conf
    wget https://raw.githubusercontent.com/diddledani/one-script-wsl2-systemd/main/src/sudoers -O /etc/sudoers.d/wsl2-systemd
    sed -i 's/%sudo/%wheel/g' /etc/sudoers.d/wsl2-systemd
    wget https://raw.githubusercontent.com/diddledani/one-script-wsl2-systemd/4dc64fba72251f1d9804ec64718bb005e6b27b62/src/00-wsl2-systemd.sh -P /etc/profile.d/
    sed -i '/\\nSystemd/d' /etc/profile.d/00-wsl2-systemd.sh
fi

echo "@echo off" | sudo tee -a ~/shutdown.cmd >/dev/null 2>&1
echo "wsl.exe --terminate $WSL_DISTRO_NAME" | sudo tee -a ~/shutdown.cmd >/dev/null 2>&1
if env | grep "WT_SESSION" >/dev/null 2>&1; then
    echo "wt.exe -w 0 nt wsl.exe -d $WSL_DISTRO_NAME" | sudo tee -a ~/shutdown.cmd >/dev/null 2>&1
else
    echo "cmd /c start \"$WSL_DISTRO_NAME\" wsl.exe --cd ~ -d $WSL_DISTRO_NAME" | sudo tee -a ~/shutdown.cmd >/dev/null 2>&1
fi
echo "del C:\Users\Public\shutdown.cmd" | sudo tee -a ~/shutdown.cmd >/dev/null 2>&1
cp ~/shutdown.cmd /mnt/c/Users/Public

secs=3
printf ${ylw}"\nManjaroWSL2 will shutdown and restart to setup systemd!!!\n\n"${txtrst}
while [ $secs -gt 0 ]; do
    printf "\r\033[KShutting down in %.d seconds. " $((secs--))
    sleep 1
done

rm ~/.bash_profile
powershell.exe -command "Start-Process -Verb Open -FilePath 'shutdown.cmd' -WorkingDirectory 'C:\Users\Public' -WindowStyle Hidden"
exec sleep 0
