FROM sonic-sdk

ARG manifest

RUN pip3 install supervisor
RUN pip3 install supervisord-dependent-startup

COPY ["debs/*", "/tmp"]

COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]

RUN dpkg -i /tmp/*.deb

LABEL com.azure.sonic.manifest="$manifest"

RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/ecmp-stats#%syslogtag%/;" /etc/rsyslog.conf

ENTRYPOINT ["/usr/local/bin/supervisord"]