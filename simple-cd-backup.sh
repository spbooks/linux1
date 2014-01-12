#!/bin/bash
# Back up files to CD, simply.
BACKUPDIR="$HOME/.simple-cd-backup/FilesToBackUp"
ISO=/tmp/CD-Backup-$(date -Iseconds).iso
DISCNAME="Backup data, $(date +%c)"

if [ ! -f /proc/sys/dev/cdrom/info ]; then
  zenity --title "Simple CD Backup" --error --error-text \
      "Couldn't find a CD burner."
  exit
fi

BURNERINDEX=$(grep "Can write CD-R:" /proc/sys/dev/cdrom/info | \
    python -c "import sys; s=sys.stdin.readline().split(); \
    print s.count('1') and s.index('1')-1")

if [ $BURNERINDEX == '0' ]; then
  zenity --title "Simple CD Backup" --error --error-text \
      "Couldn't find a CD burner."
  exit
fi

CDDEVICE=$(grep "drive name:" /proc/sys/dev/cdrom/info | \
    python -c "import sys; s=sys.stdin.readline().split(); \
    print s[$BURNERINDEX]")

mkdir -p "$BACKUPDIR" >/dev/null 2>&1
nautilus --no-desktop --browser \
    "$HOME/.simple-cd-backup/FilesToBackUp"

zenity --title "Simple CD Backup" --question --question-text \
    "Burn files linked in the directory?"
if [ $? == 1 ]; then exit; fi

mkisofs -f -l -o $ISO -A "$DISCNAME" "$BACKUPDIR" | \
    zenity --progress-text="Creating backup" \
    --title "Simple CD Backup" --progress --pulsate .auto-close

cdrecord -v speed=4 dev=/dev/$CDDEVICE $ISO | \
    zenity --progress-text="Burning CD" \
    --title "Simple CD Backup" --progress --pulsate .auto-close

rm $ISO

zenity --info --infotext "Backup burned to CD."
