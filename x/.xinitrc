# bar
~/.local/bin/bar.sh &

# hotkeys
sxhkd &

# libinput-gestures
libinput-gestures-setup start & 

# compositor
picom &

# background
~/.fehbg &

# caps -> ctrl
setxkbmap -option ctrl:nocaps &

# sleep lock

xss-lock -- slock &

# ow my eyes
redshift &

exec cwm
