json = require "json"
fn = "monthly/players.json"

f = io.open(fn, "r")
j = f:read("*all")
players = json.decode(j)
f:close()

-- x reason
--   name
--   contact
-- x registration
-- x deregistration
--   observations

EVENT_FORMAT = "  %s %s => %s\n"
CONTACT_FORMAT = "  aka %s <%s>\n"

function format(s, d)
	res = s
	for k in string.gmatch(s, "{([^{}|]+)}") do
		if d[k] then
			res = string.gsub(res, "{"..k.."}", d[k])
		else
			res = string.gsub(res, "{"..k.."}", "??")
		end
	end
	return res
end

for n,h in pairs(players) do
	io.write("===============\n"..n.."\n")
	for _,e in ipairs(h) do
		if e.reason == "s" then
			f = "  ({reason}) {name} <{contact}> ({registration}--now)\n"
		else
			f = "  ({reason}) {name} <{contact}> ({registration}--{deregistration})\n"
		end
		io.write(format(f, e))
		if e.observations then
			io.write(format("      {observations}\n", e))
		end
		-- io.write(string.format("  (%s) %s <%s> (%s--%s)\n",
		--                        e.reason,
		--                        e.name,
		--                        e.contact,
		--                        e.registration,
		--                        e.deregistration or "now"))
	end
	io.write("\n")
end

