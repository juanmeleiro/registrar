define(dhl, `===============================================================================')dnl
define(shl, `-------------------------------------------------------------------------------
')dnl
define(module, shl`$1

include($2)')dnl
Date: MAILDATE
`To: <agora-official@agoranomic.org>'
`Subject: [Registrar] Monthly report: Arrivals and Departures'
dhl
`Registrar: juan              Arrivals and Departures                 'YEAR-MONTH-DAY
dhl

module(EVENTS, templates/monthly/events.m4)
module(EDITORIAL, templates/monthly/editorial.m4)
module(WRITS OF FAGE, templates/monthly/writs.m4)
module(HISTORY, templates/monthly/history.m4)
dhl
