# Daily Compliment

A Claude skill that writes you one short, genuine, one-sentence compliment — grounded in your own conversation history with Claude, not generic flattery. On macOS it can also pop up automatically once a day at a time you choose.

Made by [jessicahiggs](https://github.com/jessicahiggs).

## What it looks like

Once a day, at the time you pick, your compliment quietly appears as a pop-up:

<img width="418" height="135" alt="Daily compliment pop-up" src="https://github.com/user-attachments/assets/1e0fdc13-f5af-40b8-985b-1950342af1e9" />


<img width="927" height="479" alt="Compliment app screenshot" src="https://github.com/user-attachments/assets/af7aefd6-b7c3-480b-b2e7-e69abaf20438" />


## What it does

Looks at what you've actually talked to Claude about and notices something real — something you mentioned being stressed or insecure about, or something you're proud of or put effort into — and reflects it back as one warm, unambiguously positive sentence. If there's nothing specific to draw on, it still gives a sincere, generic compliment. If it notices signs of a real crisis, it gently suggests reaching out to someone you trust rather than papering over it.

## Requirements — read this first

This skill can run two ways, and they need different things:

| What you want | What you need |
|---|---|
| **A compliment when you ask for one** | Any Claude that supports skills — **Claude Code**, or a Claude app with skills enabled. |
| **The automatic daily pop-up** | **[Claude Code](https://docs.claude.com/claude-code) installed on a Mac.** Claude Code is Anthropic's command-line tool that runs in your **Terminal** — it is **not** the Claude website or the Claude desktop chat app. |

**⚠️ The daily pop-up does NOT work from the Claude chat app (claude.ai) or the Claude desktop app.** Those can give you a compliment when you *ask*, but they cannot schedule a daily one or show a pop-up on your Mac. The daily compliment is written by the `claude` command running quietly in the background, so that command has to be **installed on your machine**. No Claude Code = no automatic daily version (on-demand still works fine).

## Install (Claude Code on macOS)

1. **Install Claude Code** if you don't have it — follow the [setup guide](https://docs.claude.com/claude-code). Confirm it works by opening Terminal and running:

   ```bash
   claude
   ```

2. **Put this skill in your Claude Code skills folder** so it lives at `~/.claude/skills/daily-compliment/`. Clone the repo straight into place:

   ```bash
   git clone https://github.com/jessicahiggs/daily-compliment.git ~/.claude/skills/daily-compliment
   ```

   (Or download the repo ZIP and copy its contents there, so that the file `~/.claude/skills/daily-compliment/SKILL.md` exists.)

3. **Done.** Claude Code auto-discovers skills in that folder — nothing else to run.

## Use

In Claude Code, just ask for a compliment, encouragement, or a pick-me-up — the skill triggers automatically.

The first time it runs, it offers to make it a **daily ritual**: it asks what time you'd like your compliment, then sets it up. On macOS that installs a small daily pop-up (below).

## Daily pop-up on macOS

The [`macos/`](macos/) folder is the delivery kit. When you pick a time, the skill runs `macos/install-daily.sh`, which:

- builds a tiny **signed helper app** (`Compliment.app`) that shows the pop-up, and
- installs a `launchd` job that, at your chosen time each day, generates a fresh compliment with Claude Code and displays it.

A dialog pop-up is used instead of a notification banner on purpose — a banner needs a notification permission that's unreliable to grant; a dialog needs none. The signed helper app is what stops macOS from asking you for permission every single day.

To install, change the time, or turn it off by hand, see [`macos/SETUP.md`](macos/SETUP.md). Your Mac needs to be awake at the chosen time; if it's asleep, the compliment runs at the next wake.

## Using it in the Claude chat app (claude.ai / desktop)

You can add the skill there for **on-demand** compliments — ask, and you'll get one drawn from your chat history. The **automatic daily pop-up is not available** in the chat app; that's a Claude-Code-on-macOS feature only.

## Privacy

Read-only. It uses only conversation/project data Claude already has access to in your environment — it never opens other apps, never touches your screen, and never reaches into any account outside of Claude. Nothing extra gets saved.

## License

MIT
