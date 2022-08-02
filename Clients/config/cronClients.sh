#!/bin/bash

#NOP vwifi-client 192.168.190.2 & # ADD to CRON

#Load variables
set -a
source /root/wlan_config_clients

while :
do
	date

	# Verify IP correct
	#VAR=`ip -br -4 a sh | grep enp0s3 | awk '{print $3}'`
	#if [[ ${VAR} != "192.168.190.16/24" ]] ; then
	#	ip addr add 192.168.190.16/24 dev enp0s3
	#fi

	#26-45
	killall dhclien-wifichallenge 2> /dev/nill &
	for N in `seq 40 59`; do
		dhclien-wifichallenge wlan$N 2> /dev/nill &
	done

	# Start Apache in client for Client isolation test
	service apache2 start


	sleep 60

	killall dhclien-wifichallenge 2> /dev/nill &
	for N in `seq 40 59`; do
		dhclien-wifichallenge wlan$N 2> /dev/nill &
	done

	sleep 10

	# MGT
	curl -s "http://$MAC_MGT_MSCHAP.1/login.php" --interface $WLAN_MGT_MSCHAP --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'Username=CONTOSO%5Cjuan.tr&Password=Secret%21&Submit=Login' --cookie-jar /tmp/userjuan &
	curl -s "http://$MAC_MGT_GTC.1/login.php" --interface $WLAN_MGT_GTC --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'Username=CONTOSO%5CAdministrator&Password=SuperSecure%40%21%40&Submit=Login' --cookie-jar /tmp/userAdmin &

	# MGT Relay
	curl -s "http://$IP_MGT_RELAY.1/login.php" --interface $WLAN_MGT_RELAY --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'Username=CONTOSOREG%5Cluis.da&Password=u89gh68!6fcv56ed&Submit=Login' --cookie-jar /tmp/userluis  &

	# MGT TLS
	curl -s "http://$IP_TLS.1/login.php" --interface $WLAN_TLS --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'Username=GLOBAL%5CGlobalAdmin&Password=SuperSuperSecure%40%21%40&Submit=Login' --cookie-jar /tmp/userGlobal  &

	# PSK, only login if cookies error
	STATUS=`curl -o /dev/null -w '%{http_code}\n' -s "http://$IP_WPA_PSK.1/lab.php" -c /tmp/userTest1 -b /tmp/userTest1`
	if [ "$STATUS" -ne 200 ] ; then
		curl -s "http://$IP_WPA_PSK.1/login.php" --interface $WLAN_WPA_PSK --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'Username=test1&Password=OYfDcUNQu9PCojb&Submit=Login' --cookie-jar /tmp/userTest1
	fi

	STATUS=`curl -o /dev/null -w '%{http_code}\n' -s "http://$IP_WPA_PSK2.1/lab.php" -c /tmp/userTest2 -b /tmp/userTest2`
	if [ "$STATUS" -ne 200 ] ; then
		curl -s "http://$IP_WPA_PSK2.1/login.php" --interface $WLAN_WPA_PSK2 --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'Username=test2&Password=2q60joygCBJQuFo&Submit=Login' --cookie-jar /tmp/userTest2
	fi

	# PSK NOAPP
	curl -s "http://$WLAN_PSK_NOAP.1/login.php" --interface $WLAN_PSK_NOAP --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'Username=anon1&Password=CRgwj5fZTo1cO6Y&Submit=Login' --cookie-jar /tmp/userAnon1 &
	curl -s "http://$WLAN_PSK_NOAP2.1/login.php" --interface $WLAN_PSK_NOAP2 --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'Username=anon1&Password=CRgwj5fZTo1cO6Y&Submit=Login' --cookie-jar /tmp/userAnon11 &

	# OPEN
	curl -s "http://$IP_OPN1.1/login.php" --interface $WLAN_OPN1 --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'Username=free1&Password=Jyl1iq8UajZ1fEK&Submit=Login' --cookie-jar /tmp/userFree1 &
	curl -s "http://$IP_OPN2.1/login.php" --interface $WLAN_OPN2 --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'Username=free2&Password=5LqwwccmTg6C39y&Submit=Login' --cookie-jar /tmp/userFree2 &
	curl -s "http://$IP_OPN3.1/login.php" --interface $WLAN_OPN3 --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'Username=free1&Password=Jyl1iq8UajZ1fEK&Submit=Login' --cookie-jar /tmp/userFree11 &

	# TODO Phishing client connect

	sleep 60

done
