DIF := $(shell cmp /etc/resolv.conf resolv.conf)
PW = $(shell cat ~/文档/PW)
SERVER = $(shell cat ~/文档/SERVER)
BRANCH = $(shell git symbolic-ref --short HEAD)

cporg: ORGNOTES = $(shell find ~/文档/note/ -path -prune -o -name *.org -a -print)

upload:
	rclone sync ~/OneDrive/Book onedrive:Book

test:
	@echo $(ORGNOTES)

cporg: $(ORGNOTES)
	-rm ./OrgNotes/*
	cp $(ORGNOTES) ./OrgNotes
	echo $(ORGNOTES) > ./OrgNotes/org_dirs

installall:
	echo $(PW) | sudo -S pacman -S seahorse nerd-fonts-terminus rclone fcitx-qt5 fcitx-configtool fcitx-sogoupinyin emacs uget aria2-fast uget-integrator uget-integrator-chromium netease-cloud-music gnome-calculator

# connect: set_dns
# # "|" Pass results of "ls -l" to "awk"
# # "$$9" Will be interpreted as "$9", take the 9'th argument, which is "./OpenVPN/uk4107.nordvpn.com.udp.ovpn" like strings
# 	ls -l ./OpenVPN/*.ovpn | awk '{print substr($$9, 11, 100)}' 
# # Take server from user input, if not input, connect “./OpenVPN/us7092.nordvpn.com.udp.ovpn”
# 	@echo "Please pick a server(defualt: us5037.nordvpn.com.udp.ovpn): "; \
# 	read server; \
# 	if [ -z $$server ]; then \
# 		echo $(PW) | sudo -S openvpn --config ./OpenVPN/us5037.nordvpn.com.udp.ovpn --auth-user-pass ~/文档/Auth.txt; \
# 	else \
# 		echo $(PW) | sudo -S openvpn --config ./OpenVPN/$$server --auth-user-pass ~/文档/Auth.txt; \
# 	fi

connect:
	echo $(PW) | sudo -S openvpn --config ~/文档/conf/str-yul301_s316207_account.ovpn --auth-user-pass ~/文档/conf/auth.txt
conn_yizhu:
	echo $(PW) | sudo -S openvpn --config ~/文档/work/亿铸/VPN/yz.ovpn --auth-user-pass /home/shore/文档/work/亿铸/VPN/auth.txt --askpass /home/shore/文档/work/亿铸/VPN/privatepass.txt
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
ban_ipv6:
	echo $(PW) | sudo -S sysctl -w net.ipv6.conf.all.disable_ipv6=1

split_scrn:
	xrandr --output HDMI-0 --auto --right-of DP-2

split_scrn_left:
	xrandr --output HDMI-0 --auto --left-of DP-2

update:
	- echo $(PW) | sudo -S pacman -Syy
	- sudo pacman -Syu
	- sudo pamac update

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

conn: 
	echo $(PW) | sudo -S wg-quick up $(SERVER)

disip:
	echo $(PW) | sudo -S ipsec down NordVPN

# First disconnnect strongswan, then revert dns
disconn:
	echo $(PW) | sudo -S wg-quick down $(SERVER)

nordconn:save_dns
	echo $(PW) | sudo -S nordvpn c

norddisconn:
	echo $(PW) | sudo -S nordvpn d
	sudo rm /etc/resolv.conf
	sudo cp ./OpenVPN/resolv.conf /etc/	

restart_net:
	echo $(PW) | sudo -S systemctl restart NetworkManager

brightness:
	xrandr -q | grep connected
	@echo "Please select displayer and brightness (1.1 means 1.1 times of current brightness): "; \
	read displayer; \
	read bright; \
	xrandr --output $$displayer --brightness $$bright
reset_hard:
	git fetch && git reset --hard origin/$(BRANCH)
