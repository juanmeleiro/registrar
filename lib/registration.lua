require "lib.utils"
pprint = require "pprint"

_M = {}

reasons = {
	abandoned = "a",
	lawless = "l",
	voluntary = "v",
	deported = "d",
	writ = "w",
	mistake = "k",
	proposal = "p",
	destroyed = "e",
	ratification = "r",
	uknown = "u",
	exiled = "x",
	banned = "b"
}

function _M.deregister(args, players, log)
   p = players[args.name]
   if not p then
	  die(string.format("There's no player '%s'.", args.name))
   end

   h = table.query(p.history, function (c) return c.reason == "s" end)

   if not h then
	  die(string.format("Player '%s' is not registered.", args.name))
   end

   ev = {when = args.date,
		 what = "deregister",
		 who = args.name,
		 where = args.m}

   if not args.p then
	   h.active = nil
	   h.deregistration = os.date("%Y-%m-%d", args.date)
	   h.reason = reasons[args.reason]
	   h.latest = nil
	   io.write(string.format("Please remember to delete any reminders of %s's birthday.\n", args.name))

	   table.insert(log, ev)
   else
	   io.write(string.format("Deregister player %s.\n", args.name))
	   pprint.pprint(ev)
	   pprint.pprint(h)
	   io.write("active := nil\n")
	   io.write("latest := d\n")
	   io.write(string.format("deregistration := %s\n", os.date("%Y-%m-%d", args.date)))
	   io.write("reason := a\n")
   end
end

function _M.register(args, players, log, ts)
	local birthday = nil
	local exists = nil
	-- Check if player name exists
	for p, h in pairs(players) do
		if table.query(h.history, function (x) return x.name == args.name end) then
			exists = p
			if table.query(h.history, function (x) return x.reason == "s" end) then
				die(string.format("Error: player '%s' exists and is registered.", p))
			end
			break
		end
	end
	if exists then
		if yn(string.format("Player exists under name '%s'. Proceed? [yn] ", exists)) and not args.p then
			-- Change registration name if different
			if args.name ~= exists then
			  players[args.name] = players[exists]
			  players[exists] = nil
			end
			-- Query player's birthday
			birthday = players[args.name].history[1].registration
			for _,h in ipairs(players[args.name].history) do
				if birthday > h.registration then
					birthday = h.registration
				end
			end
		end
	else
		players[args.name] = { history = {} }
		birthday = os.date("%Y-%m-%d", args.date)
	end
	local reg = {
		name = args.name,
		registration = os.date("%Y-%m-%d", args.date),
		active = true,
		reason = "s",
		contact = args.contact,
		latest = os.date("%Y-%m-%d", args.date)
	}
	local ev = {
		what = "register",
		who = args.name,
		when = args.date,
		where = args.m,
		whence = args.contact
	}
	local msg = string.format("Please remember to set a reminder for this player's Agoran birthday! Eir first registration was on %s\n", birthday)
	if not args.p then
		table.insert(players[args.name].history, reg)
		table.insert(log, ev)
		io.write(msg)
	else
		io.write(pprint.pprint(reg))
		io.write(pprint.pprint(ev))
	end
end

function _M.rename(args, players, log)
	die(not players[args.who], string.format("No player '%s'.", args.who))
	local h = table.query(players[args.who].history, function (h) return h.reason == "s" end)
	die(not h, "Player is not registered.")
	h.name = args.whither
	players[args.whither] = players[args.who]
	players[args.who] = nil
	table.insert(log, {what="rename", who=args.who, whither=args.whither, where=args.m, when=os.time()})
end

function _M.readdress(args, players, log)
	die(not players[args.who], string.format("No player '%s'.", args.who))
	local h = table.query(players[args.who].history, function (h) return h.reason == "s" end)
	if h then
		h.contact = args.whither
	else
		players[args.who].contact = args.whither
	end
	table.insert(log, {what="readdress", who=args.who, whither=args.whither, where=args.m, when=args.when})
end

_M.reasons = {}
for k,_ in pairs(reasons) do
	table.insert(_M.reasons, k)
end

return _M
