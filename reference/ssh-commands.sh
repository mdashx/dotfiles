# Start VPN connection

ssh-add ./aws_bastion_key
ssh-add MISP-ec2.pem

get_utility_bastion_ip

ssh -A tomh@10.10.10.170
ssh ubuntu@10.100.15.74 # whatever the MISP IP is




