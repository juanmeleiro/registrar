#!/usr/bin/fish

argparse 'h/help' -- $argv

function usage
	echo 'usage: ./registrar.fish COMMAND'
	echo 'commands:'
	echo '    birthday'
end

test "$argv[1]" = guess -o -z "$argv[1]"
and set argv (guess)

for c in $argv
	switch $c
	case birthday
		source 'scripts/birthday.fish'
	end
end
