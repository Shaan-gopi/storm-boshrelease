#!/bin/sh

. /home/apcuser/.profile
. $BUILD_HOME/currentbuild.sh
cd $BUILD_HOME
unzip -o storm_*.zip -d $STORM_HOME
dpkg -i  alceph*_amd64.deb
echo $STORM_HOME|cut -c2-| xargs tar -C / -xvf sdet_conf.tar
## HACK TO FORCE STORM TO USE JUST ONE LOGGER
mv /home/apcuser/apps/zookeeper.cfg $STORM_HOME/conf/
mv /home/apcuser/apps/storm.yaml $STORM_HOME/conf/

rm $STORM_HOME/lib/logback-classic-1.1.7.jar
mkdir -p $STORM_HOME/logs
cd $STORM_HOME/bin
./storm supervisor >> $STORM_HOME/logs/supervisor.out
sleep 100s
tail -f supervisor.out
