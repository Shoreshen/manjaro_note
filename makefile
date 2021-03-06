DIF := $(shell cmp /etc/resolv.conf resolv.conf)
ORGNOTES = $(shell find ~/OneDrive -path ~/OneDrive/manjaro_note -prune -o -name *.org -a -print)
PW = $(shell cat ~/文档/PW)

upload:
	rclone sync ~/OneDrive/Book onedrive:Book

test:
	@echo $(PW)

cporg: $(ORGNOTES)
	rm ./OrgNotes/*
	cp $(ORGNOTES) ./OrgNotes

installall:
	echo $(PW) | sudo -S pacman -S seahorse nerd-fonts-terminus rclone fcitx-qt5 fcitx-configtool fcitx-sogoupinyin emacs uget aria2-fast uget-integrator uget-integrator-chromium netease-cloud-music gnome-calculator

connect: set_dns
# "|" Pass results of "ls -l" to "awk"
# "$$9" Will be interpreted as "$9", take the 9'th argument, which is "./OpenVPN/uk4107.nordvpn.com.udp.ovpn" like strings
	ls -l ./OpenVPN/*.ovpn | awk '{print substr($$9, 11, 100)}' 
# Take server from user input, if not input, connect “./OpenVPN/us7092.nordvpn.com.udp.ovpn”
	@echo "Please pick a server(defualt: us5037.nordvpn.com.udp.ovpn): "; \
	read server; \
	if [ -z $$server ]; then \
		echo $(PW) | sudo -S openvpn --config ./OpenVPN/us5037.nordvpn.com.udp.ovpn --auth-user-pass ~/文档/Auth.txt; \
	else \
		echo $(PW) | sudo -S openvpn --config ./OpenVPN/$$server --auth-user-pass ~/文档/Auth.txt; \
	fi

set_dns:  
ifeq ($(DIF),)
	cat /etc/resolv.conf
else
	rm ./OpenVPN/resolv.conf
	cp /etc/resolv.conf ./OpenVPN
	echo $(PW) | sudo -S rm /etc/resolv.conf
	sudo cp resolv.conf /etc/
	sudo chattr +i /etc/resolv.conf
	cat /etc/resolv.conf
endif

save_dns:
	rm ./OpenVPN/resolv.conf
	cp /etc/resolv.conf ./OpenVPN

rec_dns:
	cat /etc/resolv.conf
	echo $(PW) | sudo -S chattr -i /etc/resolv.conf
	sudo rm /etc/resolv.conf
	sudo cp ./OpenVPN/resolv.conf /etc/
	cat /etc/resolv.conf

split_scrn:
	xrandr --output HDMI-0 --auto --right-of DP-2

split_scrn_left:
	xrandr --output HDMI-0 --auto --left-of DP-2

update:
	echo $(PW) | sudo -S pacman -Syy
	sudo pacman -Syu

version:
	cat /etc/lsb-release 

serv_sun:
	xhost + 
	echo $(PW) | sudo -S systemctl start runsunloginclient
	xhost -

st_docker:
	echo $(PW) | sudo -S systemctl start docker	

commit: cporg
	git add -A
	@echo "Please type in commit comment: "; \
	read comment; \
	git commit -m"$$comment"

sync: commit
	git push -u origin master

ipsec_restart:
	echo $(PW) | sudo -S ipsec restart

conn:set_dns ipsec_restart # try 1.1.1.1 and 1.0.0.1 for dns
	sleep 0.5
	echo $(PW) | sudo -S ipsec up NordVPN

disconn:rec_dns
	sleep 0.5
	echo $(PW) | sudo -S ipsec down NordVPN

nordconn:save_dns
	echo $(PW) | sudo -S nordvpn c

norddisconn:
	echo $(PW) | sudo -S nordvpn d
	sudo rm /etc/resolv.conf
	sudo cp ./OpenVPN/resolv.conf /etc/	