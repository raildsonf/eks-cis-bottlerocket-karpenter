#!/usr/bin/env bash

sleep 20000


Num_Of_Checks_Passed=0
Total_Num_Of_Checks=10

function F3()
{
    for str in ${myArray[@]}; do
       v1=$(sysctl $str)
       v2=` echo $v1 | awk '{print $3}' `
       
       if [[ "$v2" != $expectedValue ]] 
       then
        return 0
       fi
    done
    return 1
}


    
RECOMMENDATION="3.1.1 Ensure packet redirect sending is disabled (Automated)"
myArray=("net.ipv4.conf.all.send_redirects" "net.ipv4.conf.default.send_redirects")
expectedValue=0
F3


if [ "$?" -eq "1" ]; then
    echo "[PASS] $RECOMMENDATION"
    Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
else
    echo "[FAIL] $RECOMMENDATION"
fi

echo "$Num_Of_Checks_Passed/$Total_Num_Of_Checks checks passed"

RECOMMENDATION="3.2.2 Ensure ICMP redirects are not accepted (Automated)"
myArray=("net.ipv4.conf.all.accept_redirects" "net.ipv4.conf.default.accept_redirects" "net.ipv6.conf.all.accept_redirects" "net.ipv6.conf.default.accept_redirects")
expectedValue=0
F3


if [ "$?" -eq "1" ]; then
    echo "[PASS] $RECOMMENDATION"
    Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
else
    echo "[FAIL] $RECOMMENDATION"
fi

echo "$Num_Of_Checks_Passed/$Total_Num_Of_Checks checks passed"



RECOMMENDATION="3.2.3 Ensure secure ICMP redirects are not accepted (Automated)"
myArray=("net.ipv4.conf.all.secure_redirects" "net.ipv4.conf.default.secure_redirects")
expectedValue=0
F3


if [ "$?" -eq "1" ]; then
    echo "[PASS] $RECOMMENDATION"
    Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
else
    echo "[FAIL] $RECOMMENDATION"
fi

echo "$Num_Of_Checks_Passed/$Total_Num_Of_Checks checks passed"


RECOMMENDATION="3.2.4 Ensure suspicious packets are logged (Automated)"
myArray=("net.ipv4.conf.all.log_martians" "net.ipv4.conf.default.log_martians")
expectedValue=1
F3


if [ "$?" -eq "1" ]; then
    echo "[PASS] $RECOMMENDATION"
    Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
else
    echo "[FAIL] $RECOMMENDATION"
fi

echo "$Num_Of_Checks_Passed/$Total_Num_Of_Checks checks passed"





# below is for test


    
    Num_Of_Checks_Passed=0
    Total_Num_Of_Checks=10
    
    RECOMMENDATION="3.1.1 Ensure packet redirect sending is disabled (Automated)"

    v1=`sysctl net.ipv4.conf.all.send_redirects | awk '/net.ipv4.conf.all.send_redirects = / {print $3}'`
    echo $v1
    
    v2=`sysctl net.ipv4.conf.default.send_redirects | awk '/net.ipv4.conf.default.send_redirects = / {print $3}'`
    echo $v2

    if [ "$v1" == 0 ] && [ "$v2" == 0 ];  then 
        echo "[PASS] $RECOMMENDATION"
        Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
    else
        echo "[FAIL] $RECOMMENDATION"
    fi
    
    v1="net.ipv4.conf.all.send_redirects = 0"
    echo $v1 | awk '{print $0}'
    
    myArray=("net.ipv4.conf.all.send_redirects" "net.ipv4.conf.default.send_redirects")
    for str in ${myArray[@]}; do
       echo $str
       #v1=`sysctl $str | awk '/$str = / {print $3}'`
       v1=$(sysctl $str)
       #v2=echo $v1 | awk '{print $3}'
       v2=` echo $v1 | awk '{print $3}' `
       echo $v2
       #| awk '/$str = / {print $3}'`
      
    done

    



if [ "$?" -eq "0" ]; then
  echo "They're equal";
fi

        echo "[PASS] $RECOMMENDATION"
        Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
        
        

 
 

value=$(F3)
echo $value



    if [[ $arg1 != "" ]];
    then
        retval="BASH function with variable"
    else
        echo "No Argument"
        retval="No argument"
    fi

$myArray

getval1="Bash Function"
F3 $getval1
echo $retval
getval2=$(F3)
echo $getval2


    echo "$Num_Of_Checks_Passed/$Total_Num_Of_Checks checks passed"


