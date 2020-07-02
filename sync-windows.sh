

rsync --update -avhW --no-compress --progress $WINHOME/* /home/tom/windows/
rsync --update -avhW --no-compress --progress /home/tom/windows/ $WINHOME
