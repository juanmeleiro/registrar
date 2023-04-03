define(dhl, `===============================================================================')dnl
define(shl, `-------------------------------------------------------------------------------
')dnl
define(module, shl`$1

include($2)')dnl
dhl
`Registrar: juan              The Agoran Directory                    'esyscmd(date +%Y-%m-%d | tr -d '\n')
dhl

module(NEWS, weekly/news.m4)
module(PLAYERS, weekly/players.m4)
module(FORA, weekly/fora.m4)
module(BANNED PEOPLE, weekly/banned.m4)
module(INTERNAL, weekly/internal.m4)
module(EDITORIAL, weekly/editorial.m4)

dhl
