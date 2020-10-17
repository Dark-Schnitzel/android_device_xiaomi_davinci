#!/bin/bash
# Shovel the data to the halium 9 source and build it. This is done to avoid overwriting anything if the halium source is updated
_vendor=xiaomi
_codename=davinci # Xiaomi Mi 9T, not pro!
_root_dir=/home/hank/ubports
_halium9_dir=$_root_dir/halium-9
_vendor_dir=$_root_dir/proprietary_vendor_$_vendor
_device_dir=$_root_dir/android_device_${_vendor}_${_codename}

# abort on error
set -e

# check all dirs
if [ ! -d $_root_dir ]; then
    echo "root dir $_root_dir missing" && exit 2
elif [ ! -d $_halium9_dir ]; then
    echo "halium9 dir $_halium9_dir missing" && exit 3
elif [ ! -d $_vendor_dir ]; then
    echo "vendor dir $_vendor_dir missing" && exit 4
elif [ ! -d $_device_dir ]; then
    echo "device dir $_device_dir missing" && exit 5
fi

# make sure repo is up to date
#echo "syncing halium repo...."
#cd $_halium9_dir && repo sync -c -j 16 || exit 10

# copy .repo/mainfests.xml
#echo "copying .repo/manifest.xml...."
#cp -pv $_device_dir/halium-9_manifest.xml $_halium9_dir/.repo/manifest.xml && echo "Step Completed"

# copy device-specific source: http://docs.halium.org/en/latest/porting/get-sources.html#initialize-and-download-source-tree
echo "copying device specific source...."
cp -pv $_device_dir/${_vendor}_${_codename}.xml $_halium9_dir//halium/devices/manifests/${_vendor}_${_codename}.xml && echo "Step Completed"

# copy vendor blob 
echo "copying vendor blob"
cp -prv $_vendor_dir/$_codename/* $_halium9_dir/vendor && echo "Step Completed"

# set env vars to build halium
echo "run build/envsetup..."
source $_halium9_dir/build/envsetup.sh && echo "Step Completed"

# Sync to get all of the Source
cd $_halium9_dir/halium/devices || exit 1
if !(bash -xe $_halium9_dir/halium/devices/setup $_codename); then
    echo "Build for $_codename failed" && exit 20
fi


exit 0