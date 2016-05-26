#!/usr/bin/python
# -*- coding: UTF-8 -*-
from bs4 import BeautifulSoup
import urllib2
from os import system
import sys
from pync import Notifier

def tongzhi(num,soup):
	tag = soup(id=num)[0]
	price = tag.parent.parent(class_="gr")[0].text
	rate = tag.parent.parent(class_="bg")[0].text
	brand = tag.parent.parent.a.text
	value = '%s\t%s' % (price, rate)
	Notifier.notify(value.encode('utf-8'),subtitle=brand.encode('utf-8'), title='基金估值',  sound='Submarine')
	
if __name__ == "__main__":
	url = "http://fund.eastmoney.com/fundguzhi.html"
	content = urllib2.urlopen(url).read()
	soup = BeautifulSoup(content,"html.parser")
	for num in sys.argv[1:]:
		tongzhi(num,soup)