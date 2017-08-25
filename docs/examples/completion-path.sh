#! /usr/bin/env bash
#
# Determine a dynamic completion path and print it on stdout for capturing
#
# Call with "-h" for installation instructions!

# List of attributes passed by the 'completion_path' method
arglist=( default session hash name directory base_path tied_to_file label )

# Determine target path (adapt this to your needs)
set_target_path() {
    # "target_base" is used to complete a non-empty but relative "target" path
    target_base=$(command cd $(dirname "$base_path")/.. >/dev/null && pwd)"/done"
    month=$(date +'%Y-%m')

    # Only move data downloaded to the default directory
    egrep >/dev/null "^${default%/}/" <<<"${base_path}/" || return

    # Move by label
    test -n "$target" || case $(tr A-Z' ' a-z_ <<<"${label:-NOT_SET}") in
        tv|hdtv)                    target="TV" ;;
        movie*)                     target="Movies/$month" ;;
    esac

    # Move by name patterns
    test -n "$target" || case $(tr A-Z' ' a-z. <<<"${name:-EMPTY}") in
        *hdtv*|*pdtv*)              target="TV" ;;
        *.s[0-9][0-9].*)            target="TV" ;;
        *.s[0-9][0-9]e[0-9][0-9].*) target="TV" ;;
        *pdf|*epub|*ebook*)         target="eBooks/$month" ;;
    esac

    test -z "$target" && is_movie "$name" && target="Movies/$month" || :
} # set_target_path


is_movie() {
    python - "$@" <<'EOF'
import re
import sys

pattern = re.compile(
    r"^(?P<title>.+?)[. ](?P<year>\d{4})"
    r"(?:[._ ](?P<release>UNRATED|REPACK|INTERNAL|PROPER|LIMITED|RERiP))*"
    r"(?:[._ ](?P<format>480p|576p|720p|1080p|1080i|2160p))?"
    r"(?:[._ ](?P<source>BDRip|BRRip|HDRip|DVDRip|DVD[59]?|PAL|NTSC|Web|WebRip|WEB-DL|Blu-ray|BluRay|BD25|BD50))"
    r"(?:[._ ](?P<sound1>MP3|AC3|AAC(?:2.0)?|FLAC(?:2.0)?|DTS(?:-HD)?))?"
    r"(?:[._ ](?P<codec>xvid|divx|avc|x264|h\.?264|hevc|h\.?265))"
    r"(?:[._ ](?P<sound2>MP3|AC3|AAC(?:2.0)?|FLAC(?:2.0)?|DTS(?:-HD)?))?"
    r"(?:[-.](?P<group>.+?))"
    r"(?P<extension>\.avi|\.mkv|\.m4v)?$", re.I
)

title = ' '.join(sys.argv[1:])
sys.exit(not pattern.match(title))
EOF
} # is_movie


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
    ~/rtorrent/scripts/completion-path.sh, \
    (directory.default), (session.path), \
    (d.hash), (d.name), (d.directory), (d.base_path), (d.tied_to_file), \
    (d.custom1)"

method.insert = completion_move_print, simple|private, \
    "print = \"MOVED »\", (argument.0), \"« to »\", (argument.1), «"

method.insert = completion_move, simple|private, \
    "d.directory.set = (argument.1); \
     execute.throw = mkdir, -p, (argument.1); \
     execute.throw = mv, -u, (argument.0), (argument.1); \
     d.save_full_session="

method.insert = completion_move_verbose, simple|private, \
    "completion_move = (argument.0), (argument.1); \
     completion_move_print = (argument.0), (argument.1)"

method.insert = completion_move_handler, simple|private, \
    "branch=\"not=(equal, argument.0=, cat=)\", \
        \"completion_move_verbose = (d.base_path), (argument.0)\""

method.set_key = event.download.finished, move_on_completion, \
    "completion_move_handler = (completion_path)"
EOF
    exit 1
fi


fail() {
    echo ERROR: "$@"
    exit 1
}


# Take arguments
for argname in "${arglist[@]}"; do
    test $# -gt 0 || fail "'$argname' is missing!"
    eval "$argname"'="$1"'
    shift
done
#set | egrep '^[a-z_]+=' >&2

# Determine target path
target=""
set_target_path

# Return result (an empty target prevents moving)
if test -n "$target"; then
    if test "${target:0:1}" = '/'; then
        echo -n "$target"
    else
        echo -n "${target_base%/}/$target"
    fi
fi
