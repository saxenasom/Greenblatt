import os
import csv
path='D:\\Greenblatt\\Raw\\Reports\\'
bslist=[file for file in os.listdir(path) if file[-7:]=='-BS.csv']
pllist=[file for file in os.listdir(path) if file[-8:]=='-P&L.csv']
names={name[:-7] for name in bslist}

eps=[['Symbol', 'Report Date', 'Interest','Profit before tax', 'Net Profit','EPS']]
for file in pllist:
    with open(path+file,'rt') as fin:
        cin = csv.reader(fin)
        values = [row for row in cin]
    for num in range(1,len(values[-1])):
        if values[0][num]!='TTM':
            new=[file[:-8]]                                                                               #Symbol
            new.append(('1 '+values[0][num]).replace(' ','-'))                      #Report Date
            new.append(values[-6][num].replace(',',''))                               #Interest
            new.append(values[-4][num].replace(',',''))                               #Profit before tax
            new.append(values[-2][num].replace(',',''))                               #Net Profit
            new.append(values[-1][num].replace(',',''))                               #EPS
            eps.append(new)

assets=[['Symbol', 'Report Date', 'Assets']]
for file in bslist:
    with open(path+file,'rt') as fin:
        cin = csv.reader(fin)
        values = [row for row in cin]
    for num in range(1,len(values[-1])):
        if values[0][num]!='TTM':
            new=[file[:-7]]                                                                               #Symbol
            new.append(('1 '+values[0][num]).replace(' ','-'))                      #Report Date
            new.append(values[-1][num].replace(',',''))                               #Assets
            assets.append(new)

with open('D:\\Greenblatt\\eps.csv', 'wt', newline='') as f:
    writer = csv.writer(f)
    writer.writerows(eps)

with open('D:\\Greenblatt\\assets.csv', 'wt', newline='') as f:
    writer = csv.writer(f)
    writer.writerows(assets)