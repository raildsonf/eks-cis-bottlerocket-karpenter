#!/usr/bin/env bash

RECOMMENDATION="3.1.1 Ensure packet redirect sending is disabled (Automated)"

    v1=`sysctl net.ipv4.conf.all.send_redirects | awk '/net.ipv4.conf.all.send_redirects = / {print $3}'`
    echo $v1
    
    v2=`sysctl net.ipv4.conf.default.send_redirects | awk '/net.ipv4.conf.default.send_redirects = / {print $3}'`
    echo $v2

    if [ "$v1" == 0 ] && [ "$v2" == 0 ];  then 
        echo "[PASS] $RECOMMENDATION"
    else
        echo "[FAIL] $RECOMMENDATION"
    fi


