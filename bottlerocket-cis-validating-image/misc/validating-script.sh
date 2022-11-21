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



RECOMMENDATION="3.4.1.1 Ensure IPv4 default deny firewall policy (Automated)"
inputChainLine=$(iptables -L | grep "Chain INPUT" )
inputChain=` echo $inputChainLine | awk '{print $4}' `
echo $inputChain

ForwardChainLine=$(iptables -L | grep "Chain FORWARD" )
ForwardChain=` echo $ForwardChainLine | awk '{print $4}' `
echo $ForwardChain

OutputChainLine=$(iptables -L | grep "Chain OUTPUT" )
OutputChain=` echo $OutputChainLine | awk '{print $4}' `
echo $OutputChain

if [[ $inputChain == "ACCEPT)" ]] && [[ $ForwardChain == "ACCEPT)" ]] && [[ $OutputChain == "DROP)" ]];
then
    echo "[PASS] $RECOMMENDATION"
    Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
else
    echo "[FAIL] $RECOMMENDATION"
fi

RECOMMENDATION="3.4.1.2 Ensure IPv4 loopback traffic is configured (Automated)"
InputAccept=$(iptables -L INPUT -v -n | grep "ACCEPT     all" | awk '{print $8}')
echo $InputAccept

InputDrop=$(iptables -L INPUT -v -n | grep "DROP       all" | awk '{print $8}')
echo $InputDrop

OutputAccept=$(iptables -L OUTPUT -v -n | grep "ACCEPT     all" | awk '{print $8}')
echo $OutputAccept


if [[ $InputAccept == "0.0.0.0/0" ]] && [[ $InputDrop == "127.0.0.0/8" ]] && [[ $OutputAccept == "0.0.0.0/0" ]];
then
    echo "[PASS] $RECOMMENDATION"
    Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
else
    echo "[FAIL] $RECOMMENDATION"
fi

RECOMMENDATION="3.4.1.3 Ensure IPv4 outbound and established connections are configured (Manual)"
InputTCP=$(iptables -L INPUT -v -n | grep "ACCEPT     tcp" | awk '{print $11}')
echo $InputTCP

InputUDP=$(iptables -L INPUT -v -n | grep "ACCEPT     udp" | awk '{print $11}')
echo $InputUDP

InputICMP=$(iptables -L INPUT -v -n | grep "ACCEPT     icmp" | awk '{print $11}')
echo $InputICMP

OutputTCP=$(iptables -L OUTPUT -v -n | grep "ACCEPT     tcp" | awk '{print $11}')
echo $OutputTCP

OutputUDP=$(iptables -L OUTPUT -v -n | grep "ACCEPT     udp" | awk '{print $11}')
echo $OutputUDP

OutputICMP=$(iptables -L OUTPUT -v -n | grep "ACCEPT     icmp" | awk '{print $11}')
echo $OutputICMP

if [[ $InputTCP == "ESTABLISHED" ]] && [[ $InputUDP == "ESTABLISHED" ]] && [[ $InputICMP == "ESTABLISHED" ]] && [[ $OutputTCP == "NEW,ESTABLISHED" ]] && [[ $OutputUDP == "NEW,ESTABLISHED" ]] && [[ $OutputICMP == "NEW,ESTABLISHED" ]];
then
    echo "[PASS] $RECOMMENDATION"
    Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
else
    echo "[FAIL] $RECOMMENDATION"
fi




RECOMMENDATION="3.4.2.1 Ensure IPv6 default deny firewall policy (Automated)"
inputChainLine=$(ip6tables -L | grep "Chain INPUT" )
inputChain=` echo $inputChainLine | awk '{print $4}' `
echo $inputChain

ForwardChainLine=$(ip6tables -L | grep "Chain FORWARD" )
ForwardChain=` echo $ForwardChainLine | awk '{print $4}' `
echo $ForwardChain

OutputChainLine=$(ip6tables -L | grep "Chain OUTPUT" )
OutputChain=` echo $OutputChainLine | awk '{print $4}' `
echo $OutputChain

if [[ $inputChain == "ACCEPT)" ]] && [[ $ForwardChain == "ACCEPT)" ]] && [[ $OutputChain == "DROP)" ]];
then
    echo "[PASS] $RECOMMENDATION"
    Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
else
    echo "[FAIL] $RECOMMENDATION"
fi



RECOMMENDATION="3.4.2.2 Ensure IPv6 loopback traffic is configured (Automated)"
InputAccept=$(ip6tables -L INPUT -v -n | grep "ACCEPT     all" | awk '{print $8}')
echo $InputAccept

InputDrop=$(ip6tables -L INPUT -v -n | grep "DROP       all" | awk '{print $8}')
echo $InputDrop

OutputAccept=$(ip6tables -L OUTPUT -v -n | grep "ACCEPT     all" | awk '{print $8}')
echo $OutputAccept


if [[ $InputAccept == "0.0.0.0/0" ]] && [[ $InputDrop == "127.0.0.0/8" ]] && [[ $OutputAccept == "0.0.0.0/0" ]];
then
    echo "[PASS] $RECOMMENDATION"
    Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
else
    echo "[FAIL] $RECOMMENDATION"
fi


RECOMMENDATION="3.4.2.3 Ensure IPv6 outbound and established connections are configured (Manual)"
InputTCP=$(ip6tables -L INPUT -v -n | grep "ACCEPT     tcp" | awk '{print $11}')
echo $InputTCP

InputUDP=$(ip6tables -L INPUT -v -n | grep "ACCEPT     udp" | awk '{print $11}')
echo $InputUDP

InputICMP=$(ip6tables -L INPUT -v -n | grep "ACCEPT     icmp" | awk '{print $11}')
echo $InputICMP

OutputTCP=$(ip6tables -L OUTPUT -v -n | grep "ACCEPT     tcp" | awk '{print $11}')
echo $OutputTCP

OutputUDP=$(ip6tables -L OUTPUT -v -n | grep "ACCEPT     udp" | awk '{print $11}')
echo $OutputUDP

OutputICMP=$(ip6tables -L OUTPUT -v -n | grep "ACCEPT     icmp" | awk '{print $11}')
echo $OutputICMP

if [[ $InputTCP == "ESTABLISHED" ]] && [[ $InputUDP == "ESTABLISHED" ]] && [[ $InputICMP == "ESTABLISHED" ]] && [[ $OutputTCP == "NEW,ESTABLISHED" ]] && [[ $OutputUDP == "NEW,ESTABLISHED" ]] && [[ $OutputICMP == "NEW,ESTABLISHED" ]];
then
    echo "[PASS] $RECOMMENDATION"
    Num_Of_Checks_Passed=$((Num_Of_Checks_Passed+1))
else
    echo "[FAIL] $RECOMMENDATION"
fi



# below is for test
iptables -L | grep "Chain INPUT" 
       v1=$(iptables -L | grep "Chain INPUT" )
       echo $v1
       v2=` echo $v1 | awk '{print $4}' `
       echo $v2
       
Chain INPUT (policy ACCEPT)
Chain FORWARD (policy ACCEPT)
Chain OUTPUT (policy DROP)


       
       
    
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


