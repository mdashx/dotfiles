# https://github.com/microsoft/WSL/issues/4245#issuecomment-507619097
# ~/set-date.sh

# Get time from google server or some other reliable source
# TIME_FROM_SERVER=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //');

# echo "$TIME_FROM_SERVER"

# # Set stored time
# date +"%d%m%Y%H%M%S" -d "$TIME_FROM_SERVER";

# echo "Time updated with success!";

# ^^ - this doesn't really work

# vv - do this instead

# sudo apt install ntpdate
sudo ntpdate -sb time.nist.gov
