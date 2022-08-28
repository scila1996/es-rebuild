#!/bin/bash

APP_VERSION="${APP_VERSION:-0.0.0}"

[ "$APP_VERSION" = "0.0.0" ] && echo \$APP_VERSION is not set && exit 1

x_pack="x-pack-core-$APP_VERSION.jar"

f_x_pack_build=$(cat <<'JAVA_FILE'
package org.elasticsearch.xpack.core;

import org.elasticsearch.core.PathUtils;
import org.elasticsearch.core.SuppressForbidden;

import org.elasticsearch.common.io.*;
import java.net.*;
import org.elasticsearch.common.*;
import java.nio.file.*;
import java.io.*;
import java.util.jar.*;

public class XPackBuild {
    public static final XPackBuild CURRENT;
    private String shortHash;
    private String date;
    @SuppressForbidden(reason = "looks up path of xpack.jar directly")
    static Path getElasticsearchCodebase() {
        final URL url = XPackBuild.class.getProtectionDomain().getCodeSource().getLocation();
        try { return PathUtils.get(url.toURI()); }
        catch (URISyntaxException bogus) {
        throw new RuntimeException(bogus); }
    }

    XPackBuild(final String shortHash, final String date) {
        this.shortHash = shortHash;
        this.date = date;
    }

    public String shortHash() {
        return this.shortHash;
    }
    public String date(){
        return this.date;
    }

    static {
        final Path path = getElasticsearchCodebase();
        String shortHash = null;
        String date = null;
        Label_0157: { shortHash = "Unknown"; date = "Unknown";
    }

    CURRENT = new XPackBuild(shortHash, date);
    }
}
JAVA_FILE
)

f_x_pack_license_verify=$(cat <<'JAVA_FILE'
package org.elasticsearch.license;

public class LicenseVerifier {
    public static boolean verifyLicense(final License license, final byte[] encryptedPublicKeyData) {
        return true;
    }

    public static boolean verifyLicense(final License license) {
        return true;
    }
}
JAVA_FILE
)

cat <<<"$f_x_pack_build" > XPackBuild.java
cat <<<"$f_x_pack_license_verify" > LicenseVerifier.java

find /opt/bitnami/elasticsearch -type f \( -name "elasticsearch-$APP_VERSION.jar" -o -name "elasticsearch-core-$APP_VERSION.jar" -o -name "$x_pack" \) 2>/dev/null > files.txt

cat files.txt | xargs -n1 -I {} cp {} .

javac -cp $(cat files.txt | tr '\n' ':') -d . LicenseVerifier.java XPackBuild.java

jar uf "$x_pack" org

cat files.txt | grep "$x_pack" | xargs -n1 cp "$x_pack"
