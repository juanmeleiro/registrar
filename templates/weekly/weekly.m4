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

module(NEWS, templates/weekly/news.m4)
module(PLAYERS, templates/weekly/players.m4)
module(FORA, templates/weekly/fora.m4)
module(BANNED PEOPLE, templates/weekly/banned.m4)
module(INTERNAL, templates/weekly/internal.m4)
module(EDITORIAL, templates/weekly/editorial.m4)

dhl
