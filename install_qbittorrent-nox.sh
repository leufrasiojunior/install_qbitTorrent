#!/usr/bin/env bash

#This script Install qBitTorrent-nox automatized.
#More info:https://github.com/qbittorrent/qBittorrent/wiki/Setting-up-qBittorrent-on-Ubuntu-server-as-daemon-with-Web-interface-(15.04-and-newer)
#Licence: GNU 3.0

main() {

    ######## FIRST CHECK ########
    # Must be root to install
	echo ":::"
	if [[ $EUID -eq 0 ]];then
		echo "::: You are root."
	else
		echo "::: Please, run this script as root/sudo"
		exit 1
	fi

#Add repository stable
	add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable
	
#Update and install software.
	apt-get update && apt-get install qbittorrent-nox -y
	clear
#Add user to manage qbitTorrent-nox
	read -sp "Please, insert password to user qbtuser: " PASS
	useradd -m qbtuser -p $PASS
	
#Generate Systemd service 

cat > /etc/systemd/system/qbittorrent.service << _EOF_
[Unit]
Description=qBittorrent Daemon Service
After=network.target

[Service]
User=qbtuser
Group=qbtuser
ExecStart=/usr/bin/qbittorrent-nox
ExecStop=/usr/bin/killall -w qbittorrent-nox

[Install]
WantedBy=multi-user.target	
_EOF_

#Reload Systemd
	systemctl daemon-reload

#Start Software to create config file
	qbittorrent-nox

#Start Service
	sudo systemctl start qbittorrent
#Status Service
	sudo systemctl status qbittorrent
#Start in boot
	sudo systemctl enable qbittorrent
#Disable SSH login do user qbtuser
	usermod -s /usr/sbin/nologin qbtuser	
}

	if [[ "${QBIT_TEST}" != true ]] ; then
  main "$@"
	fi







































