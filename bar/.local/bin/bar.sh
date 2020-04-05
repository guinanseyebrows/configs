#!/bin/bash

MAINFONT="Noto Sans:style=Italic:pixelsize=13"
BOLDFONT="Noto Sans:style=Bold Italic:pixelsize=13"
BARWIDTH=1920
BARHEIGHT=25
FGCOLOR="#222222"
#BGCOLOR="#77e2e2e2"
BGCOLOR="#e2e2e2"
ULCOLOR="#222222"
DISCOLOR="#777777"

clock() {
	TIME=`date +%l:%M`
	echo -e "\uf017 $TIME"
}
title() {
	WINT=`xtitle`
    case "$WINT" in
            *Firefox)
                 WINICON="\uf269"
                 ;;
            *@*:*)
                 WINICON="\uf120"
                 ;;
            Spotify | "Spotify Premium")
                 WINICON="\uf1bc"
                 ;;
            *)
                 WINICON="\uf1e2"
                 ;;
    esac

    #WINICON="\uf1e2"
	echo -e "$WINICON  %{T1}$WINT%{T1}"
}
battery() {
	BATC=`cat /sys/class/power_supply/BAT0/capacity`
	CHRG=`cat /sys/class/power_supply/BAT0/status`
	if [[ $BATC -ge 85 ]]; then
	    BICO="\uf240"
	elif [[ $BATC -ge 60 && $BATC -le 84 ]]; then
	    BICO="\uf241"
	elif [[ $BATC -ge 40 && $BATC -le 59 ]]; then
	    BICO="\uf242"
	elif [[ $BATC -ge 15 && $BATC -le 39 ]]; then
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
	VOL=`amixer get Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p'| uniq`
	if [[ $VOL -ge 65 ]]; then
		VOLICON="\uf028"
	elif [[ $VOL -ge 35 && $VOL -lt 65 ]]; then
		VOLICON="\uf027"
	else
		VOLICON="\uf026"
	fi
	if [[ -n `amixer get Master | grep off` ]]; then
		echo -e "%{F${DISCOLOR}} $VOLICON ${VOL}% %{F#222222}"
	else
		echo -e "%{F#222222} $VOLICON $VOL% "
	fi
}
 
printessid() {
	 ESSID=`iwgetid -r`
	 if [ $ESSID ]; then
		echo -e "\uf1eb  $ESSID"
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
        echo "      $(title)  %{r} $(spotifystat)     $(volume)    $(printessid)      $(battery)      $(clock)      "
	sleep .25
done | lemonbar -d -g "${BARWIDTH}"x"${BARHEIGHT}" -B "${BGCOLOR}" -F "${FGCOLOR}" -U "${ULCOLOR}" -f "$MAINFONT" -f "$BOLDFONT" -f "FontAwesome:pixelsize=15" | sh > /dev/null 2>&1
