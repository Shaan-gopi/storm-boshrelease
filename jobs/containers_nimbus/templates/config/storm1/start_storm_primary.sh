#!/bin/sh
export SCRIPTS_HOME=/home/apcuser/scripts
. /home/apcuser/.profile
. $BUILD_HOME/currentbuild.sh
cd $BUILD_HOME
unzip -o storm_*.zip -d $STORM_HOME
dpkg -i  alceph*_amd64.deb

echo $STORM_HOME|cut -c2-| xargs tar -C / -xvf sdet_conf.tar
echo $TMP_HOME|cut -c2-| xargs tar -C / -xvf sdet_conf.tar
mv /home/apcuser/apps/zookeeper.cfg $STORM_HOME/conf/
mv /home/apcuser/apps/storm.yaml $STORM_HOME/conf/

mkdir $STORM_HOME/logs
## HACK TO FORCE STORM TO USE JUST ONE LOGGER
rm $STORM_HOME/lib/logback-classic-1.1.7.jar
cd $STORM_HOME/bin
./storm nimbus > $STORM_HOME/logs/nimbus.out &
sleep 60s
./storm supervisor > $STORM_HOME/logs/supervisor.out &
sleep 100s
chmod +x *.sh

./storm ui > $STORM_HOME/logs/storm_ui.log &
cd $SCRIPTS_HOME
./start_storm_topologies.sh
tail -f $STORM_HOME/logs/supervisor.out
