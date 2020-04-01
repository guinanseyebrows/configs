# bar
~/.local/bin/bar.sh &

# hotkeys
sxhkd &

# compositor
#picom --no-fading-openclose &
picom &

# background
~/.fehbg &

# caps -> ctrl
setxkbmap -option ctrl:nocaps &

# sleep lock

xss-lock -- slock &


exec cwm
