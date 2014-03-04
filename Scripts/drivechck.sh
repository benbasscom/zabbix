#!/bin/bash
# Created by Ben Bass
# Copyright 2012 Technology Revealed. All rights reserved.
# TR Daily output for PInotify
vers="zabbix_drivechck-0.1"

#maybe use diff?
vers_chck_raw="$(grep -hR 'vers=' /Users/benbass/Code\ Repositories/Git\ for\ Mac\ Repos/benbasscom/zabbix/Scripts/dskchck.log)"
vers_chck="$(echo "$vers_chck_raw" | grep -v 'grep' | cut -d = -f2 | sed s/\"//g)"

echo "$vers_chck"

exit 0