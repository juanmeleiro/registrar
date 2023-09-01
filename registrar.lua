#!/usr/bin/lua5.4
local argparse = require "argparse"
local json = require "json"
local path = require "path"
-- local fs = require "path.fs"

function die(err, msg)
   msg = tostring(msg or err)
   if err then
      io.stderr:write(msg .. "\n")
      os.exit(1)
   end
end

function yn(prompt)
	meaning = {Y = true, y = true, n = false, N = false}
	while meaning[ans] == nil do
		io.write(prompt)
		io.flush() -- For some reason, prompt doesn't show up without this
		ans = io.read(1)
	end
	return ans
end

function decodewith(decoder, fn)
   die(not path.exists(fn), fn.." does not exist.")
   die(not path.isfile(fn), fn.." is not a file.")
   local f, err = io.open(fn, "r")
   die(err)
   status, res = xpcall(decoder, die, f:read("a"))
   f:close()
   die(not status, res)
   return res
end

function encodewith(encoder, fn, data)
   local f, err = io.open(fn, "w")
   die(not status, err)
   status, err = f:write(encoder(data))
   die(not status, err)
end

function format(fmt, dict, sett)
   -- A identifier is
   -- > any string of Latin letters, Arabic-Indic digits, and
   -- > underscores, not beginning with a digit and not being a reserved
   -- > word
   res = fmt
   for s in string.gmatch(fmt, "%{([_a-zA-Z][._a-zA-Z0-9]*)%}") do
      local value = dict
      local pref = sett
      for k in string.gmatch(s, "([_a-zA-Z][_a-zA-Z0-9]*)") do
	 if type(value) == "table" then value = value[k] end
	 if type(pref) == "table" then pref = pref[k] end
      end
      if pref and value then string.format(pref, value) end
      res = fmt.gsub(res, "{"..s.."}", value or "nil")
   end
   return res
end

function m4flags(d)
   flags = ""
   for k, v in pairs(d) do
	  flags = flags .. string.format(" -D %s='%s'", k, v)
   end
   return flags
end

local parser = argparse("registrar", "Manage Agora's registrar duties")
   :command_target("command")

parser:command("monthly", "Generate and send registrar monthly report")
   :flag("-p", "Pretent: generate and print only.")
parser:command("weekly", "Generate and send registrar weekly report")
   :flag("-p", "Pretent: generate and print only.")

local birthday_cmd = parser:command("birthday", "Announce a player's birthday")
birthday_cmd:flag("-p", "Pretent: generate and print only.")
birthday_cmd:argument("name", "The name of the player")

parser:command("register", "Register player")
parser:command("deregister", "Deregister player")
parser:command("activate", "Activate player")
parser:command("deactivate", "Deactivate player")
parser:command("rename", "Rename player")
parser:command("readdress", "Change player's address")

-- Deserialize
local fns = {
   players = "players.json",
   log = "log.json",
   tmp = ".tmp",
   history = ".hist"
}
local args = parser:parse()
local players = decodewith(json.decode, fns.players)

-- Process

if args.command == "monthly" then
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

   os.execute(string.format("m4 %s monthly/monthly.m4 > %s", m4flags(defs), fns.tmp))

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
		 os.rename(tmpname, os.date("archive/%F-monthly.txt"))
	  else
		 os.remove(fns.tmp)
	  end
   end
   os.remove(fns.history)
elseif args.command == "weekly" then
   defs = {
	  YEAR = os.date("%Y"),
	  MONTH = os.date("%m"),
	  DAY = os.date("%d"),
	  MAILDATE = os.date("%a, %d %b %Y %T %z"),
   }

   os.execute(string.format("m4 %s weekly/weekly.m4 > %s", m4flags(defs), fns.tmp))
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
		 os.rename(tmpname, os.date("archive/%F-weekly.txt"))
	  else
		 os.remove(fns.tmp)
	  end
   end
   os.remove(fns.history)
elseif args.command == "birthday" then
   io.write("Birthdays not implemented. Use registrar.fish\n")
else
   io.write("Not implemented.")
end

-- Serialize
encodewith(json.encode, fns.players, players)
encodewith(json.encode, fns.log, log)
