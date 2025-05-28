.notes as $notes |
(
	(.fora[] | "------------------------------\n[\(.publicity)] \(.location)\n\n\(.use)\(if .note then "\n\n\(.note)" else "" end)\n"),
	"\($notes)"
)
