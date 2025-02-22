#!/bin/bash

ELASTICSEARCH_INSTALLATION_DIRECTORY="${ELASTICSEARCH_INSTALLATION_DIRECTORY:-/opt/bitnami/elasticsearch}"
APP_VERSION="${APP_VERSION:-0.0.0}"

[ "${APP_VERSION}" = "0.0.0" ] && echo \$APP_VERSION is not set && exit 1

X_PACK_CORE_FILE="${ELASTICSEARCH_INSTALLATION_DIRECTORY}/modules/x-pack-core/x-pack-core-${APP_VERSION}.jar"

# Download script
curl -o LicenseVerifier.java -s https://raw.githubusercontent.com/elastic/elasticsearch/v${APP_VERSION}/x-pack/plugin/core/src/main/java/org/elasticsearch/license/LicenseVerifier.java
curl -o XPackBuild.java -s https://raw.githubusercontent.com/elastic/elasticsearch/v${APP_VERSION}/x-pack/plugin/core/src/main/java/org/elasticsearch/xpack/core/XPackBuild.java
curl -o License.java -s https://raw.githubusercontent.com/elastic/elasticsearch/v${APP_VERSION}/x-pack/plugin/core/src/main/java/org/elasticsearch/license/License.java

# Edit LicenseVerifier.java
sed -i '/boolean verifyLicense(/{h;s/verifyLicense/verifyLicense2/;x;G}' LicenseVerifier.java
sed -i '/boolean verifyLicense(/ s/$/return true;}/' LicenseVerifier.java

# Edit XPackBuild.java
sed -i 's/path.toString().endsWith(".jar")/false/g' XPackBuild.java

# Edit License.java
sed -i '/void validate()/{h;s/validate/validate2/;x;G}' License.java
sed -i '/void validate()/ s/$/}/' License.java

# Build class file
javac -cp "${ELASTICSEARCH_INSTALLATION_DIRECTORY}/lib/*:${ELASTICSEARCH_INSTALLATION_DIRECTORY}/modules/x-pack-core/*" -d . LicenseVerifier.java
javac -cp "${ELASTICSEARCH_INSTALLATION_DIRECTORY}/lib/*:${ELASTICSEARCH_INSTALLATION_DIRECTORY}/modules/x-pack-core/*" -d . XPackBuild.java
javac -cp "${ELASTICSEARCH_INSTALLATION_DIRECTORY}/lib/*:${ELASTICSEARCH_INSTALLATION_DIRECTORY}/modules/x-pack-core/*" -d . License.java

# Backup x-pack-core file
cp "${X_PACK_CORE_FILE}" "${X_PACK_CORE_FILE}.bak"

# Patch x-pack-core file
jar uf "${X_PACK_CORE_FILE}" org

# Clean-up
rm -rf org
rm -f XPackBuild.java LicenseVerifier.java
rm -f XPackBuild.class LicenseVerifier.class
