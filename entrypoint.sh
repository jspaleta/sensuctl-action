#!/bin/sh
preflight_check=0

if [ -z "SENSU_COMMAND" ]; then
	SENSU_COMMAND=$1
fi

[ -z "$SENSU_USER" ] && [ -z "$INPUT_SENSU_USER" ] && echo "SENSU_USER environment variable empty" && preflight_check=1
[ -z "$SENSU_PASSWORD" ] && [ -z "$INPUT_SENSU_PASSWORD" ] && echo "SENSU_PASSWORD environment variable empty" && preflight_check=1
[ -z "$SENSU_BACKEND_URL" ] && [ -z "$INPUT_SENSU_BACKEND_URL" ] && echo "SENSU_BACKEND_URL environment variable empty" && preflight_check=1
[ -z "$SENSU_COMMAND" ] && [ -z "$INPUT_SENSU_COMMAND" ] && echo "SENSU_COMMAND environment variable empty" && preflight_check=1

if test $preflight_check -ne 0 ; then
	echo "Missing environment variables"
	exit 1
else
	echo "All needed environment variables are available"
fi

if [ -z "$INPUT_SENSU_USER" ] ; then
	username=$SENSU_USER
else
	username=$INPUT_SENSU_USER
fi
if [ -z "$INPUT_SENSU_PASSWORD" ] ; then
	password=$SENSU_PASSWORD
else
	password=$INPUT_SENSU_PASSWORD
fi
if [ -z "$INPUT_SENSU_BACKEND_URL" ] ; then
	url=$SENSU_BACKEND_URL
else
	url=$INPUT_SENSU_BACKEND_URL
fi
if [ -z "$INPUT_CONFIGURE_ARGS" ] ; then
	optional_args=$CONFIGURE_ARGS
else
	optional_args=$INPUT_CONFIGURE_ARGS
fi
if [ -z "$INPUT_SENSU_CA" ] ; then
	ca_file=$SENSU_CA
else
	ca_file=$INPUT_SENSU_CA
fi
if [ -z "$ca_file" ] ; then
	touch /tmp/sensu_ca.pem  
else
	echo $ca_file > /tmp/sensu_ca.pem  
fi

if [ -s /tmp/sensu_ca.pem ]; then
        echo "custom CA file present"
	ca_arg='--trusted-ca-file /tmp/sensu_ca.pem'
else
 	ca_arg=''
fi

echo "Configuring sensuctl:"
sensuctl configure -n --username ${username} --password ${password} --url ${url} ${ca_arg}  ${optional_args}
retval=$?

if test $retval -ne 0; then
	echo "sensuctl configure failed"
	exit $retval
fi

sensuctl $SENSU_COMMAND

