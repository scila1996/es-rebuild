#!/bin/bash

es_version="${es_version:-0.0.0}"

[ "$es_version" = "0.0.0" ] && echo \$es_version is not set && exit 1

x_pack="x-pack-core-$es_version.jar"

#f_x_pack_build="cGFja2FnZSBvcmcuZWxhc3RpY3NlYXJjaC54cGFjay5jb3JlOwoKaW1wb3J0IG9yZy5lbGFzdGljc2VhcmNoLmNvcmUuUGF0aFV0aWxzOwppbXBvcnQgb3JnLmVsYXN0aWNzZWFyY2guY29yZS5TdXBwcmVzc0ZvcmJpZGRlbjsKCmltcG9ydCBvcmcuZWxhc3RpY3NlYXJjaC5jb21tb24uaW8uKjsKaW1wb3J0IGphdmEubmV0Lio7CmltcG9ydCBvcmcuZWxhc3RpY3NlYXJjaC5jb21tb24uKjsKaW1wb3J0IGphdmEubmlvLmZpbGUuKjsKaW1wb3J0IGphdmEuaW8uKjsKaW1wb3J0IGphdmEudXRpbC5qYXIuKjsKCnB1YmxpYyBjbGFzcyBYUGFja0J1aWxkIHsKICAgIHB1YmxpYyBzdGF0aWMgZmluYWwgWFBhY2tCdWlsZCBDVVJSRU5UOwogICAgcHJpdmF0ZSBTdHJpbmcgc2hvcnRIYXNoOwogICAgcHJpdmF0ZSBTdHJpbmcgZGF0ZTsKICAgIEBTdXBwcmVzc0ZvcmJpZGRlbihyZWFzb24gPSAibG9va3MgdXAgcGF0aCBvZiB4cGFjay5qYXIgZGlyZWN0bHkiKQogICAgc3RhdGljIFBhdGggZ2V0RWxhc3RpY3NlYXJjaENvZGViYXNlKCkgewogICAgICAgIGZpbmFsIFVSTCB1cmwgPSBYUGFja0J1aWxkLmNsYXNzLmdldFByb3RlY3Rpb25Eb21haW4oKS5nZXRDb2RlU291cmNlKCkuZ2V0TG9jYXRpb24oKTsKICAgICAgICB0cnkgeyByZXR1cm4gUGF0aFV0aWxzLmdldCh1cmwudG9VUkkoKSk7IH0KICAgICAgICBjYXRjaCAoVVJJU3ludGF4RXhjZXB0aW9uIGJvZ3VzKSB7CiAgICAgICAgdGhyb3cgbmV3IFJ1bnRpbWVFeGNlcHRpb24oYm9ndXMpOyB9CiAgICB9CgogICAgWFBhY2tCdWlsZChmaW5hbCBTdHJpbmcgc2hvcnRIYXNoLCBmaW5hbCBTdHJpbmcgZGF0ZSkgewogICAgICAgIHRoaXMuc2hvcnRIYXNoID0gc2hvcnRIYXNoOwogICAgICAgIHRoaXMuZGF0ZSA9IGRhdGU7CiAgICB9CgogICAgcHVibGljIFN0cmluZyBzaG9ydEhhc2goKSB7CiAgICAgICAgcmV0dXJuIHRoaXMuc2hvcnRIYXNoOwogICAgfQogICAgcHVibGljIFN0cmluZyBkYXRlKCl7CiAgICAgICAgcmV0dXJuIHRoaXMuZGF0ZTsKICAgIH0KCiAgICBzdGF0aWMgewogICAgICAgIGZpbmFsIFBhdGggcGF0aCA9IGdldEVsYXN0aWNzZWFyY2hDb2RlYmFzZSgpOwogICAgICAgIFN0cmluZyBzaG9ydEhhc2ggPSBudWxsOwogICAgICAgIFN0cmluZyBkYXRlID0gbnVsbDsKICAgICAgICBMYWJlbF8wMTU3OiB7IHNob3J0SGFzaCA9ICJVbmtub3duIjsgZGF0ZSA9ICJVbmtub3duIjsKICAgIH0KCiAgICBDVVJSRU5UID0gbmV3IFhQYWNrQnVpbGQoc2hvcnRIYXNoLCBkYXRlKTsKICAgIH0KfQo="

#f_x_pack_license_verify="cGFja2FnZSBvcmcuZWxhc3RpY3NlYXJjaC5saWNlbnNlOwoKcHVibGljIGNsYXNzIExpY2Vuc2VWZXJpZmllciB7CiAgICBwdWJsaWMgc3RhdGljIGJvb2xlYW4gdmVyaWZ5TGljZW5zZShmaW5hbCBMaWNlbnNlIGxpY2Vuc2UsIGZpbmFsIGJ5dGVbXSBlbmNyeXB0ZWRQdWJsaWNLZXlEYXRhKSB7CiAgICAgICAgcmV0dXJuIHRydWU7CiAgICB9CgogICAgcHVibGljIHN0YXRpYyBib29sZWFuIHZlcmlmeUxpY2Vuc2UoZmluYWwgTGljZW5zZSBsaWNlbnNlKSB7CiAgICAgICAgcmV0dXJuIHRydWU7CiAgICB9Cn0K"

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

# echo $f_x_pack_build | base64 --decode > XPackBuild.java
# echo $f_x_pack_license_verify | base64 --decode > LicenseVerifier.java

echo $f_x_pack_build > XPackBuild.java
echo $f_x_pack_license_verify > LicenseVerifier.java

find /opt/bitnami/elasticsearch -type f \( -name "elasticsearch-$es_version.jar" -o -name "elasticsearch-core-$es_version.jar" -o -name "$x_pack" \) 2>/dev/null > files.txt

cat files.txt | xargs -n1 -I {} cp {} .

javac -cp $(cat files.txt | tr '\n' ':') -d . LicenseVerifier.java XPackBuild.java

jar uf "$x_pack" org

cat files.txt | grep "$x_pack" | xargs -n1 cp "$x_pack"
