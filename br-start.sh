#!/bin/sh
#
# br-start: turn on and configure bridging for UML
#
# 2005-04-02 James E. Robinson, III <james@robinsonhouse.com>

if [ "X$1" = "X" -o "X$2" = "X" ]; then
   echo "usage: $0 [host id] [uml count]"
   exit 1
fi

SVR=$1
UML=$2

brctl addbr br0
brctl setfd br0 0
brctl sethello br0 0
brctl stp br0 off
ifconfig br0 10.0.254.$SVR netmask 255.255.0.0 up

# a few boxes had multiple NICs, instead of figuring out which one was
# configured, i went ahead and promisc'ed them all; you can safely
# ignore the warning messages
for i in 0 1 2 3 4 5; do
   ifconfig eth$i promisc up
   brctl addif br0 eth$i
done

x=0
while [ $x -lt $UML ]; do
   ifconfig tap$x promisc up
   brctl addif br0 tap$x
   x=`expr $x + 1`
done

# to disable bridging, you just need two commands:
# $ ifconfig br0 down
# $ brctl delbr br0

exit 0
