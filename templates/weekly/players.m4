Active players: esyscmd(jq -r '[.[].history[] | select(.reason == "s")] | "\([.[] | select(.active == true)] | length)/\(length)"' players.json)dnl

esyscmd(lib/playerlist.sh)dnl

Conventions:
* Player: Latest player name.
* Registered: Date of latest registration.
* Latest: Date of latest change in Activity.
* Contact: Email address or URI for eir prefered contact method

Legend for symbols:
a Activity
+ Active
- Inactive
" Same value as cell to the left

