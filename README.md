# The Registrar's Repository

## Repository structure

- `BACKLOG.md`. Notes on things to do to improve this repository and related things.
- `README.md`. This file.
- `archive`. Archive of old files; mainly reports.
- `cantus`. Cantus Cygneus (not complete).
- `fora.json`. Data regarding fora, used by scripts.
- `lib`. Scripts that are called directly or indirectly by the main `registrar` script.
- `log.json`. Record of events.
- `players.json`. Current state of the game, as it relates to the Registrar's duties.
- `registrar`. The main Lua script for performing registrar actions.
- `templates`. Templates used for generating reports and other messages.

## Registrar's obligations/routines

- Weekly report
  - When? Once a week
  - Routine:
    - Generate
    - Send
    - Archive (save copy and record in log)

- Monthly report
  - When? Once a month
  - Routine:
    - Generate
    - Send
    - Archive (save copy and record in log)

- Writs
  - When? When a cantus is received.
  - Routine:
    - Publish writ
    - Record in log and players.json

- Record new players
  - When? When player registers
  - Routine:
    - Record in log and players.json

- Record departing players
  - When? When player deregisters or is deregistered
  - Routine:
    - Record in log and players.json

- Record banned players
  - When? When players are banned
  - Routine:
    - Record in log and players.json

- Deactivate players
  - When? N days after last public message
  - Routine:
    - Record in log and players.json

- Intent to deregister players
  - When? N days after deactivation
  - Routine:
    - Send message putting forth intent
    - Record in log and players.json

- Deregister players
  - When? When intent is ripe and mature
  - Routine:
    - Send message deregistering players
    - Record in log and players.json
