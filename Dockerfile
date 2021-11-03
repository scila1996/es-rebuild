# syntax=docker/dockerfile:1.3-labs
FROM bitnami/elasticsearch:7.14.2-debian-10-r1

USER 0

WORKDIR /build

COPY LicenseVerifier.java .
COPY XPackBuild.java .
COPY build.sh .

RUN <<EOF
chmod +x build.sh
es_version=$(echo $BITNAMI_IMAGE_VERSION | grep -oE '^[^-]+') ./build.sh
EOF

RUN rm -rf /build

WORKDIR /
USER 1001
