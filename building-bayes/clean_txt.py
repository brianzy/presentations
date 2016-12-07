from sys import argv

filename = argv[1]

with open(filename,'r') as i:
    with open(filename.split('.')[0]+'_cleaned.txt','wb') as o:
        for line in i.readlines():
            if '--' in line:
                next
            elif len(line) == 1:
                next
            else:
                o.write(line)