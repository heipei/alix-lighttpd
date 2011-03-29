#!/bin/sh
### BEGIN INIT INFO
# Provides:          heipei
# Required-Start:    bootmisc hostname $remote_fs
# Required-Stop:
# Should-Start:      udev
# Default-Start:     S
# Default-Stop:
# Short-Description: Jojo's stuff
# Description:       
### END INIT INFO

PATH=/sbin:/usr/sbin:/bin:/usr/bin
. /lib/init/vars.sh

do_start () {
	#
	# If login delaying is enabled then create the flag file
	# which prevents logins before startup is complete
	#
	echo "Setting IO-Scheduler to deadline"
	echo "deadline" > /sys/block/hda/queue/scheduler
	echo "deadline" > /sys/block/sda/queue/scheduler

	echo "Activating ALIX LEDS"
	echo heartbeat > /sys/class/leds/alix:1/trigger
	echo ide-disk > /sys/class/leds/alix:3/trigger

	echo "Creating /var/log entries"
	mkdir -p /var/log/lighttpd
	mkdir -p /var/log/samba
	touch /var/log/lastlog
	touch /var/log/wtmp
	touch /var/log/btmp
	chgrp utmp /var/log/lastlog
	chmod 0644 /var/log/lastlog
	chmod 0644 /var/log/wtmp
	chmod 0600 /var/log/btmp

	echo "Mounting USB drive"
	sleep 5
	mount /mnt/usbdrive
	
	echo "Starting SAMBA"
	/etc/init.d/samba start

}

case "$1" in
  start|"")
	do_start
	;;
  *)
	echo "Usage: heipei.sh [start|stop]" >&2
	exit 3
	;;
esac

:
