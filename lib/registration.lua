require "lib.utils"
pprint = require "pprint"

_M = {}

function _M.deregister(args, players, log)
   p = players[args.name]
   if not p then
	  error(string.format("There's no player '%s'.", args.name))
   end

   h = table.query(p, function (c) return c.active end)

   if not h then
	  error(string.format("Player '%s' is not active.", args.name))
   end

   ev = {when = args.date,
		 what = "deregister",
		 who = args.name,
		 where = args.m}

   if not args.p then
	   h.active = nil
	   h.deregistration = os.date("%Y-%m-%d", args.date)
	   h.reason = "d"
	   h.latest = nil

	   table.insert(log, ev)
   else
	   io.write(string.format("Deregister player %s.\n", args.name))
	   pprint.pprint(ev)
	   pprint.pprint(h)
	   io.write("active := nil\n")
	   io.write("latest := d\n")
	   io.write(string.format("deregistration := %s\n", os.date("%Y-%m-%d", args.date)))
	   io.write("reason := d\n")
   end
end

function _M.register(args, players, log, ts)
	return
end

return _M
