define(HEADING, PLAYER  $1 DATE
------  $1 ----------)dnl
esyscmd(`grep "^w" monthly/history.tsv | cut -f 2,5 | column -t -N "HEADING(\`,')"')
