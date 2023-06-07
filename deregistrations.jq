[
.[][] |
select((.protected | not)
       and has("active")
       and (.active | not)
       and (.latest |
            strptime("%Y-%m-%d") |
            mktime < (now - 5184000)))
] |
(
"Cc: \([.[] | "\(.contact)" | gsub(" at "; "@") | gsub(" dot "; ".")] | join(", "))\n",
"I intend, without 3 objections, to deregister the following players:\n",
(.[] | "- \(.name)")
)
