#!/bin/sh
jq -r -f lib/playerlist.jq players.json | columnate -n a Player Registration Latest Contact
