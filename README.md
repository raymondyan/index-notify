# 基金定时估值信息 de
-----------
### install python virtual environment:
```
(sudo) pip install virtualenv
cd PATH/TO/PROJECT
virtualenv env
source env/bin/activate
pip install -r requirement.txt
```

### run the cronjob script
```
(sudo) chmod +x cronrun.sh
./cronrun.sh

#if you want to remove the crontab
./cronrun.sh --remove
```
