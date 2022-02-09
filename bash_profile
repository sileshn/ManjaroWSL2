# First run script for ManjaroWSL

echo -e "\033[32mInitialize keyring & fasttrack mirrors\033[m"
pacman-key --init
pacman-key --populate
pacman-mirrors --fasttrack 5

clear
rm ~/.bash_profile 