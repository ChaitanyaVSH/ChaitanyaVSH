#!/bin/sh

df -h | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;

do
  echo $output
  usedPercentage=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usedPercentage -ge 60 ]; then
    echo "Running out of space \"$partition ($usedPercentage%)\" on $(hostname) as on $(date)" |
     mail -s "Alert: Almost out of disk space $usedPercentage%" $(whoami)@amazon.com
  fi
done
