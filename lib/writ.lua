require "lib.utils"

local fns = {
	tmp = ".tmp"
}

function cantus(args, players, log)
	if not (players[args.who]) then
		die("No such player.")
	end

	h = table.query(p.history, function (c) return c.active end)

	if not h then
		die(string.format("Player '%s' is not active.", args.name))
	end

	local monthname = os.date("%B", args.when)
	local dayord = ord(tonumber(os.date("%d", args.when)))
	local day = os.date("%d", args.when)
	local datestring = string.format("The %s%s of %s of %d", day, dayord, monthname, os.date("%Y", args.when))
	local datepad = (string.rep(" ", (80 - string.len(datestring))//2))
	local namepad = (string.rep(" ", (80 - string.len(args.who))//2))

	local defs = {
		MAILDATE = os.date("%a, %d %b %Y %T %z"),
		NAME = namepad .. args.who,
		DATE = datepad .. datestring,
		FILEPATH = args.cantus,
		FULLTEXT = string.format("include(%s)", FILEPATH)
	}

	os.execute(string.format("m4 %s templates/writ.m4 > %s", m4flags(defs), fns.tmp))


	if args.p then
		os.execute(string.format("cat %s", fns.tmp))
		os.remove(fns.tmp)
		io.write(string.format("Deregister player %s.\n", args.name))
		pprint.pprint(h)
		io.write("active := nil\n")
		io.write("latest := nil\n")
		io.write(string.format("deregistration := %s\n", os.date("%Y-%m-%d")))
		io.write("reason := w\n")
	else
		os.execute(string.format("neomutt -H %s -E", fns.tmp))
		local archive_name = os.date("archive/%F-writ-") .. args.who .. ".txt"
		if yn(string.format("Archive report to '%s'? [Yn] ", archive_name)) then
			os.rename(fns.tmp, archive_name)
			table.insert(log, {what = "writ", who = args.who, when = args.when, where = args.m})
			h.active = nil
			h.deregistration = os.date("%Y-%m-%d")
			h.reason = "w"
			h.latest = nil
		else
			os.remove(fns.tmp)
		end
	end
end

return cantus
