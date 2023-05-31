json = require "json"
fn = "players.json"

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

reasons = {
  a = "Abandoned",
  l = "Lawless",
  v = "Voluntary",
  d = "Deported",
  w = "Writ of FAGE",
  p = "Proposal",
  r = "Ratification",
  u = "Uknown",
  s = "Still registered",
  b = "Banned",
  k = "Deregistered emself by mista(k)e",
  e = "Destroyed",
  x = "Exiled"
}

EVENT_FORMAT = "  %s %s => %s\n"
CONTACT_FORMAT = "  aka %s <%s>\n"

for n,h in pairs(players) do
	io.write("===============\n"..n.."\n")
	for _,e in ipairs(h) do
		io.write(string.format("  %s <%s> (%s--%s; %s)\n",
		                       e.name,
		                       e.contact,
		                       e.registration,
		                       e.deregistration or "now",
		                       reasons[e.reason]))
	end
	io.write("\n")
end

