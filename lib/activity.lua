require "lib.utils"
local pprint = require "pprint"

local _M = {}

function _M.activate(args, players, log)
	die(not players[args.name], string.format("No player %s", args.name))
	local h = table.query(players[args.name].history, function (h) return h.reason == "s" end)
	die(h.active, "Player is already active.")
	h.active = true
	h.latest = os.date("%Y-%m-%d", args.when)
	die(not h, "Player is not active.")
	table.insert(log, {
					 what = "activation",
					 who = args.name,
					 when = args.when,
					 where = args.where
	})
end

function _M.deactivate(args, players, log)
	die(not players[args.name], string.format("No player %s", args.name))
	local h = table.query(players[args.name].history, function (h) return h.active end)
	pprint.pprint(h)
	die(not h, "Player is not registered.")
	die(not h.active, "Player is already inactive.")
	h.active = false
	h.latest = os.date("%Y-%m-%d", args.when)
	table.insert(log, {
					 what = "deactivation",
					 who = args.name,
					 when = args.when,
					 where = args.where
	})
end

return _M
