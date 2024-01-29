require "lib.utils"
pprint = require "pprint"

local fns = {
	tmp = ".tmp"
}

function ord(num)
	if (num == 1) then
		return "st"
	elseif (num == 2) then
		return "nd"
	elseif (num == 3) then
		return "rd"
	else
		return "th"
	end
end

function announce(args, date, original)
	local time = {
		year = tonumber(string.sub(date, 1, 4)),
		month = tonumber(string.sub(date, 6, 7)),
		day = tonumber(string.sub(date, 9, 10))
	}
	local monthname = os.date("%B", os.time(time))
	local dayord = ord(time.day)
	local count = tostring(time.year - tonumber(string.sub(original, 1, 4)))
	local countord = ord(count)
	local day = tostring(time.day)
	local datestring = string.format("The %s%s of %s of %d", day, dayord, monthname, time.year)
	local datepad = (string.rep(" ", (80 - string.len(datestring))//2))

	defs = {
		MAILDATE = os.date("%a, %d %b %Y %T %z"),
		DATE = datepad .. datestring,
		PLAYER = args.name,
		COUNT = count .. countord
	}

	os.execute(string.format("m4 %s templates/birthday.m4 > %s", m4flags(defs), fns.tmp))
	if args.p then
		os.execute(string.format("cat %s", fns.tmp))
	else
		os.execute(string.format("neomutt -H %s -E", fns.tmp))
	end
	os.remove(fns.tmp)
end

function birthday(args, players, log)
	if not (players[args.name]) then
		die("No such player.")
	end

	local original = "xxxx-xx-xx"
	for _,e in ipairs(players[args.name].history) do
		original = math.min(original, e.registration)
	end

	local this_birthday = os.date("%Y") .. "-" .. string.sub(original, 6)
	local prev_birthday = tostring(tonumber(os.date("%Y")) - 1) .. "-" .. string.sub(original, 6)
	local today = os.date("%Y-%m-%d")

	if (this_birthday <= today) then
		announce(args, this_birthday, original)
	else
		announce(args, prev_birthday, original)
	end
end

return birthday
