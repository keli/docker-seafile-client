FROM debian:stable-slim

RUN apt-get update && apt-get install -y lsb-release gnupg wget curl && \
    wget https://linux-clients.seafile.com/seafile.asc -O /usr/share/keyrings/seafile-keyring.asc && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/seafile-keyring.asc] https://linux-clients.seafile.com/seafile-deb/$(lsb_release -cs)/ stable main" | tee /etc/apt/sources.list.d/seafile.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y seafile-cli procps grep && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

WORKDIR /seafile-client

COPY start.sh /seafile-client/start.sh

RUN chmod +x /seafile-client/start.sh && \
    useradd -U -d /seafile-client -s /bin/bash seafile && \
    usermod -G users seafile && \
    chown seafile:seafile -R /seafile-client && \
    su - seafile -c "seaf-cli init -d /seafile-client"

CMD ["./start.sh"]
