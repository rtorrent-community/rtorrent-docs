#! /bin/bash
#
# rTorrent startup script
#
umask 0027
cd $(dirname "$0")

# Check for running process
export RT_SOCKET=$PWD/.scgi_local
test -S $RT_SOCKET && lsof $RT_SOCKET >/dev/null \
    && { echo "rTorrent already running"; exit 1; }
test ! -e $RT_SOCKET || rm $RT_SOCKET

# Clean up after rTorrent ends
_at_exit() {
    stty sane
    test ! -e $RT_SOCKET || rm $RT_SOCKET
}
trap _at_exit INT TERM EXIT

# Start rTorrent (optionally with configuration loaded
# from the directory this script is stored in)
rtorrent -D -I  # -n -o import=$PWD/rtorrent.rc
