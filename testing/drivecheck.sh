#!/bin/bash
# Private Eyes log automation part 1
# Created by Ben Bass
vers="drivecheck-0.6.9"
# Copyright 2012 Technology Revealed. All rights reserved.
# Checks the name and status of the Apple Software RAID and SMART status..
# This works for 1, 2 or 4 drive installations.
# 0.6.3 - Trying to get SN # of drives not installed internally, and get bay location for those internal drives. (primarily for Mac Mini's)
# 0.6.6 - version printing in reporting.  Added logic to check to see if the "bay name" was null, and if so to print the sn of the drive instead.
# 0.6.7 - fix in device name in single drive setup.
# 0.6.8 - changed vol name to cut-d not cut -c.  added If statement for formatting long drive names.
# 0.6.9 - cleaned up spacing in disk usage.  Still need to see what can do when the size is less than 7 chars long ($5) in Partial.

log_when=$(date +%Y-%m-%d)

# Set log files for stdout & stderror
log="/Library/Logs/com.trmacs/pi/current/"$log_when"-drive.log"
err_log="/Library/Logs/com.trmacs/pi/current/"$log_when"-drive.error.log"

# exec 1 captures stdtout and exec 2 captures stderr and we are appending to log files.
exec 1>> "${log}" 
exec 2>> "${err_log}"

when="$(date +"%A %B %e, %G at %I:%M %p")"

# Set the host name for easy identification.
host_raw="$(scutil --get HostName)"

if [ -z "$host_raw" ]; then
	host_name="$(scutil --get ComputerName)"
else	
	host_name="$host_raw"
fi

sw_smart_check_raw="$(system_profiler SPSerialATADataType)"
sw_disk_raw="$(diskutil appleRAID list)"
sw_raid_count=$(echo "$sw_disk_raw" | grep -c "Name:")
sw_smart_count=$(echo "$sw_smart_check_raw" | grep -c "S.M.A.R.T")

# Space used/Available on all attached drives.
disk_usage_raw="$(df -Hla)"
disk_name=$(echo "$disk_usage_raw" | awk -v OFS="\t" '{print $4"/"$2" free", "("$5" used)"}')


#-------------------------------------------------------------------------------------------------

echo ""
echo "-------------------------"
echo "Hard drive and Raid Status of "$host_name" on "$when"." 
echo ""$vers""
echo ""
echo "There are "$sw_raid_count" Apple RAID's and "$sw_smart_count" drives installed on "$host_name"."
echo ""

if [ "$sw_smart_count" == 1 ]; then
	sw_smart_status_1=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3}' | head -1)
	sw_smart_dev_name_1=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | awk '{print $1}' | tail -2 | head -1)  
	echo "The SMART status of Device "$sw_smart_dev_name_1" on "$host_name" is currently "$sw_smart_status_1"."
fi
if [ "$sw_raid_count" == 1 ]; then
	sw_raid_status=$(echo "$sw_disk_raw" | grep "Status:" | awk '{print $2}')
	sw_raid_name=$(echo "$sw_disk_raw" | grep "Name:" | awk '{print $2}')
	echo ""
	echo "The Apple Software RAID "$sw_raid_name" on "$host_name" is currently "$sw_raid_status"."
fi

if [ "$sw_raid_count" == 2 ]; then
	sw_raid_status_1=$(echo "$sw_disk_raw" | grep "Status:" | awk '{print $2}' | head -1)
	sw_raid_status_2=$(echo "$sw_disk_raw" | grep "Status:" | awk '{print $2}' | tail -1)
	sw_raid_name_1=$(echo "$sw_disk_raw" | grep "Name:" | awk '{print $2}' | head -1)
	sw_raid_name_2=$(echo "$sw_disk_raw" | grep "Name:" | awk '{print $2}' | tail -1)

	echo ""
	echo "The Software RAID "$sw_raid_name_1" on "$host_name" is currently "$sw_raid_status_1"."
	echo "The Software RAID "$sw_raid_name_2" on "$host_name" is currently "$sw_raid_status_2"."
fi	

