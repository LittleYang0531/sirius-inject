unzip Il2CppDumper.zip
CreateDirectory output
Il2CppDumper.exe libil2cpp.so global-metadata.dat output
$VERSION=$(Get-Content appVersion.txt)
echo "VERSION=$VERSION" >> "$GITHUB_ENV"