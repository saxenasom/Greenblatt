##find latest symbol
import csv
with open('D:\\Greenblatt\\Raw\\symbolchange.csv','rt') as fin:
    cin = csv.reader(fin)
    values = [row for row in cin]

company=[row[0] for row in values]
old=[row[1] for row in values]
new=[row[2] for row in values]
dates=[row[3] for row in values]
mapping={row[1]:row[2] for row in values}
flag=1
while flag:
    flag=0
    for key in mapping:
        if mapping[key] in mapping:
            mapping[key] = mapping[mapping[key]]
            flag = 1

output=[]
for num in range(len(company)):
    output.append([company[num], old[num], mapping[old[num]], dates[num]])

with open('D:\\Greenblatt\\symbolchange.csv', 'wt', newline='') as filobj:
    writr = csv.writer(filobj)
    # write multiple rows
    writr.writerows(output)