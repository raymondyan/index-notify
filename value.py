#!/usr/bin/python
# -*- coding: UTF-8 -*-
from bs4 import BeautifulSoup
import urllib2
from os import system
import sys
import os
from pync import Notifier
from time import sleep

def notification(num,soup):
	tag = soup(id=num)[0]
	price = tag.parent.parent(class_="gr")[0].text
	rate = tag.parent.parent(class_="bg")[0].text
	brand = tag.parent.parent.a.text.encode('utf-8')
	value = '%s\t%s' % (price, rate)
	Notifier.notify(value.encode('utf-8'),title=brand,group=num, remove=num, sound='Glass')

def readlist():
	path = os.path.dirname(os.path.realpath(__file__))+'/list.txt'
	f = open(path, 'r')
	k = f.readlines()
	return map(lambda x:x.strip(),k)
	
if __name__ == "__main__":
	url = "http://fund.eastmoney.com/fundguzhi.html"
	content = urllib2.urlopen(url).read()
	soup = BeautifulSoup(content,"html.parser")
	list = readlist()
	for num in list:
		notification(num,soup)
		sleep(5)