if [ "$sw_smart_count" == 2 ]; then
	sw_smart_status_1=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3}' | head -1)
	sw_smart_status_2=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3}' | tail -1)
	sw_smart_dev_name_1=$(echo "$sw_smart_check_raw" | grep "Bay Name:" | cut -d : -f 2 | awk '{print $1}' | head -1) 
	sw_smart_dev_name_2=$(echo "$sw_smart_check_raw" | grep "Bay Name:" | cut -d : -f 2 | awk '{print $1}' | tail -1) 

	if [ -z "$sw_smart_dev_name_1" ]; then
		sw_smart_dev_name_1=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | awk '{print $1}' | head -1) 
		sw_smart_dev_name_2=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | awk '{print $1}' | tail -1) 
	fi

	echo ""
	echo "The SMART status of Device "$sw_smart_dev_name_1" on "$host_name" is currently "$sw_smart_status_1"."
	echo "The SMART status of Device "$sw_smart_dev_name_2" on "$host_name" is currently "$sw_smart_status_2"."
fi	

if [ "$sw_smart_count" == 4 ]; then
	sw_smart_status_1=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3}' | head -1)
	sw_smart_status_2=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3}' | head -2 | tail -1)
	sw_smart_status_3=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3}' | tail -2 | head -1)
	sw_smart_status_4=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3}' | tail -1)

	sw_smart_dev_name_1=$(echo "$sw_smart_check_raw" | grep "Bay Name:" | cut -d : -f 2 | awk '{print $1}' | head -1) 
	sw_smart_dev_name_2=$(echo "$sw_smart_check_raw" | grep "Bay Name:" | cut -d : -f 2 | awk '{print $1}' | tail -1) 
	sw_smart_dev_name_3=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | awk '{print $1}' | tail -2 | head -1) 
	sw_smart_dev_name_4=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | awk '{print $1}' | tail -1) 


	if [ -z "$sw_smart_dev_name_1" ]; then
		sw_smart_dev_name_1=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | awk '{print $1}' | head -1) 
		sw_smart_dev_name_2=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | awk '{print $1}' | head -2 | tail -1) 
	fi

	echo ""
	echo "The SMART status of Device "$sw_smart_dev_name_1" on "$host_name" is currently "$sw_smart_status_1"."
	echo "The SMART status of Device "$sw_smart_dev_name_2" on "$host_name" is currently "$sw_smart_status_2"."
	echo "The SMART status of Device "$sw_smart_dev_name_3" on "$host_name" is currently "$sw_smart_status_3"."
	echo "The SMART status of Device "$sw_smart_dev_name_4" on "$host_name" is currently "$sw_smart_status_4"."


fi

echo " "
#
# Stiching the name of each drive with the info from df.  
echo "-------------------------"
echo "Disk Usage Summary"
echo ""
echo -e "Volume Name"'\t''\t''\t'"Avail/Total"'\t'"Percent Used"
echo "$disk_usage_raw" | tail -n +2 | awk '{print $1}' | while read DISK_ID
do
	VOL_NAME="$(diskutil info $DISK_ID | grep 'Volume Name' | cut -d : -f2 | sed 's/              //')"
	PARTIAL=$(echo "$disk_usage_raw" | grep $DISK_ID | awk -v OFS="\t" '{print $4"/"$2, "("$5" used)"}')
	#vol_name_ct="$(echo "$VOL_NAME" | wc -m | awk '{print $1}')"
	
	if [ "${#VOL_NAME}" -ge 18 ]; then
			echo -e "$VOL_NAME"'\t'"$PARTIAL"
	elif [ "${#VOL_NAME}" -ge 15 ]; then
			echo -e "$VOL_NAME"'\t''\t'"$PARTIAL"			
	elif [ "${#VOL_NAME}" -ge 8 ]; then
			echo -e "$VOL_NAME"'\t''\t''\t'"$PARTIAL"
else
	echo -e "$VOL_NAME"'\t''\t''\t''\t'"$PARTIAL"
	fi
done
echo ""
echo "Data collected on "$when"."
echo ""

exit 0