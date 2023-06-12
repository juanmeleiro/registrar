#!/usr/bin/fish

set WIDTH 80

function ord -a num
	switch "$num"
	case 1 01
		echo st
	case 2 02
		echo nd
	case 3 03
		echo rd
	case '*'
		echo th
	end
end

fzf < birthdays/list |
read date name

echo $date | read -d '-' birthyear month day

set currentyear (date +%Y)
set currentstamp (date +%S)
set birthstamp (date +%S -d $date)

if test (date +%S -d "$currentyear-$month-$day") -gt $currentstamp
	# Most recent birthday was last year
	set year (math $currentyear - 1)
else
	# Most recent birthday was this year
	set year $currentyear
end

set MONTH (env LANG=en date +"%B" -d "$year-$month-$day")
set DATEORD (ord $day)
set COUNT (math "$year - $birthyear")
set COUNTORD (ord "$COUNT")
set DAY (string trim -l -c '0' $day)

set DATE "The $DAY$DATEORD of $MONTH of $year"
set DATELEN (string length "$DATE")
set DATEPAD (repeat (math "floor(($WIDTH - $DATELEN)/2)") " ")

set tmp (mktemp)
begin
echo 'Date: '(date -R)
echo 'From: juan <juan@juanmeleiro.mat.br>'
echo 'To: <agora-official@agoranomic.org>'
echo 'Subject: [Registrar] Birthday Announcement'
m4 --define=DATE="$DATEPAD$DATE" \
   --define=PLAYER="$name" \
   --define=COUNT="$COUNT$COUNTORD" \
   birthdays/template
end > $tmp
neomutt -E -H $tmp
rm $tmp

