rm -f notify.crontab
touch notify.crontab
echo "30 09-11,13-14 * * 1-5 `echo $PWD`/env/bin/python `echo $PWD`/value.py" >> notify.crontab
echo "50,55 14 * * 1-5 `echo $PWD`/env/bin/python `echo $PWD`/value.py" >> notify.crontab