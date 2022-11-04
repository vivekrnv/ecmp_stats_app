FROM sonic-sdk

ARG manifest

RUN pip3 install supervisor

COPY ["debs/*", "/tmp"]

COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]

RUN dpkg -i /tmp/*.deb

LABEL com.azure.sonic.manifest="$manifest"

ENTRYPOINT ["/usr/local/bin/supervisord"]