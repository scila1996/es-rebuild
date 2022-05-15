# syntax=docker/dockerfile:1.3-labs
ARG es_version
FROM bitnami/elasticsearch:${es_version}

USER 0

WORKDIR /build

COPY LicenseVerifier.java .
COPY XPackBuild.java .
COPY build.sh .

RUN <<EOF
chmod +x build.sh
es_version=$APP_VERSION ./build.sh
EOF

RUN rm -rf /build

WORKDIR /
USER 1001
