#!/usr/bin/python3
valid_table = {}

start_phrase = 'Looking up status of'
with open('nmblookup_out.txt', 'r') as f:
  while True:
    line = f.readline()
    if line=='':
      break
    elif start_phrase in line:
      ipaddr = line.split()[-1]
      
      # now read lines until you get next phrase
      line = f.readline()
      phrase_lines = []
      while start_phrase not in line and line != '':
        phrase_lines.append(line)
        line = f.readline()

      # parse phraselines
      if 'No reply from' not in phrase_lines[0]:
        # then continue to add valid entry info to dictionary
        macaddr=''
        hostinfo=''
        for x in phrase_lines:
          if 'MAC Address' in x:
            macaddr = x.split()[-1]
          if '<20>' in x:
            hostinfo = x.split()[0]
        valid_table[ipaddr] = [macaddr, hostinfo]

      # at this point line should have start_phrase or eof. restart loop


print(f'ip address\tmac address\t\thost name')
print(f'________________________________________________________')
for ip in valid_table.keys():
  mac, hostname = valid_table[ip]
  print(f'{ip}\t{mac}\t{hostname}')