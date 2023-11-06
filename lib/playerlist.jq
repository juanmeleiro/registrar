[
  .[][] |
  select(.reason == "s")
] |
  sort_by(.registration) |
  sort_by(.active | not) |
  .[] |
  "\(if .active then "+" else "-" end)\t\(.name)\t\(.registration)\t\(.latest // "    \"     ")\t\(.contact)"
