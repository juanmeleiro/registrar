local path = require "path"

function die(err, msg)
	msg = tostring(msg or err)
	if err then
		io.stderr:write(msg .. "\n")
		os.exit(1)
	end
end

function yn(prompt)
	local meaning = {
		Y = true,
		y = true,
		yes = true,
		Yes = true,
		n = false,
		N = false,
		No = false,
		no = false
	}
	local ans
	while meaning[ans] == nil do
		io.write(prompt)
		io.flush() -- For some reason, prompt doesn't show up without this
		ans = io.read()
	end
	return meaning[ans]
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

function table.query(t, q)
   for _,i in ipairs(t) do
	  if q(i) then
		 return i
	  end
   end
   return nil
end

function table.filter(t, q)
	local res = {}
	for _,i in ipairs(t) do
		if q(i) then
			table.insert(res, i)
		end
	end
	return res
end

function format_event(e)
	local formats = {
		deactivation = "Deactivated {who}",
		deregister = "Deregistered {who}",
		monthly = "Monthly report",
		readdress = "Changed {who}'s address",
		register = "Registered {who}",
		rename = "Changed {whither}'s name from '{who}'",
		weekly = "Weekly report",
		activation = "Activated {who}",
		writ = "Writ of FAGE for {who}"
	}
	die(not formats[e.what], string.format("No format for '%s'", e.what))
	return string.format("* %s %s\n",
		os.date("%Y-%m-%d %H:%M", e.when),
		format(formats[e.what], e)
	)
end

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

function jsonformat(fn)
	os.execute(string.format('jq --sort-keys . %s > .tmp', fn))
	os.execute(string.format('mv .tmp %s', fn))
end
