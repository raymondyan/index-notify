#!/usr/bin/python
# -*- coding: UTF-8 -*-
from bs4 import BeautifulSoup
import urllib2
from os import system
import sys

num = sys.argv[1]

url = "http://fund.eastmoney.com/fundguzhi.html"
content = urllib2.urlopen(url).read()
soup = BeautifulSoup(content,"html.parser")
tag = soup(id=num)[0]
price = tag.parent.parent(class_="gr")[0].text
rate = tag.parent.parent(class_="bg")[0].text
brand = tag.parent.parent.a.text
value = '%s,%s,%s' % (brand, price, rate)
print value.encode('utf-8')

print '\n---------------------自选指数参考---------------------'
print '020003\t国泰金龙行业精选\t买:0.60-0.61,卖:0.63+'
print '100022\t富国天瑞强势      \t买:0.45-0.46,卖:0.48+'
print '210009\t金鹰核心资源混合\t买:1.36-1.37,卖:1.45+'
print '------------------------------------------------------'

