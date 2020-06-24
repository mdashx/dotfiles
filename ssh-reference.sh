# ssh tom@hydrogen 'ls -l; ps -e; whoami'

# Command that requires interaction, use -t flag to keep session
# running

# ssh -t tom@hydrogen 'top'

# Run script

ssh tom@hydrogen 'bash -s' < system_info.sh
