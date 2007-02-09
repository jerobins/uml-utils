#!/bin/sh
#
# Script to start-up UML VMs using screen
#
# 2004-04-02 James E. Robinson, III <james@robinsonhouse.com>

if [ "X$1" = "X" -o "X$2" = "X" ]; then
   echo "usage: $0 [host id] [uml id] [clean] [single]"
   echo " clean: start with fresh COW file"
   echo " single: pass single to kernel for single-user mode"
   exit 1
fi

SVR=$1
UML=$2
CLR=$3
SING=$4

echo "Starting UML $UML on host $SVR with mconsole id: uml$UML"

UMLROOT=/root/uml/guest
ROOTFS=$UMLROOT/root_emu_fs
SWAPFS=$UMLROOT/swap_fs

if [ "X$CLR" = "Xclean" ]; then
	echo "New Moo Juice for You"
	if [ -f $ROOTFS-$UML.cow ]; then
	   /bin/rm -f $ROOTFS-$UML.cow
	fi
	if [ -f $SWAPFS-$UML.cow ]; then
	   /bin/rm -f $SWAPFS-$UML.cow
	fi
fi

if [ ! -f $ROOTFS-$UML.cow ]; then
   echo "No root milk -- milking"
   uml_mkcow $ROOTFS-$UML.cow $ROOTFS
fi
if [ ! -f $SWAPFS-$UML.cow ]; then
   echo "No swap milk -- milking"
   uml_mkcow $SWAPFS-$UML.cow $SWAPFS
fi

if [ "X$SING" = "Xsingle" ]; then
   OPTS="single"
else
   OPTS="con=none"
fi

screen -S uml-$SVR-$UML -d -m linux umid=uml$UML mem=64M ubd0=$ROOTFS-$UML.cow ubd1=$SWAPFS-$UML.cow con0=fd:0,fd:1 eth0=tuntap,,FE:FD:10:00:$SVR:$UML,10.0.253.$UML CONFIG_DEV=/dev/ubd2 ubd2=config/config-$SVR-$UML.tar $OPTS
