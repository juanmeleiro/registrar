#!/usr/bin/fish

set tmp (mktemp)

begin
echo 'Date: '(date -R)
echo 'From: juan <juan@juanmeleiro.mat.br>'
echo 'To: <agora-official@agoranomic.org>'
echo 'Subject: [Registrar] Weekly report'
m4 weekly.m4
end > $tmp
neomutt -E -H $tmp
rm $tmp
