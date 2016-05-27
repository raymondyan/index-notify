#/bin/bash

function error_exit
{
	echo "cronjob have been added."
	rm -f cronunit
	exit 1
}

cron_command="30 09-11,13-14 * * 1-5 `pwd`/env/bin/python `pwd`/value.py 020003 100022 210009"

crontab -l > cronunit 2> /dev/null

cat cronunit | grep -E "python.+value.py" > /dev/null

[[ $? -eq 0 ]] && error_exit

echo "$cron_command" >> cronunit

crontab cronunit

rm -f cronunit
