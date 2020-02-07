#!/bin/sh
#
# this script copies the torrent file passed as arguments to the directory
# watch_dir where rtorrent watches for new torrents
#
# to be used by your browser i.e. point your browser to rtorrent.sh and not 
# toward rtorrent !

# ~ does not seem to work today. WHY ?
if [ -z "$HOME" ] ;then
    HOME="/home/`whoami`"
fi

# exec >>$HOME/rtorrentsh.log 2>&1

if [ -z "$1" ] ;then
    exit 1
fi

src="$1"
if [ ! -f "$src" ] ;then
# opera passes the filename in latin1 encoding but my filesystem is in utf8
    src=`echo $1|iconv -f latin1 -t utf8`

    if [ ! -f "$src" ] ; then
        echo "rtorrent.sh: $1 file not found" >&2
        exit 1
    fi
fi

# your watch directory defined in .rtorrent.rc
watch_dir="$HOME/.watch"

cp "$src" "$watch_dir"

unset watch_dir torrent src
