# ECMP Stats App
SONiC App Extension to display ECMP statistics

## Build Instructions:

### Prerequisites

You need to have ```j2cli``` and ```docker``` installed.

Build SONiC SDK docker images using sonic-buildimage repository:

```
$ git clone https://github.com/azure/sonic-buildimage
$ cd sonic-buildimage
$ make init
$ make configure PLATFORM=generic
$ make target/sonic-sdk.gz target/sonic-sdk-buildenv.gz
```

Load into docker:

```
$ docker load < target/sonic-sdk.gz
$ docker load < target/sonic-sdk-buildenv.gz
```

## Build

Move the debs that need to be installed on the image under debs/ folder. swss_1.0.0_amd64.deb is mandatory

To build SONiC Package:

```
$ make
```

In case you want to override version pass it as parameter to make:

```
$ make VERSION=1.0.0
```

To save as a tarball:
```
$ make build
$ ls -l docker-ecmp-stats.gz
```

## Install on the SONiC Image:

```
$ sonic-package-manager install --from-tarball docker-ecmp-stats.gz
$ config feature state ecmp-stats enabled
```

```
$ docker exec -it ecmp-stats bash
$ ps -aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  2.1  0.1  29992 23720 pts/0    Ss+  22:40   0:00 /usr/bin/python3 /usr/local/bin/supervisord
root          12  0.0  0.0 223808  3556 pts/0    Sl   22:40   0:00 /usr/sbin/rsyslogd -n -iNONE
root          16  0.1  0.1 335404 19868 pts/0    Sl   22:40   0:00 /usr/bin/ecmp_app_orch
root          31  0.1  0.0   3868  3336 pts/1    Ss   22:40   0:00 bash
root          39  0.0  0.0   7640  2652 pts/1    R+   22:41   0:00 ps -aux

$ show logging | grep ecmp-stats
Nov  4 22:40:38.793265 mts-sonic-dut DEBUG container: container_wait: ecmp-stats: set_owner:local ct_owner:none state:none id:ecmp-stats pend=0
Nov  4 22:40:41.051212 mts-sonic-dut INFO ecmp-stats#rsyslogd:  [origin software="rsyslogd" swVersion="8.1901.0" x-pid="12" x-info="https://www.rsyslog.com"] start
Nov  4 22:40:41.052450 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 21:56:35,286 INFO stopped: rsyslogd (exit status 0)
Nov  4 22:40:41.052450 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:38,601 INFO Included extra file "/etc/supervisor/conf.d/supervisord.conf" during parsing
Nov  4 22:40:41.052450 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:38,601 INFO Set uid to user 0 succeeded
Nov  4 22:40:41.052450 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:38,613 INFO RPC interface 'supervisor' initialized
Nov  4 22:40:41.052450 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:38,613 CRIT Server 'unix_http_server' running without any HTTP authentication checking
Nov  4 22:40:41.052450 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:38,614 INFO supervisord started with pid 1
Nov  4 22:40:41.052498 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:39,617 INFO spawned: 'dependent-startup' with pid 9
Nov  4 22:40:41.052498 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:41,001 INFO success: dependent-startup entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
Nov  4 22:40:41.052511 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:41,014 INFO spawned: 'rsyslogd' with pid 12
Nov  4 22:40:41.057690 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:41,053 INFO spawned: 'ecmpstatsorch' with pid 16
Nov  4 22:40:41.121970 mts-sonic-dut NOTICE ecmp-stats#ecmp_app_orch: :- main: --- Starting ECMP Application Orchestration Agent ---
Nov  4 22:40:41.122537 mts-sonic-dut NOTICE ecmp-stats#ecmp_app_orch: :- initialize: acting as a sairedis CLIENT
Nov  4 22:40:41.122951 mts-sonic-dut NOTICE ecmp-stats#ecmp_app_orch: :- loadFromFile: no client config specified, will load default
Nov  4 22:40:41.128151 mts-sonic-dut NOTICE ecmp-stats#ecmp_app_orch: :- ZeroMQChannel: opening zmq main endpoint: ipc:///var/run/redis/saiServer
Nov  4 22:40:41.129235 mts-sonic-dut NOTICE ecmp-stats#ecmp_app_orch: :- ZeroMQChannel: opening zmq ntf endpoint: ipc:///var/run/redis/saiServerNtf
Nov  4 22:40:41.129697 mts-sonic-dut NOTICE ecmp-stats#ecmp_app_orch: :- ZeroMQChannel: creating notification thread
Nov  4 22:40:41.130201 mts-sonic-dut NOTICE ecmp-stats#ecmp_app_orch: :- initialize: init client/server sai: SAI_STATUS_SUCCESS
Nov  4 22:40:41.130516 mts-sonic-dut NOTICE ecmp-stats#ecmp_app_orch: :- notificationThreadFunction: start listening for notifications
Nov  4 22:40:41.130943 mts-sonic-dut NOTICE ecmp-stats#ecmp_app_orch: :- isPortInitDone: PORT_INIT_DONE : 1 0
Nov  4 22:40:41.132254 mts-sonic-dut NOTICE ecmp-stats#ecmp_app_orch: :- initSwitchId: Switch_id : oid:0x21000000000000
Nov  4 22:40:42.118504 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:42,116 INFO success: rsyslogd entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
Nov  4 22:40:42.118504 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:42,117 INFO success: ecmpstatsorch entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
Nov  4 22:40:43.217144 mts-sonic-dut INFO ecmp-stats#supervisord 2022-11-04 22:40:43,216 INFO exited: dependent-startup (exit status 0; expected)
```

Note: ecmp_stat script can be used to view the stats collected by ecmpstatsorch



