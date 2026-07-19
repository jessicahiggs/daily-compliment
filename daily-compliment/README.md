# Daily Compliment

A Claude skill that writes you one short, genuine, one-sentence compliment — grounded in your own conversation history with Claude, not generic flattery.

Made by [jessicahiggs](https://github.com/jessicahiggs).

## What it does

Looks at what you've actually talked to Claude about (this conversation, and past ones/projects where your environment gives Claude access to them) and notices something real: something you mentioned being stressed or insecure about, or something you're proud of or put effort into. It reflects that back as one warm, unambiguously positive sentence — not a status report on your output, an actual compliment.

If there's nothing specific to draw on, it still gives you a sincere, generic compliment rather than saying it came up empty.

If it notices something that looks like more than everyday stress (signs of a real crisis), it won't paper over that with a cheerful line — instead it gently suggests reaching out to someone you trust or a professional.

## Install

1. Download `daily-compliment.skill` (or clone this repo).
2. Install it into your Claude environment (Claude Code, Cowork, etc.) — how you do this depends on your platform's skill-install flow.

## Use

Just ask for a compliment, encouragement, or a pick-me-up, and this skill triggers automatically.

The first time you run it, it'll offer to make it a daily ritual: it **asks what time you want your compliment**, then schedules it right then. On macOS it's delivered as a small pop-up (see below), so it isn't just a one-off.

## Daily delivery on macOS

This repo includes a [`macos/`](macos/) kit that pops your compliment up once a day at the time you chose, using a `launchd` job. It uses a dialog pop-up rather than a notification banner on purpose — a banner needs a notification permission that's unreliable to grant, while a dialog needs none and always appears. The skill sets this up for you when you pick a time; to install, change the time, or turn it off by hand, see [`macos/SETUP.md`](macos/SETUP.md).

## Privacy

Read-only. It only uses conversation/project data Claude already has access to in your environment — it never opens other apps, never touches your screen, and never reaches into any account outside of Claude. Nothing extra gets saved.

## License

MIT
