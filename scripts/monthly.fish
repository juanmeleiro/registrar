#!/usr/bin/fish

set tmp (mktemp)

begin
echo 'Date: '(date -R)
echo 'From: juan <juan@juanmeleiro.mat.br>'
echo 'To: <agora-official@agoranomic.org>'
echo 'Subject: [Registrar] Monthly report: Arrivals and Departures'
m4 monthly/monthly.m4
end > $tmp
neomutt -E -H $tmp
mv $tmp archive/(date --iso-8601=date)-monthly.txt
