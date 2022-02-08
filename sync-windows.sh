rsync --update -avhW --no-compress --progress $WINHOME/* /home/tom/share/
rsync --update -avhW --no-compress --progress /home/tom/share/ $WINHOME
