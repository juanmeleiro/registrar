'''Format history.tsv into emailable format'''
import csv
import pprint
import string

class NotesFormatter(string.Formatter):
   def __init__(self, notes=[]):
       string.Formatter.__init__(self)
       self.notes = notes
       self.abbrevs = []

   def get_value(self, key, args, kwds):
       if key == "notes":
           n = kwds["notes"]
           if n == "":
               return n
           cur = len(self.notes)
           self.notes.append(n)
           return "[{}]".format(cur)
       elif key == "name":
           # This is bad and should be replaced by overwriting get_field
           n = kwds["name"]
           MAX = 20
           if len(n) > MAX:
               cur = len(self.abbrevs)
               self.abbrevs.append(n)
               return n[0:(MAX-3-len(str(cur)))] + "…[{}]".format(cur)
           else:
               return n
       else:
           return string.Formatter.get_value(self, key, args, kwds)

columns = [
        "rune",
        "name",
        "contact",
        "registration",
        "deregistration",
        "notes"
]
history = []

with open("monthly/history.tsv", "r") as f:
    csv = csv.reader(f, delimiter="\t")
    next(csv)
    for line in csv:
        entry = dict()
        for i, n in enumerate(columns):
                if i < len(line):
                        entry[n] = line[i]
                else:
                    entry[n] = ""
        history.append(entry)

notes = []
formatted = []
entryformat = "{rune: <2} {name: <20} {registration: >10} {deregistration: >10} {contact} {notes}"
formatter = NotesFormatter()

print(entryformat.format(rune="", name="Name", registration="From", deregistration="Until", contact="Contact", notes="Notes"))
for h in history:
    print(formatter.vformat(entryformat, [], h).strip())
for i, n in enumerate(formatter.notes):
    print("[{}]: {}".format(i, n))
