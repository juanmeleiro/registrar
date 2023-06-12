#!/usr/bin/fish

argparse 'h/help' -- $argv

function usage
	echo 'usage: ./registrar.fish COMMAND'
	echo 'commands:'
	echo '    weekly'
	echo '    monthly'
	echo '    birthday'
end

function guessmonthly
	# No monthly published this month
	set cur_month (date +%Y-%m)
	grep -q "\[$cur_month-..\] Published monthly report." log.txt
	or echo monthly
end

function guessweekly
	test (date +%u) = 1
	and set reference (date -d '00:00' +%s)
	or set reference (date -d 'last monday' +%s)
	grep "\[....-..-..\] Published weekly report." log.txt |
	grep -o "\[....-..-..\]" |
	grep -o "....-..-.." |
	while read d
		set candidate (date -d $d +%s)
		test $candidate -ge $reference
		and return
	end
	echo weekly
end

function guess
	guessmonthly
	guessweekly
	# guessbirthday
end

test "$argv[1]" = guess -o -z "$argv[1]"
and set argv (guess)

for c in $argv
	switch $c
	case weekly
		source 'scripts/weekly.fish'
	case monthly
		source 'scripts/monthly.fish'
	case birthday
		source 'scripts/birthday.fish'
	end
end
