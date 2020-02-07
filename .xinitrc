
sh .screenlayout/.screenrc.sh
setxkbmap us altgr-intl
xmodmap ~/.xmodmap
xrdb -merge .Xresources
xcape -e 'Control_L=Super_L|C;Super_L=Super_L|X;Alt_L=Super_L|Z;Hyper_L=Hyper_L|T;Shift_R=Caps_Lock'
xcape -e "ISO_Level3_Shift=Super_L|G"
exec dbus-launch ~/stumpwm/stumpwm
#exec ~/stumpwm/stumpwm
#udiskie &
