require "lib.utils"

local _M = {}

local fns = {
	tmp = ".tmp",
	history = ".hist",
	changes = ".changes"
}

function sincelast(log, what)
	local all = table.filter(log, function (e) return e.what == what end)
	table.sort(all, function (e0, e1) return e0.when > e1.when end)
	local last = all[1].when
	local since = table.filter(log, function (e) return e.when >= last end)
	return since
end

function format_events(f, es)
	for _,e in ipairs(es) do
		f:write(format_event(e))
	end
end

function _M.weekly(args, players, log)
	defs = {
		YEAR = os.date("%Y"),
		MONTH = os.date("%m"),
		DAY = os.date("%d"),
		MAILDATE = os.date("%a, %d %b %Y %T %z"),
		CHANGES = string.format("include(%s)", fns.changes)
	}

	local changes = io.open(fns.changes, "w")
	format_events(changes, sincelast(log, "weekly"))
	changes:close()

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

	defs = {
		YEAR = os.date("%Y"),
		MONTH = os.date("%m"),
		DAY = os.date("%d"),
		MAILDATE = os.date("%a, %d %b %Y %T %z"),
		PLAYERS = string.format("include(%s)", fns.history),
		CHANGES = string.format("include(%s)", fns.changes)
	}

	local hist = io.open(fns.history, "w")
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

	local changes = io.open(fns.changes, "w")
	format_events(changes, sincelast(log, "monthly"))
	changes:close()

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
	os.remove(fns.changes)
end

return _M
