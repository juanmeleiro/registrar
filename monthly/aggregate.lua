json = require "json"

function split(inputstr, sep)
	sep=sep or '%s' local t={}
	for field,s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do
		table.insert(t,field)
		if s == "" then
			return t
		end
	end
end

--------------------------------------------------------------------------------
-- Parse history.tsv

local fn = "history.tsv"
local f = io.open(fn)
local head = f:read()
local headers = {}
for h in string.gmatch(head, "[^\t]*") do
	table.insert(headers, h)
end
local lines = f:lines()
local history = {}
local names = {}
for line in lines do
	table.insert(history, {})
	i = 1
	for value in string.gmatch(line, "[^\t]*") do
		history[#history][headers[i]] = value
		if headers[i] == "name" then table.insert(names, value) end
		i = i + 1
	end
end

--------------------------------------------------------------------------------
-- Aggregate history

local players = {}
for i,h in ipairs(history) do
	if h.name then
		players[h.name] = players[h.name] or {}
		table.insert(players[h.name], h)
	end
end

--------------------------------------------------------------------------------
-- Merge based on aliases

fn = "merges"
f = io.open(fn)
lines = f:lines()
aliases = {}

for l in lines do
	table.insert(aliases, {})
	for value in string.gmatch(l, "[^\t]+") do
		table.insert(aliases[#aliases], value)
	end
end

for _,a in ipairs(aliases) do
	for i = 2, #(a) do
		if players[a[i]] then
			for _,ev in ipairs(players[a[i]]) do
				table.insert(players[a[1]], ev)
			end
			players[a[i]] = nil
		end
	end
end

--------------------------------------------------------------------------------
-- Update keys to latest

for n,h in pairs(players) do
	latest_name = n
	latest_registration = ""
	for _,e in ipairs(h) do
		if e.registration and e.registration > latest_registration then
			latest_name = e.name
			latest_registration = e.registration
		end
	end
	players[n] = nil
	players[latest_name] = h
end

newnames = {}
for n,h in pairs(players) do
	for _,e in ipairs(h) do
		newnames[e.name] = true
	end
end
for _,n in ipairs(names) do
	if not newnames[n] then
		print(n, "is missing!")
		return 1
	end
end

io.write(json.encode(players))

