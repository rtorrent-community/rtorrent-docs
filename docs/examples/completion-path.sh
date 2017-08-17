#! /usr/bin/env bash
#
# Determine a dynamic completion path and print it on stdout for capturing
#
# Call with "-h" for installation instructions!

# Determine target path (adapt this to your needs)
set_target_path() {
    test -n "$target" || case "$label" in
        Movie*) target="movies/$month" ;;
        TV) target="tv/$month" ;;
    esac
    test -n "$target" || case $(tr A-Z' ' a-z. <<<"$name") in
        *rip.x264*) target="movies/$month" ;;
        *hdtv*) target="tv/$month" ;;
    esac
} # set_target_path

# Print installation instructions when called with "-h"
if test "$1" = "-h" -o "$1" = "--help"; then
    echo "$(basename $0) – Determine a dynamic rTorrent completion path"
    echo
    echo "To install, call these commands:"
    cat <<EOF

# Change "~/rtorrent" to your instance's directory
# (and do the same in the "completion_path" method below)
mkdir -p ~/rtorrent/scripts
cp -np $(readlink -f $0) \$_
chmod a+x \$_/$(basename $0)
EOF
    echo
    echo "Also add this to your rtorrent.rc:"
    cat <<'EOF'

# Completion moving

method.insert = completion_path, simple|private, "execute.capture = \
    ~/rtorrent/scripts/completion-path.sh,\
    (directory.default), (session.path),\
    (d.hash), (d.name), (d.directory), (d.tied_to_file),\
    (d.custom1)"

method.insert = completion_move_print, simple|private, \
    "print = \"MOVED '\", (argument.0), \"' to '\", (argument.1), \"'\""

method.insert = completion_move, simple|private, \
    "completion_move_print=$argument.0=,$argument.1=;\
     d.directory.set=$argument.1=;\
     execute.throw=mkdir,-p,$argument.1=;\
     execute.throw=mv,-u,$argument.0=,$argument.1=;\
     d.save_full_session="

method.insert = completion_handler, simple|private, \
    "branch=\"not=(equal, argument.0=, cat=)\", \
        \"completion_move_print = (d.base_path), (argument.0)\""

method.set_key = event.download.finished, move_on_completion, \
    "completion_handler = (completion_path)"
EOF
    exit 1
fi

arg() {
    eval "$2"'="${1:?missing '"$2"'}"'
}

# Take arguments
arg "$1" default; shift
arg "$1" session; shift
arg "$1" hash; shift
arg "$1" name; shift
arg "$1" path; shift
arg "$1" tied; shift
arg "$1" label; shift
#set | egrep '^[a-z]+=' >&2

# Determine target path
target_base=$(dirname $(dirname "$path"))"/done"
month=$(date +'%Y-%m')
target=""
set_target_path

# Return result (an empty target prevents moving)
test -z "$target" || echo -n "$target_base${target:+/}$target"
