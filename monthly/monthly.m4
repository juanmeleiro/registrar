define(dhl, `===============================================================================')dnl
define(shl, `-------------------------------------------------------------------------------
')dnl
define(module, shl`$1

include($2)')dnl
dhl
`Registrar: juan              Arrivals and Departures                 'esyscmd(date +%Y-%m-%d | tr -d '\n')
dhl

module(NEWS, monthly/news.m4)
module(EDITORIAL, monthly/editorial.m4)
module(WRITS OF FAGE, monthly/writs.m4)
module(HISTORY, monthly/history.m4)
dhl
