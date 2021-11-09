# syntax=docker/dockerfile:1.3.1-labs
ARG es_version
FROM docker.elastic.co/elasticsearch/elasticsearch:${es_version}
ARG es_version

WORKDIR /build

COPY LicenseVerifier.java .
COPY XPackBuild.java .
COPY build.sh .

ENV es_version=$es_version

RUN <<EOF
chmod +x build.sh
./build.sh
EOF

RUN rm -rf /build

WORKDIR /usr/share/elasticsearch
