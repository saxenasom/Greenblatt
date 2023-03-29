##Combine all price-volume archives into one file
import csv
import os
path='D:/Greenblatt/Raw/Bhavcopy/'
filelist=[file for file in os.listdir(path) if file[-4:]=='.csv']
filelist.sort()
file=filelist[0]
with open(path+file,'rt') as fin:
    cin = csv.reader(fin)
    values = [row for row in cin]

with open('D:/Greenblatt/pva.csv', 'wt', newline='') as filobj:
    writr = csv.writer(filobj)
    # write multiple rows
    writr.writerow(values[0][0:11])

for file in filelist:
    with open(path+file,'rt') as fin:
        cin = csv.reader(fin)
        values = [row[0:11] for row in cin]
        eq = [row for row in values if row[1]=='EQ']
        be = [row for row in values if (row[1]=='BE')]
    with open('D:/Greenblatt/pva.csv', 'at', newline='') as filobj:
        writr = csv.writer(filobj)
        # write multiple rows
        writr.writerows(eq+be)


