#!/bin/sh
#
# Script to generate config tarballs for UML testbed
#
# 2005-04-02 James E. Robinson, III <james@robinsonhouse.com>

UMLDIR=/root/uml/guest
CFGDIR=$UMLDIR/config

if [ "X$1" = "X" -o "X$2" = "X" ]; then
   echo "usage: $0 [uml server number] [number umls to create]"
   echo "   note - max of 99 umls"
   exit 1
fi

SVRNUM=$1
UMLNUM=$2

MAXTAP=`expr 100 + $UMLNUM`

echo "Creating $UMLNUM guest images for server $SVRNUM"
echo "TAP device range: tap1 - tap$UMLNUM"
echo "Address range: 10.0.$SVRNUM.1 to 10.0.$SVRNUM.$UMLNUM"
echo "TAP range: 10.0.$SVRNUM.101 to 10.0.$SVRNUM.$MAXTAP"

cd $CFGDIR

x=0
tap=100
while [ $x -lt $UMLNUM ]; do
   x=`expr $x + 1`
   tap=`expr $tap + 1`
   for i in `find . -name "*.uml" -print`; do
     dname=`dirname $i`
     fname=`basename $i .uml`
     outfile=$dname/$fname
     cat $i | sed "s/UMLNUM/$x/g" | sed "s/SVRNUM/$SVRNUM/g" | sed "s/TAPNUM/$tap/g" > $outfile
     tar --exclude="*.uml" -cf config-$SVRNUM-$x.tar ./etc
   done
done

exit 0
