crontab -l > cronunit

echo "30 09-11,13-14 * * 1-5 `echo $PWD`/env/bin/python `echo $PWD`/value.py 020003 100022 210009" >> cronunit

crontab cronunit