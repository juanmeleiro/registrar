# The Registrar's Repository

## Instructions for a new Registrar

- Get familiarized with this repository (a description of the structure can be found later in this document).

- Install dependencies:
  - Lua 5.4, as it is required to run the `registrar` script.
  - jq
  - m4

- Ensure you are able to read Message IDs for emails in your client.

- Setup weekly reminder for weekly report in whatever organizational
  system you use. Any date is fine, but the deadline is always the end of
  UTC sunday of that week.

  - Upon reminder, perform the relevant checklist.

- Setup monthly reminder for monthly report in whatever organizational
  system you use. Any date is fine, but the deadline is always the end of
  the last day of that month.

  - Upon reminder, perform the relevant checklist.

- Setup yearly reminders for announcing the birthdays of every active
  player.

  - Upon reminder, perform the relevant checklist.

- Continuously monitor the public fora for the following events:

  - Registration
    - Messages where a person declares their intent to register (R869)
  - Cantus Cygnei
    - Messages clearly labeled as a Cantus Cygneus (R1789)
  - Deregistration
    - Messages where a player voluntarily deregisters (R869)
    - Messages where an inactive player is deregistered without 3 objections (R2646)
    - Messages where a player is banned (R2679)
    - Messages where a player is exiled (R2556)
  - Deactivation
    - Messages where a player is deactivated (R2646)
  - Reactivation
    - Messages where a player reactivates emself (R2646)
  - Changes
    - Messages in which pertinent rules are changed.

  In case of any of these events, perform the relevant checklist.

- Optinally, setup some way to keep track of player activity, for the
  purposes of inactivating them. If you find a good procedure, update
  this documentation and create the relevant checklists. For now, I
  (juan) am leaving this to other players.

- After any modification, you may run `./registrar check` to check the
  integrity of this repository. This is not comprehensive, but it's an aid.

## Repository structure

- `BACKLOG.md`. Notes on things to do to improve this repository and related things.
- `README.md`. This file.
- `archive`. Archive of old files; mainly reports.
- `checklists`. Checklists for various Registrar routines.
- `cantus`. Cantus Cygneus (not complete).
- `fora.json`. Data regarding fora, used by scripts.
- `lib`. Scripts that are called directly or indirectly by the main `registrar` script.
- `log.json`. Record of events.
- `players.json`. Current state of the game, as it relates to the Registrar's duties.
- `registrar`. The main Lua script for performing registrar actions.
- `templates`. Templates used for generating reports and other messages.


