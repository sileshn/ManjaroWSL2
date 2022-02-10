# First run script for ManjaroWSL.

echo -e "\033[33;7mDo not interrupt or close this window till script finishes and takes you to the next screen\033[0m"
echo " "
echo -e "\033[32mInitialize keyring & fasttrack mirrors\033[m"
pacman-key --init
pacman-key --populate
pacman-mirrors --fasttrack 5
setcap cap_net_raw+p /usr/sbin/ping
rm /var/lib/dbus/machine-id
dbus-uuidgen --ensure=/etc/machine-id
dbus-uuidgen --ensure
userdel builder
rm -rf /builder
sed -i '/builder ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
echo -e "[automount]\n\n[network]\n\n[interop]\n\n[user]\n\n#The Boot setting is only available on Windows 11\n[boot]\n" > /etc/wsl.conf

clear
rm ~/.bash_profile 