import re
import pprint

abbrev = re.compile('[^\t]*\.\.\. ?\[([0-9]+)\]')

with open('history.tsv', 'r') as f:
    history = f.read().split('\n')

history = [h.split('\t') for h in history]

with open('notes.txt', 'r') as f:
    notelines = f.read().split('\n')

notes = dict()
n = []
i = 0
for l in notelines:
    m = re.match('\[([0-9]+)\]', l)
    if m:
        notes[i] = ''.join(n)
        n = [re.sub('\[[0-9]+\] ', '', l)]
        i = int(m.group(1).strip('\n'))
    else:
        n.append(l.strip('\n'))

for i in range(len(history)):
        for j in range(len(history[i])):
                m = abbrev.search(history[i][j])
                if m:
                        history[i][j] = abbrev.sub(notes[int(m.group(1))], history[i][j])

for h in history:
        print('\t'.join(h))
