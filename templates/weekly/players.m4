Active players: esyscmd(jq -r '[.[][] | select(.reason == "s")] | "\([.[] | select(.active == true)] | length)/\(length)"' players.json)dnl

esyscmd(jq -r '[.[][] | select(.reason == "s")] | sort_by(.active | not)[] | "\(if .active then "+" else "-" end)\t\(.name)\t\(.registration)\t\(.latest // "    \"     ")\t\(.contact)"' players.json | columnate -n a Player Registration Latest Contact)dnl

WARNING: Player name “blob” refers to the currently registered one,
who became a player on 2023-05-18, and not blob the player from many
years ago. They are different people, to the best of my judgment. This
warning will remain necessary pending decision on how to handle clashing
player names. Do not complain; comply.

Conventions:
* Player: Latest player name.
* Registered: Date of latest registration.
* Latest: Date of latest change in Activity.
* Contact: URI for eir prefered contact method

Legend for symbols:
a Activity
+ Active
- Inactive
" Same value as cell to the left

