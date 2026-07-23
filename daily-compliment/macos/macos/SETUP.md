# macOS delivery kit

Turns the skill into a real daily ritual: once a day, at a time you pick, macOS
generates a fresh compliment and shows it in a small pop-up.

## Why a dialog pop-up (not a notification banner)?

A notification banner needs the sending app to be registered and *allowed* in
System Settings → Notifications, and on many Macs that grant is fiddly or silently
fails. A dialog window always appears. For a once-a-day, one-sentence compliment, a
small window you dismiss with one click is the reliable choice.

## Why a little `Compliment.app`?

The dialog is shown by **`Compliment.app`** — a tiny standalone, ad-hoc
code-signed app that `install-daily.sh` builds for you from
`compliment-dialog.applescript`. This is deliberate:

If the launchd job called `osascript` directly (bash → osascript → dialog), macOS
attributes the request to bare `/bin/bash`, which has **no stable app identity** —
so macOS can't remember your "Allow" and **re-prompts for permission every single
day**. A signed app *does* have a stable identity, so you grant it **once** (if at
all) and it never nags again. The compliment text is passed to the app through
`~/.daily-compliment/today.txt`, which `show-compliment.sh` writes just before
launch.

You may see **one** permission prompt for "Compliment" the first time it runs —
click **Allow**, and that's the last of it.

## Requirements

- macOS
- The [`claude` CLI](https://docs.claude.com/claude-code) installed and logged in
  (the daily job calls it to write each compliment)
- This skill installed in your Claude environment

## Install

The skill does this for you: when you first ask for a compliment it offers to make
it daily and asks what time you want it, then runs the installer with that time.

To do it by hand instead:

```bash
# from this macos/ folder — 24-hour time, e.g. 9am:
./install-daily.sh 09:00
```

That writes a `launchd` agent (`~/Library/LaunchAgents/com.user.daily-compliment.plist`)
and starts it. Your Mac must be awake at that time; if it's asleep, it runs at the
next wake.

## Test it right now

```bash
./show-compliment.sh
```

You should get the pop-up within a few seconds. (If the `claude` CLI isn't found,
you'll still get a friendly fallback line, which confirms the pop-up works.)

## Change the time

Re-run the installer with a new time — it replaces the old schedule:

```bash
./install-daily.sh 21:30
```

## Stop it

```bash
./uninstall-daily.sh
```

## Troubleshooting

- **No pop-up on schedule but `./show-compliment.sh` works** — the agent may not be
  loaded. Re-run `./install-daily.sh HH:MM`.
- **Blank/fallback compliment** — the `claude` CLI wasn't found from the launchd
  environment. Confirm `which claude` works, and that its folder is on the `PATH`
  line at the top of `show-compliment.sh`.
- **It keeps asking for permission every day** — this means the signed
  `Compliment.app` wasn't built (the daily job fell back to a raw `osascript`
  dialog, which can't hold a permission grant). Re-run `./install-daily.sh HH:MM`
  and confirm `Compliment.app` now sits next to the scripts in this `macos/`
  folder. If it still re-prompts, your Mac isn't honoring the ad-hoc signature —
  sign it with a free local identity instead of ad-hoc.
- **Logs** — check `/tmp/daily-compliment.log` and `/tmp/daily-compliment.err`.
