define(dhl, `===============================================================================')dnl
define(shl, `-------------------------------------------------------------------------------
')dnl
define(module, shl`$1

include($2)')dnl
Date: MAILDATE
`To: <agora-official@agoranomic.org>'
`From: juan <juan@juanmeleiro.mat.br>'
`Subject: [Registrar] Weekly report' 
dhl
`Registrar: juan              The Agoran Directory                    'YEAR-MONTH-DAY
dhl

module(NEWS, weekly/news.m4)
module(PLAYERS, weekly/players.m4)
module(FORA, weekly/fora.m4)
module(BANNED PEOPLE, weekly/banned.m4)
module(INTERNAL, weekly/internal.m4)
module(EDITORIAL, weekly/editorial.m4)

dhl
