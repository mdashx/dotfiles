#!/bin/bash
sudo update-locale LANG=en_US.utf8
sudo apt-get install software-properties-common

if ! grep -q "ubuntu-elisp" /etc/apt/sources.list.d/*; then
	sudo add-apt-repository ppa:ubuntu-elisp/ppa
	sudo apt-get update
fi

sudo apt-get install emacs-snapshot
