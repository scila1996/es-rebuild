#!/bin/bash

APP_VERSION="${APP_VERSION:-0.0.0}"

[ "$APP_VERSION" = "0.0.0" ] && echo \$APP_VERSION is not set && exit 1

x_pack="x-pack-core-$APP_VERSION.jar"

cd /opt/bitnami/elasticsearch/tmp

curl -o LicenseVerifier.java -s https://raw.githubusercontent.com/elastic/elasticsearch/v${APP_VERSION}/x-pack/plugin/core/src/main/java/org/elasticsearch/license/LicenseVerifier.java
curl -o XPackBuild.java -s https://raw.githubusercontent.com/elastic/elasticsearch/v${APP_VERSION}/x-pack/plugin/core/src/main/java/org/elasticsearch/xpack/core/XPackBuild.java

# Edit LicenseVerifier.java
sed -i '/boolean verifyLicense(/{h;s/verifyLicense/verifyLicense2/;x;G}' LicenseVerifier.java
sed -i '/boolean verifyLicense(/ s/$/return true;}/' LicenseVerifier.java

# Edit XPackBuild.java
sed -i 's/path.toString().endsWith(".jar")/false/g' XPackBuild.java

find /opt/bitnami/elasticsearch -type f \( -name "elasticsearch-$APP_VERSION.jar" -o -name "elasticsearch-core-$APP_VERSION.jar" -o -name "$x_pack" \) 2>/dev/null >files.txt

cat files.txt | grep "${x_pack}$" | xargs -n1 -I {} cp {} .

javac -cp $(cat files.txt | tr '\n' ':') -d . LicenseVerifier.java XPackBuild.java

jar uf "$x_pack" org

cat files.txt | grep "${x_pack}$" | xargs -n1 cp "$x_pack"

rm -rf org XPackBuild.java LicenseVerifier.java files.txt "$x_pack"
