#!/usr/bin/env sh
#
# set_global_tags.sh <decimal-tagmask>
#
# Use jq to find how many “enabled” outputs there are, then
# for each one: set-focused-tags, focus-output next. After
# N steps you end up back where you started.
#

TAGMASK="$1"
if [ -z "$TAGMASK" ]; then
  echo "Usage: $0 <decimal-tagmask>" >&2
  exit 1
fi

# 1) Use jq to build an array of all outputs where "enabled": true.
#    Then get its length.  (If you don’t have jq installed, install it via your distro’s repo.)
NUM_OUT=$(wlr-randr --json \
  | jq '[ .[] | select(.enabled == true) ] | length')

if [ -z "$NUM_OUT" ] || [ "$NUM_OUT" -le 0 ]; then
  echo "Error: couldn’t detect any enabled outputs" >&2
  exit 2
fi

i=0
while [ "$i" -lt "$NUM_OUT" ]; do
  # On the currently focused output, set its tags to TAGMASK
  riverctl set-focused-tags "$TAGMASK"
  # Move to the next output in the cycle
  riverctl focus-output next
  i=$((i + 1))
done

exit 0

