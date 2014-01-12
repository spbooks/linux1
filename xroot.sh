#!/bin/sh

if [ $# -lt 1 ]
then echo "usage: `basename $0` command" >&2
      exit 2
fi
su - -c "exec env DISPLAY='$DISPLAY' \
    XAUTHORITY='${XAUTHORITY-$HOME/.Xauthority}' \
    "'"$SHELL"'" -c '$*'"
