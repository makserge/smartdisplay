#!/bin/bash
# Program:
#     This script is to extract the Android PlayStore apk form GAPPs package.
# Supported GAPPs package version (only): 
#     Platform:ARM, Android:6.0 and 7.1, Variant:pico
# Version: 1.0 
# Date: 2019.02.25
# History :
# 2018/08/30 First demo
# 2019/02/25 Fix path of "Phonesky.apk", feedbacked by forum.
# Note: You should install 'lzip' package first for extracting *.lz file
#
# Usage: 
#      sh ./extract.sh your_zip_file.zip
#

temp_path="GAPPs_package"
dest_path="APK_file"

# Check parameter
if [ "$#" -eq 0 ];then
    echo "Usage:" 
    echo "     $0 your_zip_file"   
    echo "Note: You should install 'lzip' package first for extracting *.lz file"
    exit 0
fi

# Unzip .zip
echo "Extracting $1 to ./$temp_path/"
unzip -o $1 -d ./$temp_path/
if [ "$?" = "0" ];then
    echo "Unzip successed."
else
    echo "Unzip failed."
    exit 1
fi

# Extracting .lz under /Core/
cd $temp_path/Core/
echo "Extracting .lz file in /Core/"

# Phonesky.apk
lzip -k -d -f vending-arm.tar.lz
tar xvf vending-arm.tar

# PrebuiltGmsCore.apk
lzip -k -d -f gmscore-arm64.tar.lz
tar xvf gmscore-arm64.tar

# GoogleServicesFramework.apk
lzip -k -d -f gsfcore-all.tar.lz
tar xvf gsfcore-all.tar

# GoogleLoginService.apk
lzip -k -d -f gsflogin-all.tar.lz
tar xvf gsflogin-all.tar

# GoogleContactsSyncAdapter.apk
lzip -k -d -f googlecontactssync-all.tar.lz
tar xvf googlecontactssync-all.tar

# Extracting .lz under /GApps/
cd ../GApps/
echo "Extracting .lz file in /GApps/"

# GoogleCalendarSyncAdapter.apk
lzip -k -d -f calsync-all.tar.lz
tar xvf calsync-all.tar

# Goto $temp_path
cd ../../

mkdir $dest_path/
echo "Collecting apk from package to ./$dest_path/"

mv ./$temp_path/Core/vending-arm/nodpi/priv-app/Phonesky/Phonesky.apk ./$dest_path/
mv ./$temp_path/Core/gmscore-arm64/nodpi/priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk ./$dest_path/
mv ./$temp_path/Core/gsfcore-all/nodpi/priv-app/GoogleServicesFramework/GoogleServicesFramework.apk ./$dest_path/
mv ./$temp_path/Core/gsflogin-all/nodpi/priv-app/GoogleLoginService/GoogleLoginService.apk ./$dest_path/
mv ./$temp_path/Core/googlecontactssync-all/nodpi/app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk ./$dest_path/
mv ./$temp_path/GApps/calsync-all/nodpi/app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk ./$dest_path/

echo "Done."
exit 0
