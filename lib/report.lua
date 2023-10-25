require "lib.utils"

local _M = {}

local fns = {
	tmp = ".tmp",
	history = ".hist"
}

function _M.weekly(args, players, log)
	defs = {
		YEAR = os.date("%Y"),
		MONTH = os.date("%m"),
		DAY = os.date("%d"),
		MAILDATE = os.date("%a, %d %b %Y %T %z"),
	}

	os.execute(string.format("m4 %s templates/weekly/weekly.m4 > %s", m4flags(defs), fns.tmp))
	if args.p then
		os.execute(string.format("cat %s", fns.tmp))
		os.remove(fns.tmp)
	else
		os.execute(string.format("vis %s", fns.tmp))
		os.execute(string.format("neomutt -H %s -E", fns.tmp))
		if yn("Archive report? [Yn] ") then
			table.insert(log, {
							 when = os.time(),
							 what = "weekly",
							 height = height,
			})
			os.rename(fns.tmp, os.date("archive/%F-weekly.txt"))
		else
			os.remove(fns.tmp)
		end
	end
end

function _M.monthly(args, players, log)
	local hist = io.open(fns.history, "w")

	defs = {
		YEAR = os.date("%Y"),
		MONTH = os.date("%m"),
		DAY = os.date("%d"),
		MAILDATE = os.date("%a, %d %b %Y %T %z"),
		PLAYERS = string.format("include(%s)", fns.history)
	}
	for n,h in pairs(players) do
		hist:write("===============\n"..n.."\n")
		for _,e in ipairs(h) do
			if e.reason == "s" then
				f = "  ({reason}) {name} <{contact}> ({registration}--now)\n"
			else
				f = "  ({reason}) {name} <{contact}> ({registration}--{deregistration})\n"
			end
			hist:write(format(f, e))
			if e.observations then
				hist:write(format("      {observations}\n", e))
			end
		end
		hist:write("\n")
	end
	hist:close()

	os.execute(string.format("m4 %s templates/monthly/monthly.m4 > %s", m4flags(defs), fns.tmp))

	if args.p then
		os.execute(string.format("cat %s", fns.tmp))
		os.remove(fns.tmp)
	else
		os.execute(string.format("vis %s", fns.tmp))
		os.execute(string.format("neomutt -H %s -E", fns.tmp))
		if yn("Archive report? [Yn] ") then
			table.insert(log, {
							 when = os.time(),
							 what = "monthly"
			})
			os.rename(fns.tmp, os.date("archive/%F-monthly.txt"))
		else
			os.remove(fns.tmp)
		end
	end
	os.remove(fns.history)
end

return _M
