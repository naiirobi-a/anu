#!/bin/bash
cd ~/

RCLONE_REMOTE="zona:zx"

cache_d() {
    rclone copy $RCLONE_REMOTE/ccache.tar.gz ~/ -P
    time tar xf ccache.tar.gz
}

cache_m() {
    export CCACHE_DIR=~/ccache
    sleep 1m
    while :
    do
        ccache -s
        echo ''
        top -b -i -n 1
        sleep 5s
    done
}

cache_u() {
    if [ -f ~/rom/out/target/product/RMX2185/*UNOFFICIAL*.zip ]; then
      rclone copy ~/rom/out/target/product/RMX2185/*UNOFFICIAL*.zip $RCLONE_REMOTE -P
    fi
    time tar --use-compress-program="pigz -k -1" -cf ccache.tar.gz ccache
    rclone copy ccache.tar.gz $RCLONE_REMOTE -P
}

case "$1" in
    "-d")
        cache_d
        ;;
    "-m")
        cache_m
        ;;
    "-u")
        cache_u
        ;;
    *)
        echo "Usage: $0 [options]"
        echo "  -d         Download ccache"
        echo "  -m         Monitor ccache"
        echo "  -u         Upload ccache"
        exit 1
        ;;
esac