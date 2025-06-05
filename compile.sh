#!/bin/bash
cd ~/rom

REPO_MNFS="https://github.com/rducks/android.git"
REPO_MNFS_BRANCH="lineage-17.1"
DEVICE_MNFS="https://github.com/rducks/rom"
DEVICE_MNFS_BRANCH="master"

export TZ=Asia/Jakarta
export CCACHE_DIR=~/ccache
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
export KBUILD_BUILD_USER="nobody"
export KBUILD_BUILD_HOST="android-build"

sync_s() {
    repo init --depth=1 -u $REPO_MNFS -b $REPO_MNFS_BRANCH
    git clone --depth=1 -b $DEVICE_MNFS_BRANCH $DEVICE_MNFS
    mkdir -p .repo/local_manifests
    mv rom/device.xml .repo/local_manifests/roomservice.xml 
    repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8
}

compile_r() {
    source build/envsetup.sh
    ccache -M 100G -F 0
    ccache -o compression=true
    ccache -z
    lunch lineage_RMX2185-user
    mka bacon &
    make_pid=$!
    for ((i=1; i<=80; i++)); do
        if ! kill -0 $make_pid 2>/dev/null; then
            break
        fi
        sleep 1m
    done
    if kill -0 $make_pid 2>/dev/null; then
        kill $make_pid
    fi
}

case "$1" in
    "--rom"|"-r")
        compile_r
        ;;
    "--sync"|"-s")
        sync_s
        ;;
    *)
        echo "Usage: $0 [options]"
        echo "  --rom, -r     Compile ROM"
        echo "  --sync, -s    Sync ROM source"
        exit 1
        ;;
esac