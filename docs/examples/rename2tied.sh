#! /usr/bin/env bash
#
# Rename item based on its tied-to file name (BEFORE it is started!)
#
# Bind to "R"ename as follows:
#
# method.insert = pyro._rename2tied, private|simple, \
#     "execute.nothrow = ~/rtorrent/scripts/rename2tied.sh, \
#      (d.hash), (d.name), (d.directory), (d.tied_to_file), (d.is_multi_file)"
#
# pyro.bind_key = rename2tied, R, "pyro._rename2tied="

hash="${1:?hash is missing}"
name="${2:?name is missing}"
path="${3}"
tied="${4}"
multi="${5:?is_multi_file is missing}"

fail() {
    msg="$(echo -n "$@")"
    rtxmlrpc print '' "ERROR: $msg [$name]"
    exit 1
}

test -n "$path" || fail "Empty directory"
test -n "$tied" || fail "Empty tied file"
test ! -e "$path/$name" || fail "Cannot rename an item with existing data"

tracker="$(rtcontrol --from-view $hash // -qo alias)"

# Build new name
new_name="${tied##*/}"  # Reduce path to basename
new_name="${new_name// /.}"  # Replace spaces with dots
new_name="${new_name%.torrent}"  # Remove extension
while test "$new_name" != "${new_name%[.0-9]}"; do
    new_name="${new_name%[.0-9]}"  # Remove trailing IDs etc.
done

# Remove bad directory name (that we want to replace) from multi-file item
new_full_path="${path%/}"
if test "$multi" -eq 1; then
    new_full_path="${new_full_path%/*}"
fi

# Remove common extensions
for ext in mkv mp4 m4v avi; do
    new_name="${new_name%.$ext}"
    new_name="${new_name%.$(tr a-z A-Z <<<$ext)}"
done

# Change source tags to encode tags (when item has an encoded media type)
if egrep -i >/dev/null '\.[xh]\.?264' <<<"$new_name"; then
    new_name=$(sed -re 's~\.DVD\.~.DVDRip.~' -e 's~\.Blu-ray\.~.BDRip.~' <<<"$new_name")
fi

# Add tracker as group if none is there
if ! egrep >/dev/null '.-[a-zA-Z0-9]+$' <<<"$new_name"; then
    new_name="${new_name}-$tracker"
fi

# Rename / relocate item
new_full_path="${new_full_path%/}/$new_name"
rtxmlrpc d.directory_base.set $hash "$new_full_path"
rtxmlrpc d.custom.set $hash displayname "$new_name"

# End of rename2tied.sh
