OUT_ZIP=ManjaroWSL2.zip
LNCR_EXE=Manjaro.exe

DLR=curl
DLR_FLAGS=-L
LNCR_ZIP_URL=https://github.com/yuk7/wsldl/releases/download/25030400/icons.zip
LNCR_ZIP_EXE=Manjaro.exe

all: $(OUT_ZIP)

zip: $(OUT_ZIP)
$(OUT_ZIP): ziproot
	@echo -e '\e[1;31mBuilding $(OUT_ZIP)\e[m'
	cd ziproot; bsdtar -a -cf ../$(OUT_ZIP) *

ziproot: Launcher.exe rootfs.tar.gz
	@echo -e '\e[1;31mBuilding ziproot...\e[m'
	mkdir ziproot
	cp Launcher.exe ziproot/${LNCR_EXE}
	cp rootfs.tar.gz ziproot/

exe: Launcher.exe
Launcher.exe: icons.zip
	@echo -e '\e[1;31mExtracting Launcher.exe...\e[m'
	unzip icons.zip $(LNCR_ZIP_EXE)
	mv $(LNCR_ZIP_EXE) Launcher.exe

icons.zip:
	@echo -e '\e[1;31mDownloading icons.zip...\e[m'
	$(DLR) $(DLR_FLAGS) $(LNCR_ZIP_URL) -o icons.zip

rootfs.tar.gz: rootfs
	@echo -e '\e[1;31mBuilding rootfs.tar.gz...\e[m'
	cd rootfs; sudo bsdtar -zcpf ../rootfs.tar.gz `sudo ls`
	sudo chown `id -un` rootfs.tar.gz

rootfs: base.tar
	@echo -e '\e[1;31mBuilding rootfs...\e[m'
	mkdir rootfs
	sudo bsdtar -zxpf base.tar -C rootfs
	@echo "# This file was automatically generated by WSL. To stop automatic generation of this file, remove this line." | sudo tee rootfs/etc/resolv.conf > /dev/null
	sudo cp wsl.conf rootfs/etc/wsl.conf
	sudo cp -f setcap-iputils.hook rootfs/etc/pacman.d/hooks/50-setcap-iputils.hook
	sudo cp bash_profile rootfs/root/.bash_profile
	sudo cp wslg-init.service rootfs/usr/lib/systemd/system/wslg-init.service
	sudo chmod +x rootfs

base.tar:
	@echo -e '\e[1;31mExporting base.tar using docker...\e[m'
	docker run --net=host --ulimit nofile=1024:10240 --name manjarowsl manjarolinux/base:latest /bin/bash -c "pacman-mirrors --fasttrack 5; pacman-key --init; pacman-key --populate; sed -ibak -e 's/#Color/Color/g' -e 's/CheckSpace/#CheckSpace/g' /etc/pacman.conf; sed -ibak -e 's/IgnorePkg/#IgnorePkg/g' /etc/pacman.conf; echo 'export BROWSER="wslview"' | sudo tee -a /etc/skel/.bashrc >/dev/null 2>&1; sed -i 's/#\[multilib\]/\[multilib\]/g' /etc/pacman.conf; sed -i '/\[multilib\]/ { n; s/#Include/Include/; }' /etc/pacman.conf; pacman --noconfirm -Syyu; pacman --noconfirm --needed -Sy aria2 aspell base-devel bc ccache dconf dbus dnsutils dos2unix figlet git grep hspell hunspell hwdata inetutils iputils iproute2 keychain  libva-mesa-driver libva-utils libxcrypt-compat libvoikko linux-tools lolcat mesa-vdpau nano ntp nuspell openssh pamac-cli procps socat sudo usbutils vi vim wget xdg-utils xmlto yay yelp-tools; wget https://pkg.wslutiliti.es/public.key && pacman-key --add public.key && rm ./public.key && pacman-key --lsign-key 2D4C887EB08424F157151C493DD50AA7E055D853; echo '[wslutilities]' | sudo tee -a /etc/pacman.conf >/dev/null 2>&1; echo 'Server = https://pkg.wslutiliti.es/arch/' | sudo tee -a /etc/pacman.conf >/dev/null 2>&1; pacman -Sy wslu; mkdir -p /etc/pacman.d/hooks; echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel; sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen && locale-gen; systemd-machine-id-setup; rm /var/lib/dbus/machine-id; dbus-uuidgen --ensure=/etc/machine-id; dbus-uuidgen --ensure; yes | LC_ALL=en_US.UTF-8 pacman -Scc"
	docker export --output=base.tar manjarowsl
	docker rm -f manjarowsl

clean:
	@echo -e '\e[1;31mCleaning files...\e[m'
	-rm ${OUT_ZIP}
	-rm -r ziproot
	-rm Launcher.exe
	-rm icons.zip
	-rm rootfs.tar.gz
	-sudo rm -r rootfs
	-rm base.tar
	-docker rmi manjarolinux/base:latest -f
