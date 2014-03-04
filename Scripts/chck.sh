#!/bin/bash
# Checks the WAN IP.
vers="wan_chck-0.4"
# reads the previous WAN IP from file, then compares to current WAN IP.
# if the wan_chck_ip.log does not exist, create it.
# logs everything to files.


#log="/Library/Logs/com.example/wan_chck.log"
#err_log="/Library/Logs/com.example/wan_chck-err.log"
#exec 1>> "${log}" 
#exec 2>> "${err_log}"

log_when=$(date +%Y-%m-%d-%s)
when=$(date '+%m/%d/%Y %H:%M')
disk_usage_raw="$(df -Hla)"
disk_name=$(echo "$disk_usage_raw" | awk -v OFS="\t" '{print $4"/"$2" free", "("$5" used)"}')

echo "$disk_usage_raw" | tail -n +2 | awk '{print $1}' | while read DISK_ID
do
	VOL_NAME="$(diskutil info $DISK_ID | grep 'Volume Name' | cut -d : -f2 | sed 's/              //')"
		echo -e "$VOL_NAME" >> "/Users/benbass/Desktop/zabbix/dskchck.$log_when.log"
done

difers="$(diff  --suppress-common-lines -i -w -b -B "/Users/benbass/Desktop/zabbix/dskchck.$log_when.log" "/Users/benbass/Desktop/zabbix/dskchck.log")"

#mounted_vols="$(curl -s www.icanhazip.com | awk '{print $1}')"
#prevmounted_vols="$(tail -1 /Library/Logs/com.example/wan_chck_ip.log)"

#if [[ $wan_ip == $prev_wan_ip ]]; then
#	echo "WAN IP has not changed, exiting."
#	echo $wan_ip >> /Library/Logs/com.example/wan_chck_ip.log
#else
#	echo "WAN IP has changed, now do something"
#	echo "The new external IP address is now "$win_ip" | mail -s "E-mail Subject" "e-mail recipient"
#	echo $wan_ip >> /Library/Logs/com.example/wan_chck_ip.log
#fi
#

cat "/Users/benbass/Desktop/zabbix/dskchck.$log_when.log" > "/Users/benbass/Desktop/zabbix/dskchck.log"

rm "/Users/benbass/Desktop/zabbix/dskchck.$log_when.log"

echo "$difers" | tail -n +2 | cut -d \< -f2 | sed 's/ //'

exit 0