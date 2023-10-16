define(WIDTH, esyscmd(jq -r '.[][] | select(.reason == "w") | "\(.name)"' players.json | wc -L | tr -d '\n'))
define(`complete', `ifelse(eval(len(`$1') < $3), `1', `$1'repeat(eval(`$3' - len(`$1')), `$2'), `$1')')dnl
define(`repeat', `ifelse(eval($1 > 0), `1', `$2repeat(decr($1), `$2', BLAH)')')dnl
complete(`PLAYER', ` ', eval(WIDTH + 2))DATE
repeat(WIDTH, `-')  ----------
esyscmd(jq -r '([.[][] | select(.reason == "w")] | sort_by(.deregistration))[] | "\(.name)\t\(.deregistration)"' players.json | column -t)
