#!/usr/bin/fish

set tmp (mktemp)

begin
echo 'Date: '(date -R)
echo 'From: juan <juan@juanmeleiro.mat.br>'
echo 'To: <agora-official@agoranomic.org>'
echo 'Subject: [Registrar] Weekly report'
m4 weekly/weekly.m4
end > $tmp
neomutt -E -H $tmp
set today (date --iso-8601=date)
read -n 1 -P 'Archive? [Yn] ' ans
contains "$ans" n N no No NO
or begin
	mv $tmp archive/$today-weekly.txt
	echo "[$today] Published weekly report." >> log.txt
end

if jq -e '[.[][] | select(has("active") and (.active | not))] | length > 0' players.json > /dev/null
	jq -r '.[][] | select(has("active") and (.active | not)) | .name' players.json
	read -P 'This players are to be deregistered. Do it? [Yn]' -n 1 ans
	if contains "$ans" n N no No NO
		exit 0
	end
else
	exit 0
end

set tmp (mktemp)

begin
echo 'Date: '(date -R)
echo 'From: juan <juan@juanmeleiro.mat.br>'
echo 'To: <agora-official@agoranomic.org>'
echo 'Subject: [Registrar] Deregistration intents'
jq -rf scripts/deregistrations.jq players.json
end > $tmp
neomutt -E -H $tmp
rm $tmp
mv $tmp archive/(date --iso-8601=date)-deregistration.txt

begin
echo 'TODO Deregister players in Agora'
date -d 'now + 4 days' +'SCHEDULED: <%Y-%m-%d %a>'
end | capture -i
