YELLOW='\033[1;33m'
WHITE='\033[0m'

# Prepare curl-impersonate
echo -e "$YELLOW""Installing curl-impersonate.tar.gz...""$WHITE"
curl https://github.com/lwthiker/curl-impersonate/releases/download/v0.5.4/curl-impersonate-v0.5.4.x86_64-linux-gnu.tar.gz -Lo curl.tar.gz
echo -e "$YELLOW""Extracting curl.tar.gz...""$WHITE"
tar -xvf curl.tar.gz >/dev/null
# Prepare apktool
echo -e "$YELLOW""Downloading apktool_2.9.0.jar...""$WHITE"
curl https://github.com/iBotPeaches/Apktool/releases/download/v2.9.0/apktool_2.9.0.jar -Lo apktool.jar

# Judge Application Type And Version
echo -e "$YELLOW""Fetching Application Information...""$WHITE"
HTML=$(./curl_chrome110 https://apkpure.net/cn/%E3%83%AF%E3%83%BC%E3%83%AB%E3%83%89%E3%83%80%E3%82%A4%E3%82%B9%E3%82%BF%E3%83%BC-%E5%A4%A2%E3%81%AE%E3%82%B9%E3%83%86%E3%83%A9%E3%83%AA%E3%82%A6%E3%83%A0/com.kms.worlddaistar/download 2>/dev/null)
echo $HTML;
VERSION=$(echo $HTML | sed -n 's/^.*"version":"\([0-9.]\+\).*$/\1/gp')
isXAPK=$([ -z "$(echo $HTML | grep -o "下载 XAPK")" ] && echo 0 || echo 1)
echo -e "$YELLOW""Latest Version: $VERSION""$WHITE"
echo -e "$YELLOW""Installer Type: "$([ $isXAPK == 1 ] && echo "XAPK" || echo "APK" )"$WHITE"

# Set Github Environment Variables
echo -e "$YELLOW""Setting Github Environment Variables...""$WHITE"
echo "VERSION=v$VERSION" >> "$GITHUB_ENV"

if [[ $isXAPK == 0 ]]; then
    echo -e "$YELLOW""Fetching Application Installer...""$WHITE"
    ./curl_chrome110 --parallel --parallel-immediate --parallel-max 64 -L -k -C - -o sirius.apk "https://d.cdnpure.com/b/APK/com.kms.worlddaistar?version=latest"

    echo -e "$YELLOW""Unpacking Package...""$WHITE"
    java -jar apktool.jar d sirius.apk

    echo -e "$YELLOW""Editing Package...""$WHITE"
    cp network_security_config.xml sirius/res/xml
    sed -i s/com.kms.worlddaistar/com.kms.worlddaistar2/g sirius/AndroidManifest.xml
    sed -i s/com.kms.worlddaistar2.UnityPlayerActivityOverride/com.kms.worlddaistar.UnityPlayerActivityOverride/g sirius/AndroidManifest.xml
    sed -i s/application\ /application\ android:networkSecurityConfig=\"@xml\\/network_security_config\"\ android:debuggable=\"true\"\ /g sirius/AndroidManifest.xml
    sed -i s/targetSdkVersion:\ 33/targetSdkVersion:\ 29/g sirius/apktool.yml

    echo -e "$YELLOW""Repacking Package...""$WHITE"
    java -jar apktool.jar b sirius -o sirius.apk

    echo -e "$YELLOW""Signing Package...""$WHITE"
    jarsigner -verbose -keystore abc.keystore -storepass 123456 -signedjar sirius_signed.apk sirius.apk abc.keystore
fi

echo -e "$YELLOW""Finished!""$WHITE"