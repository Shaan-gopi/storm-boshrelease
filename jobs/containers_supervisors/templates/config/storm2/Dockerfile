FROM fab-ci-remote-agent:443/storm1
COPY zookeeper.cfg /home/apcuser/apps/
COPY storm.yaml /home/apcuser/apps/
COPY start_storm.sh /home/apcuser/scripts/
CMD . /home/apcuser/scripts/start_storm.sh
