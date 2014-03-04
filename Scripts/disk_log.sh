#!/bin/bash
# Private Eyes log automation part 1
# Created by Ben Bass
vers="zabbix_drivechck-0.1"
# Copyright 2014 Technology Revealed. All rights reserved.
# Writing out the names of the mounted volumes and mount points to a file.  When there is a change - echo the disk# and name to std out.  Log the new listing.

log_when=$(date +%Y-%m-%d)

# Set log files for stdout & stderror
#log="/Library/Logs/com.trmacs/pi/current/"$log_when"-drive.log"
#err_log="/Library/Logs/com.trmacs/pi/current/"$log_when"-drive.error.log"

# exec 1 captures stdtout and exec 2 captures stderr and we are appending to log files.
#exec 1>> "${log}" 
#exec 2>> "${err_log}"

when="$(date +"%A %B %e, %G at %I:%M %p")"

# Space used/Available on all attached drives.
disk_usage_raw="$(df -Hla)"
disk_name=$(echo "$disk_usage_raw" | awk -v OFS="\t" '{print $4"/"$2" free", "("$5" used)"}')


#-------------------------------------------------------------------------------------------------
# Stiching the name of each drive with the info from df.  
echo "-------------------------"
echo "Disk Usage Summary"
echo ""
#echo -e "Volume Name"'\t''\t''\t'"Avail/Total"'\t'"Percent Used"
echo "$disk_usage_raw" | tail -n +2 | awk '{print $1}' | while read DISK_ID
do
	VOL_NAME="$(diskutil info $DISK_ID | grep 'Volume Name' | cut -d : -f2 | sed 's/              //')"
#	PARTIAL=$(echo "$disk_usage_raw" | grep $DISK_ID | awk -v OFS="\t" '{print $4"/"$2, "("$5" used)"}')
	
#	if [ "${#VOL_NAME}" -ge 18 ]; then
			echo -e "$VOL_NAME"
			#'\t'"$PARTIAL"
#	elif [ "${#VOL_NAME}" -ge 15 ]; then
#			echo -e "$VOL_NAME"'\t''\t'"$PARTIAL"			
#	elif [ "${#VOL_NAME}" -ge 8 ]; then
#			echo -e "$VOL_NAME"'\t''\t''\t'"$PARTIAL"
#else
#	echo -e "$VOL_NAME"'\t''\t''\t''\t'"$PARTIAL"
#	fi
done
echo ""

exit 0