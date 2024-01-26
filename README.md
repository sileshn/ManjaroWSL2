# Disclaimer

This project is in no way related to or created by the official Manjaro team or its members. It is solely a project of mine. Do not go around spamming the Manjaro forum if you come across any issues. You certainely won't receive any help. Mention your issues here and I'll try to find a solution.

## ManjaroWSL2
Manjaro on WSL2 (Windows 10 FCU or later) based on [wsldl](https://github.com/yuk7/wsldl).

[![Screenshot-2022-11-17-155106.png](https://i.postimg.cc/YCk0Gs9H/Screenshot-2022-11-17-155106.png)](https://postimg.cc/sv6sbK76)
[![Github All Releases](https://img.shields.io/github/downloads/sileshn/ManjaroWSL2/total?logo=github&style=flat-square)](https://github.com/sileshn/ManjaroWSL2/releases) [![GitHub release (latest by date)](https://img.shields.io/github/v/release/sileshn/ManjaroWSL2?display_name=release&label=latest%20release&style=flat-square)](https://github.com/sileshn/ManjaroWSL2/releases/latest)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![License](https://img.shields.io/github/license/sileshn/ManjaroWSL2.svg?style=flat-square)](https://github.com/sileshn/ManjaroWSL2/blob/main/LICENSE)

## Features and important information
ManjaroWSL2 may not properly load the Intel WSL driver by default which makes it impossible to use the D3D12 driver on Intel graphics cards. This is because the Intel WSL driver files link against libraries that do not exist on Manjaro. You can manually fix this issue using `ldd` to see which libraries they are linked, eg: `ldd /usr/lib/wsl/drivers/iigd_dch_d.inf_amd64_49b17bc90a910771/*.so`, and then try installing the libraries marked `not found` from the Manjaro package repository. If the corresponding library file is not found in the package repository, it may be that the version suffix of the library file is different, such as `libedit.so.0.0.68` and `libedit.so.2`. In such a case, you can try to create a symlink.

ManjaroWSL2 has the following features during the installation stage.
* Increase virtual disk size from the default 256GB
* Create a new user and set the user as default
* ManjaroWSL2 Supports systemd natively if you are running wsl v0.67.6 (more details [here](https://devblogs.microsoft.com/commandline/systemd-support-is-now-available-in-wsl/)) and above. For earlier versions of wsl, systemd is supported using diddledani's [one-script-wsl2-systemd](https://github.com/diddledani/one-script-wsl2-systemd). This is done automatically during initial setup.
* ManjaroWSL2 includes a wsl.conf file which only has [section headers](https://i.postimg.cc/MZ4DC1Fw/Screenshot-2022-02-02-071533.png). Users can use this file to configure the distro to their liking. You can read more about wsl.conf and its configuration settings [here](https://docs.microsoft.com/en-us/windows/wsl/wsl-config).

## Requirements
* For x64 systems: Version 1903 or higher, with Build 18362 or higher.
* For ARM64 systems: Version 2004 or higher, with Build 19041 or higher.
* Builds lower than 18362 do not support WSL 2.
* If you are running Windows 10 version 2004 or higher, you can install all components required to run wsl2 with a single command. This will install ubuntu by default. More details are available [here](https://devblogs.microsoft.com/commandline/install-wsl-with-a-single-command-now-available-in-windows-10-version-2004-and-higher/).
	```cmd
	wsl.exe --install
	```
* If you are running Windows 10 lower then version 2004, follow the steps below. For more details, check [this](https://docs.microsoft.com/en-us/windows/wsl/install-manual) microsoft document.
	* Enable Windows Subsystem for Linux feature.
	```cmd
	dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
	```
	* Enable Virtual Machine feature
	```cmd
	dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
	```
	* Download and install the latest Linux kernel update package from [here](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi).

## How to install
* Make sure all the steps mentioned under "Requirements" are completed.
* [Download](https://github.com/sileshn/ManjaroWSL2/releases/latest) installer zip
* Extract all files in zip file to same directory
* Set version 2 as default. Note that this step is required only for manual installation.
  ```dos
  wsl --set-default-version 2
  ```
* Run Manjaro.exe to extract rootfs and register to WSL

**Note:**
Exe filename is using the instance name to register. If you rename it you can register with a diffrent name and have multiple installs.

## How to setup
ManjaroWSL2 will ask you to create a new user during its first run. If you choose to create a new user during the first run, the steps below are not required unless you want to create additional users.

Open Manjaro.exe and run the following commands.
```dos
passwd
useradd -m -g users -G wheel -s /bin/bash <username>
echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/wheel
passwd <username>
exit
```

You can set the user you created as default user using 2 methods.

Open Manjaro.exe, run the following command (replace username with the actual username you created).
```dos
sed -i '/\[user\]/a default = username' /etc/wsl.conf
```

Shutdown and restart the distro (this step is important).

(or)

Execute the command below in a windows cmd terminal from the directory where Manjaro.exe is installed.
```dos
>Manjaro.exe config --default-user <username>
```

Set up pacman mirrors before you proceed using ManjaroWSL2. Pacman is configured to use the Global mirror by default. Switch to the mirror/mirrors of your choice or reset to use all mirrors before you update. More information on how to use pacman-mirrors is available [here](https://wiki.manjaro.org/index.php/Pacman-mirrors).
```dos
$sudo pacman-mirrors --country <name>
$sudo pacman -Syu
```

## How to use installed instance
#### exe usage
```
Usage :
    <no args>
      - Open a new shell with your default settings.

    run <command line>
      - Run the given command line in that instance. Inherit current directory.

    runp <command line (includes windows path)>
      - Run the given command line in that instance after converting its path.

    config [setting [value]]
      - `--default-user <user>`: Set the default user of this instance to <user>.
      - `--default-uid <uid>`: Set the default user uid of this instance to <uid>.
      - `--append-path <true|false>`: Switch of Append Windows PATH to $PATH
      - `--mount-drive <true|false>`: Switch of Mount drives
      - `--default-term <default|wt|flute>`: Set default type of terminal window.

    get [setting]
      - `--default-uid`: Get the default user uid in this instance.
      - `--append-path`: Get true/false status of Append Windows PATH to $PATH.
      - `--mount-drive`: Get true/false status of Mount drives.
      - `--wsl-version`: Get the version os the WSL (1/2) of this instance.
      - `--default-term`: Get Default Terminal type of this instance launcher.
      - `--lxguid`: Get WSL GUID key for this instance.

    backup [contents]
      - `--tar`: Output backup.tar to the current directory.
      - `--reg`: Output settings registry file to the current directory.
	  - `--tgz`: Output backup.tar.gz to the current directory.
      - `--vhdx`: Output backup.ext4.vhdx to the current directory.
      - `--vhdxgz`: Output backup.ext4.vhdx.gz to the current directory.

    clean
      - Uninstall that instance.

    help
      - Print this usage message.
```

#### Run exe
```cmd
>{InstanceName}.exe
[root@PC-NAME user]#
```

#### Run with command line
```cmd
>{InstanceName}.exe run uname -r
4.4.0-43-Microsoft
```

#### Run with command line using path translation
```cmd
>{InstanceName}.exe runp echo C:\Windows\System32\cmd.exe
/mnt/c/Windows/System32/cmd.exe
```

#### Change default user(id command required)
```cmd
>{InstanceName}.exe config --default-user user

>{InstanceName}.exe
[user@PC-NAME dir]$
```

#### Set "Windows Terminal" as default terminal
```cmd
>{InstanceName}.exe config --default-term wt
```

## How to update
Updating Manjaro doesn't require you to download and install a newer release everytime. Usually all it takes is to run the command below to update the instance.
```dos
$sudo pacman -Syu
```

Sometimes updates may fail to install. You can try the command below in such a situation.
```dos
$sudo pacman -Syyuu
```

You may need to install a newer release if additional features have been added/removed from the installer.

## How to uninstall instance
```dos
>Manjaro.exe clean

```

## How to backup instance
export to backup.tar.gz
```cmd
>Manjaro.exe backup --tgz
```
export to backup.ext4.vhdx.gz
```cmd
>Manjaro.exe backup --vhdxgz
```

## How to restore instance

There are 2 ways to do it. 

Rename the backup to rootfs.tar.gz and run Manjaro.exe

(or)

.tar(.gz)
```cmd
>Manjaro.exe install backup.tar.gz
```
.ext4.vhdx(.gz)
```cmd
>Manjaro.exe install backup.ext4.vhdx.gz
```

You may need to run the command below in some circumstances.
```cmd
>Manjaro.exe --default-uid 1000
```

## How to build from source
#### prerequisites
Docker, tar, zip, unzip, bsdtar need to be installed.

```dos
git clone git@gitlab.com:sileshn/ManjaroWSL2.git
cd ManjaroWSL2
make
```
Copy the Manjaro.zip file to a safe location and run the command below to clean.
```dos
make clean
```

## How to run docker in ManjaroWSL2 without using docker desktop
Install docker.
```dos
sudo pacman -S docker
```

Follow [this](https://blog.nillsf.com/index.php/2020/06/29/how-to-automatically-start-the-docker-daemon-on-wsl2/) blog post for further details on how to setup. Alternatively, if using systemd, use the commands below to setup and reboot.
```dos
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER
```
[![Screenshot-2022-11-17-155326.png](https://i.postimg.cc/Pq7d43tN/Screenshot-2022-11-17-155326.png)](https://postimg.cc/5Hwc9mQM)

## Setup desktop environment

You need to follow the [official instructions](https://wiki.manjaro.org/index.php/Install_Desktop_Environments#KDE_Plasma_5) to setup desktop environment.

Take Plasma 5 as an example, first install the desktop environment:
```shell
sudo pacman -S plasma kio-extras
sudo systemctl enable sddm.service --force
```

Second, you need to install the xorg and xrdp.
```shell
pacman -S xorg xorg-server xrdp
```
xorgxrdp is in AUR so you can install it with yay or pamac.
```shell
yay -S xorgxrdp
```
Then you need to enable and start xrdp service.
```shell
sudo systemctl enable xrdp.service
sudo systemctl start xrdp.service
sudo systemctl reboot
```
[Refference](https://www.reddit.com/r/ManjaroLinux/comments/iu1mxb/manjaro_running_on_wsl_2_windows_subsystem_for/)

After that, you will need to add below code to your ~/.xinitrc file.
Create one if it doesn't exist.
```shell
#!/bin/sh
/usr/lib/plasma-dbus-run-session-if-needed startplasma-x11
```
[Refference for this](https://wiki.archlinux.org/title/xrdp#Black_screen_with_a_desktop_environment)

Finally, execute `ip addr | grep eth0` to get the IP address.

You should be able to press `Win+R` and run `mstsc` to connect to your 

RDP server with the ip:3389 as target input.

Remember to select the `xvnc` option to log in, 
you should be able to see the desktop after it.
