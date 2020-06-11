#!/bin/sh
preflight_check=0

echo "Current Dir:" $PWD
echo "Contents:"
ls
echo ""
echo "Command to run: $1"
echo ""

[ -z "$SENSU_USER" ] && [ -z "$INPUT_SENSU_USER" ] && echo "SENSU_USER environment variable empty" && preflight_check=1
[ -z "$SENSU_PASSWORD" ] && [ -z "$INPUT_SENSU_PASSWORD" ] && echo "SENSU_PASSWORD environment variable empty" && preflight_check=1
[ -z "$SENSU_BACKEND_URL" ] && [ -z "$INPUT_SENSU_BACKEND_URL" ] && echo "SENSU_BACKEND_URL environment variable empty" && preflight_check=1

if (( $preflight_check > 0 )); then
	exit 1
else
	echo "All needed environment variables are available"
fi

if [ -z "$INPUT_SENSU_USER" ]; then
	username=$SENSU_USER
else
	username=$INPUT_SENSU_USER
fi
if [ -z "$INPUT_SENSU_PASSWORD" ]; then
	password=$SENSU_PASSWORD
else
	password=$INPUT_SENSU_PASSWORD
fi
if [ -z "$INPUT_SENSU_BACKEND_URL" ]; then
	url=$SENSU_BACKEND_URL
else
	url=$INPUT_SENSU_BACKEND_URL
fi

echo "Configuring sensuctl:"
echo "  sensuctl configure -n --username $username --password $password --url $url"
retval=$?

if (( $retval != 0 )); then
	echo "sensuctl configure failed"
	exit $retval
fi



