# ManjaroWSL
Manjaro on WSL2 (Windows 10 FCU or later) based on [wsldl](https://github.com/yuk7/wsldl).

<a href='http://postimg.cc/jDB0gdQ2' target='_blank'><img src='https://i.postimg.cc/jDB0gdQ2/Screenshot-2022-02-21-162309.png' border='0' alt='Screenshot-2022-02-21-162309'/></a> <a href='http://postimg.cc/S2h04TPp' target='_blank'><img src='https://i.postimg.cc/S2h04TPp/Screenshot-2022-02-21-162326.png' border='0' alt='Screenshot-2022-02-21-162326'/></a> <a href='http://postimg.cc/Ppzg5bGv' target='_blank'><img src='https://i.postimg.cc/Ppzg5bGv/Screenshot-2022-02-21-162404.png' border='0' alt='Screenshot-2022-02-21-162404'/></a> <a href='http://postimg.cc/K4mXsWLP' target='_blank'><img src='https://i.postimg.cc/K4mXsWLP/Screenshot-2022-02-21-162919.png' border='0' alt='Screenshot-2022-02-21-162919'/></a> <a href='http://postimg.cc/LnscmZxh' target='_blank'><img src='https://i.postimg.cc/LnscmZxh/Screenshot-2022-02-21-162502.png' border='0' alt='Screenshot-2022-02-21-162502'/></a>  <a href='http://postimg.cc/vcg6pqdm' target='_blank'><img src='https://i.postimg.cc/vcg6pqdm/Screenshot-2022-02-17-125524.png' border='0' alt='Screenshot-2022-02-17-125524'/></a> <a href='http://postimg.cc/PNFwVG9c' target='_blank'><img src='https://i.postimg.cc/PNFwVG9c/Screenshot-2022-02-17-125501.png' border='0' alt='Screenshot-2022-02-17-125501'/></a> <a href='http://postimg.cc/67CcwbVw' target='_blank'><img src='https://i.postimg.cc/67CcwbVw/Screenshot-2022-02-17-111059.png' border='0' alt='Screenshot-2022-02-17-111059'/></a>
[![Github All Releases](https://img.shields.io/github/downloads/sileshn/ManjaroWSL/total?logo=github&style=flat-square)](https://github.com/sileshn/ManjaroWSL/releases) [![SourceForge](https://img.shields.io/sourceforge/dt/manjarowsl?color=ff6700&logo=sourceforge&style=flat-square)](https://sourceforge.net/projects/manjarowsl/files/latest/download) [![GitHub release (latest by date)](https://img.shields.io/github/v/release/sileshn/ManjaroWSL?display_name=release&label=latest%20release&style=flat-square)](https://github.com/sileshn/ManjaroWSL/releases/latest)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![License](https://img.shields.io/github/license/sileshn/ManjaroWSL.svg?style=flat-square)](https://github.com/sileshn/ManjaroWSL/blob/main/LICENSE)

## Features and important information
ManjaroWSL has the following features during the installation stage.
* Increase virtual disk size from the default 256GB
* Create a new user and set the user as default
* ManjaroWSL supports systemd using diddledani's [one-script-wsl2-systemd](https://github.com/diddledani/one-script-wsl2-systemd). You can do a minimal setup using [this](https://github.com/diddledani/one-script-wsl2-systemd#minimal-manual-installation) procedure.
* ManjaroWSL includes a wsl.conf file which only has [section headers](https://i.postimg.cc/MZ4DC1Fw/Screenshot-2022-02-02-071533.png). Users can use this file to configure the distro to their liking. You can read more about wsl.conf and its configuration settings [here](https://docs.microsoft.com/en-us/windows/wsl/wsl-config).

## Requirements
* For x64 systems: Version 1903 or higher, with Build 18362 or higher.
* For ARM64 systems: Version 2004 or higher, with Build 19041 or higher.
* Builds lower than 18362 do not support WSL 2.
* Enable Windows Subsystem for Linux feature. Open PowerShell as Administrator and run:
```cmd
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```
* Enable Virtual Machine feature. Open PowerShell as Administrator and run:
```cmd
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```
* Download and install the latest Linux kernel update package from [here](https://www.catalog.update.microsoft.com/Search.aspx?q=wsl). Its a cab file. Open and extract the exe file within using 7zip/winzip/winrar.

For more details, check [this](https://docs.microsoft.com/en-us/windows/wsl/install-win10) microsoft document.

## How to install
* Make sure all the steps mentioned under "Requirements" are completed.
* Set wsl2 as default. Run the command below in a windows cmd terminal.
```dos
wsl --set-default-version 2
```
* [Download](https://github.com/sileshn/ManjaroWSL/releases/latest) installer zip.
* Extract all files in zip file to same directory.
* Run Manjaro.exe to Extract rootfs and Register to WSL

Alternatively, you can use [Scoop](https://scoop.sh/):
```dos
scoop bucket add extras
scoop install manjarowsl
```

**Note:**
Exe filename is using the instance name to register. If you rename it, you can register with a different name and have multiple installs.

## How to setup
ManjaroWSL will ask you to create a new user during its first run. If you choose to create a new user during the first run, the steps below are not required unless you want to create additional users.

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

Set up pacman mirrors before you proceed using ManjaroWSL. Pacman is configured to use the Global mirror by default. Switch to the mirror/mirrors of your choice or reset to use all mirrors before you update. More information on how to use pacman-mirrors is available [here](https://wiki.manjaro.org/index.php/Pacman-mirrors).
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

If you have used Scoop to install Manjaro, you can use it to update to a newer release.
```dos
scoop update manjarowsl
```

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
git clone git@gitlab.com:sileshn/ManjaroWSL.git
cd ManjaroWSL
make

```
Copy the Manjaro.zip file to a safe location and run the command below to clean.
```dos
make clean

```

## How to run docker in ManjaroWSL without using docker desktop
Install docker.
```dos
sudo pacman -S docker

```

Follow [this](https://blog.nillsf.com/index.php/2020/06/29/how-to-automatically-start-the-docker-daemon-on-wsl2/) blog post for further details on how to set it up.

[![Screenshot-2021-01-27-175029.png](https://i.postimg.cc/Z5vGPXwn/Screenshot-2021-01-27-175029.png)](https://postimg.cc/fVZqDqnQ)
