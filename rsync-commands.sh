# rsync -avzh my_dir user@remotehost:/home/user/path/



# https://serverfault.com/questions/43014/copying-a-large-directory-tree-locally-cp-or-rsync

# rsync -avhW --no-compress --progress /src/ /dst/

# -a is for archive, which preserves ownership, permissions etc.
# -v is for verbose, so I can see what's happening (optional)
# -h is for human-readable, so the transfer rate and file sizes are easier to read (optional)
# -W is for copying whole files only, without delta-xfer algorithm which should reduce CPU load
# --no-compress as there's no lack of bandwidth between local devices
# --progress so I can see the progress of large files (optional)
