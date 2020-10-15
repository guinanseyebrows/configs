#!/bin/bash

MAINFONT="Roboto:style=Medium:pixelsize=10"
BOLDFONT="Roboto:style=Bold:pixelsize=10"
ICONFONT="forkawesome:pixelsize=13"
BARWIDTH=1920
BARHEIGHT=22
FGCOLOR="#e2e2e2"
BGCOLOR="#f0090909"
#BGCOLOR="#e2e2e2"
ULCOLOR="#e2e2e2"
DISCOLOR="#777777"

clock() {
	TIME=`date "+%a %e %b %l:%M"`
	echo -e "%{F#ffbf00}\uf017%{F-} $TIME"
}

title() {
	WINT=`xtitle`
    case "$WINT" in
            rdesktop*)
                 WINICON="\uf108"
                 ;;
            "*Google Chrome")
                 WINICON="\uf268"
                 ;;
            Slack*)
                 WINICON="\uf198"
                 ;;
            *Firefox)
                 WINICON="\uf269"
                 ;;
            *@*:*|xterm)
                 WINICON="\uf120"
                 ;;
            *)
                 WINICON="\uf1e2"
                 ;;
    esac

#    WINICON="\uf1e2"
	echo -e "%{F#ffbf00}$WINICON %{F-} %{T1}$WINT%{T1}"
}

battery() {
	BATC=`cat /sys/class/power_supply/BAT0/capacity`
	CHRG=`cat /sys/class/power_supply/BAT0/status`
    if (( $BATC >= 85 )); then
	    BICO="\uf240"
    elif (( $BATC >= 60 && $BATC <= 84 )); then
	    BICO="\uf241"
    elif (( $BATC >= 40 && $BATC <=59 )); then
	    BICO="\uf242"
    elif (( $BATC >= 15 && $BATC <= 39 )); then
    	BICO="%{F#f4e241}\uf243%{F-}"
	else
	    BICO="%{F#f45c42}\uf244%{F-}"
	fi

	case "$CHRG" in
	Charging | Unknown)
		BICO="\uf0e7" 
		;;
	esac
	
	echo -e $BICO $BATC%
}
 
volume() {
	VOL=`amixer -c 1 get PCM| sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p'| uniq`
    (( VOL = (VOL/10), VOL *= 10 ))
    if (( $VOL >= 60 )); then
		VOLICON="\uf028"
    elif (( $VOL >= 30 && $VOL <= 59 )); then
		VOLICON="\uf027"
	else
		VOLICON="\uf026"
	fi

    if [[ -n `amixer -c 1 get PCM| grep off` ]]; then
		echo -e "%{F${DISCOLOR}} $VOLICON ${VOL}% %{F-}"
	else
		echo -e "%{F#ffbf00} $VOLICON %{F-}$VOL% "
	fi
}
 

spotifystat() {
    SPOTSTAT=$(ps aux | grep spotify | grep -v 'grep spotify')
    if [[ ! -z "$SPOTSTAT" ]] ; then
        NOWPLAYING=$(pyspctl nowplaying)
        PLAYBACKSTATUS=$(pyspctl status)
        if [[ "$PLAYBACKSTATUS" = "Paused" ]] ; then
               PAUSE="%{F${DISCOLOR}}"
        fi
        echo -e "%{A:pyspctl previous:}%{A2:pyspctl playpause:}%{A3:pyspctl next:}${PAUSE}\uf1bc  $NOWPLAYING%{F${FGCOLOR}}%{A}%{A}%{A}"
    fi
}


while true; do
        echo "      $(title)  %{r} $(spotifystat)    $(volume)    $(clock)      "
	sleep .25
done | /home/seth/.local/bin/lemonbar -d -g "${BARWIDTH}"x"${BARHEIGHT}" -B "${BGCOLOR}" -F "${FGCOLOR}" -U "${ULCOLOR}" -f "$MAINFONT" -f "$BOLDFONT" -f "$ICONFONT" | sh > /dev/null 2>&1
