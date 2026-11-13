# syntax=docker/dockerfile:1.24

FROM --platform=$BUILDPLATFORM docker.io/library/ubuntu:resolute AS installer

ARG TARGETARCH
ARG BUILDARCH=amd64

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates openssl \
 && if [ "${TARGETARCH}" != "${BUILDARCH}" ]; then \
      dpkg --add-architecture ${TARGETARCH} \
      && sed -i 's|^deb |deb [arch='"${BUILDARCH}"'] |' /etc/apt/sources.list \
      && printf 'Types: deb\nURIs: http://ports.ubuntu.com/ubuntu-ports/\nSuites: jammy jammy-updates jammy-security\nComponents: main restricted universe multiverse\nArchitectures: %s\nSigned-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\n' "${TARGETARCH}" \
         > /etc/apt/sources.list.d/ports-${TARGETARCH}.sources; \
    fi \
 && printf 'deb [arch=%s trusted=yes] https://repo.zextras.tools/repository/ubuntu-devel-jammy jammy main\n' "${TARGETARCH}" \
    > /etc/apt/sources.list.d/zextras.list \
 && apt-get update \
 && mkdir -p /staging /tmp/debs \
 && cd /tmp/debs \
 && apt-get download \
      carbonio-nginx:${TARGETARCH} \
      carbonio-openssl:${TARGETARCH} \
      carbonio-cyrus-sasl:${TARGETARCH} \
      libbrotli1:${TARGETARCH} \
      libcap2:${TARGETARCH} \
      libluajit-5.1-2:${TARGETARCH} \
      libpcre3:${TARGETARCH} \
      zlib1g:${TARGETARCH} \
 && for deb in /tmp/debs/*.deb; do dpkg -x "$deb" /staging; done \
 && rm -rf /tmp/debs /var/lib/apt/lists/* \
 && mkdir -p /staging/usr/local/lib \
 && for dir in /staging/lib /staging/usr/lib; do \
      if [ -d "$dir" ]; then find "$dir" -name '*.so*' -not -path '*/opt/*' -exec cp -P -t /staging/usr/local/lib/ {} +; fi; \
    done \
 && mkdir -p /staging/writable/opt/zextras/conf/nginx/includes \
             /staging/writable/opt/zextras/data/tmp/nginx/client \
             /staging/writable/opt/zextras/data/tmp/nginx/proxy \
             /staging/writable/opt/zextras/data/tmp/nginx/fastcgi \
             /staging/writable/opt/zextras/log \
             /staging/writable/run/carbonio \
 && openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
      -keyout /staging/writable/opt/zextras/conf/nginx.key \
      -out /staging/writable/opt/zextras/conf/nginx.crt \
      -subj "/CN=example.com" \
      -addext "subjectAltName=DNS:example.com,DNS:*.example.com" \
 && mkdir -p /staging/etc \
 && { cat /etc/passwd; echo 'zextras:x:999:999:Carbonio:/opt/zextras:/usr/sbin/nologin'; } > /staging/etc/passwd \
 && { cat /etc/group; echo 'zextras:x:999:'; } > /staging/etc/group

FROM --platform=$TARGETPLATFORM docker.io/library/ubuntu:resolute

COPY --from=installer /staging/etc/passwd /staging/etc/group /etc/
COPY --from=installer /staging/usr/local/lib /usr/local/lib/
COPY --from=installer /staging/opt /opt
COPY --from=installer --chown=999:999 /staging/writable/ /

ENV LD_LIBRARY_PATH=/usr/local/lib

USER 999
STOPSIGNAL SIGQUIT
ENTRYPOINT ["/opt/zextras/common/sbin/nginx", "-g", "daemon off;"]
CMD ["-c", "/opt/zextras/conf/nginx.conf"]
