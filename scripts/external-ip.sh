# https://unix.stackexchange.com/questions/22615/how-can-i-get-my-external-ip-address-in-a-shell-script

dig @resolver1.opendns.com ANY myip.opendns.com +short

dig @resolver1.opendns.com ANY myip.opendns.com +short > ip_address.txt

scp $USER@$HOST:/home/$USER/ip_address.txt



