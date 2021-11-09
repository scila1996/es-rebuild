#!/bin/bash

es_version="${es_version:-0.0.0}"
[ "$es_version" = "0.0.0" ] && echo \$es_version is not set && exit 1
x_pack="x-pack-core-$es_version.jar"
find /usr/share/elasticsearch -type f \( -name "elasticsearch-$es_version.jar" -o -name "elasticsearch-core-$es_version.jar" -o -name "$x_pack" \) 2>/dev/null > files.txt
cat files.txt | xargs -n1 -I {} cp {} .
javac -cp $(cat files.txt | tr '\n' ':') -d . LicenseVerifier.java XPackBuild.java
jar uf "$x_pack" org
cat files.txt | grep "$x_pack" | xargs -n1 cp "$x_pack"
