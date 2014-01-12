#!/bin/sh
# Create a directory for this backup.
# Its name depends on the date and time so backups can't overwrite
# each other, unless they're executed in the same minute.
DATE=`/bin/date +%Y%m%d%H%M`
mkdir /var/backup/$DATE
# Backup the Apache logs.
mkdir /var/backup/$DATE/apache-logs
for f in /var/log/httpd/*;
do
  cp -fr "$f" --target-directory /var/backup/$DATE/apache-logs
done
# Backup kermit's home directory
mkdir /var/backup/$DATE/kermit-home
for f in /home/kermit/*;
do
  cp -fr "$f" --target-directory /var/backup/$DATE/kermit-home
done
