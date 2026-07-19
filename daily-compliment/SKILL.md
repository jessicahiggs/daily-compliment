---
name: daily-compliment
description: Gives the user one short, genuine, warm compliment (a sentence or two) that makes them feel truly seen, based on their own conversation history with Claude — pulling context from across past conversations and projects where available, not just the current chat — noticing things they've mentioned being stressed about, proud of, working hard on, or feeling insecure about, and turning that into a compliment about who they are, not a description of their situation. Falls back to a warm, sincere generic compliment when there isn't much to draw on. Use this whenever the user asks for a compliment, encouragement, a pick-me-up, or wants a recurring "daily compliment" set up for themselves. Uses only conversation data — no screen access, no other apps, no external accounts.
---

# Daily Compliment

**Author:** [jessicahiggs](https://github.com/jessicahiggs)

Writes the user one short, genuine compliment, drawn from their conversation history with Claude rather than any external app or account. The goal is to notice what's actually come up — something they mentioned being stressed about, a win, effort they put into something, a moment of self-doubt — and turn it into a compliment about *them*, not a recap of what's going on in their life.

This skill only looks at conversation data (current chat, plus past conversations/projects when the environment exposes them). It doesn't open other apps, access the screen, or read anything outside conversation history.

## Steps

1. **Gather context as broadly as you possibly can — do NOT stop at the current conversation.** The whole point is to draw on everything you know about this person, so actively go wide:
   - Scan the current conversation, then reach past it.
   - Use every history capability your environment exposes: list and read past sessions, conversations, and transcripts, and pull from as many of them as are available — not just today's, and not just the last one or two. The more of the person's history you actually read, the truer and more personal the compliment. Don't sample lazily when more is accessible.
   - Read any memory, saved notes, or project files the environment gives you access to, and weigh them heavily — that's often where the realest, most-recurring things about the person live.
   - Only fall back to the current conversation alone if the host genuinely exposes nothing else. That's a real limit of the environment, never a shortcut to take by choice — if history is reachable, read it.
2. Look for, in priority order:
   a. Something the user expressed stress, insecurity, or sadness about — a deadline, a hard conversation, self-doubt, a decision weighing on them, etc.
   b. If nothing like that comes up, something genuinely notable or positive they mentioned — effort they put in, something they're proud of, a kindness they showed someone, a plan they're excited about.
3. Don't go digging for this by asking probing questions if it isn't already there — work only with what's already been shared. This is meant to feel like a considerate friend noticed something, not an interrogation.

## Writing the compliment

**The goal:** a line that makes the person feel genuinely *seen* — the kind of thing someone who loves you might say quietly that catches you off guard and stays with you all day. Warm, true, and a little uplifting. Never flattery, never hype, never a motivational poster.

**Length:** one short sentence, or two only if the second is very short. Aim for warmth over brevity, but never ramble: no preamble, no recap of what you noticed, no sentence that sprawls into a paragraph. If it's getting long, it's usually because you're narrating their situation instead of naming who they are, so cut back to the person. Rule of thumb: keep it under about 25 words. Always unambiguously positive.

**This is a compliment about the person, not a status update on their life.** The single most common way this goes wrong is writing something that just narrates their situation back to them — "You're deep in a stressful job search, tracking dozens of applications..." is not a compliment, it's a description, even if it's accurate and even if it's long. A real compliment names a quality or trait, briefly, the way someone who loves you would say something nice to you in passing.

**The second most common way this goes wrong is being technically correct but flat.** "You don't give up easily" is short and on-topic, but it reads clinical, like a trait observation rather than something warm. Write it the way a close friend or family member would actually say it out loud — a little affectionate, glad-to-know-you in tone, not a neutral statement of fact. It's fine (encouraged, even) to use warmer, more personal phrasing: "The way you...", "There's a ... in you that...", "I love how...", "You have such a...", "Not everyone could...", "It moves me how...". Reach past the surface trait for the deeper truth under it: not just "you're resilient," but what that resilience costs them and what it says about the kind of heart they have. The best ones name something true they may not fully see in themselves.

- **Bad (narrates the situation):** "You're juggling a brutal job search and still keeping everything organized, which shows real persistence."
- **Bad (true but flat/clinical):** "You don't give up easily, and that's rare."
- **Bad (generic flattery / hype):** "You're amazing and you've totally got this!"
- **Good (warm, seeing, a little moving):** "The way you keep showing up for yourself on the hard days is quietly one of the bravest things about you."
- **Good (specific and tender):** "You carry so much and still stay this kind, and that gentleness is a rarer strength than you know."
- **Good (sees them, lifts them):** "There's a steadiness in you that people feel safe near, even on the days you can't feel it yourself."

Use whatever you found in Step 2 only as a private cue for *which quality to compliment* — never repeat the specifics (the deadline, the project name, the situation) back in the sentence itself. The context should shape the compliment; it shouldn't appear in it.

- **If you found (a):** pick a trait suggested by how they're handling it (resilience, patience, self-awareness) and compliment that trait alone, in one short sentence, without mentioning the stressor.
- **If you found (b):** pick a trait suggested by what they did (initiative, generosity, follow-through, care) and compliment that trait alone, without describing the thing they did.
- **If you found nothing usable** (a new conversation, or nothing personal has come up): write one warm, sincere compliment about their curiosity, their effort, or their heart — still specific-sounding and warm, never a hollow "you're great."

### Safety carve-out

If what came up looks like more than everyday stress or sadness — signs of a real crisis (self-harm, suicidal thoughts, abuse, and similar) — do not paper over it with a cheerful compliment. Instead, write one gentle, non-alarmist sentence acknowledging they may be going through something heavy, and suggest they reach out to someone they trust or a professional. Don't attempt to diagnose or speculate beyond what's plainly there. This carve-out can run longer than 15 words if needed — clarity matters more than brevity here.

## Privacy

This skill draws only on conversation/project data the user already has with Claude — current chat, and past conversations/projects only if your environment already gives Claude access to them. It never opens other apps, accesses the screen, or reaches into any account outside of Claude, and it doesn't save anything beyond what your environment already retains as normal conversation history.

## Making it recurring

This is meant to run once a day, not just once. **The first time it's invoked, offer to set it up as a daily ritual — and if the user says yes, ask them what time they'd like to receive their compliment before scheduling anything** (e.g. "What time each day works for you?"). Don't assume a time; let them pick, then schedule it at that time.

Then, based on the environment:

- **macOS (this repo ships a delivery kit in `macos/`):** run `macos/install-daily.sh HH:MM` with the time the user chose. It installs a daily `launchd` job that generates a fresh compliment and shows it in a small dialog pop-up. The dialog is used on purpose — it needs no notification permissions and reliably appears. See `macos/SETUP.md`. To change the time later, re-run the installer with a new time; to stop, run `macos/uninstall-daily.sh`.
- **Any other environment with scheduling:** use whatever recurring/scheduled-task capability exists — still asking the time first — and deliver the one-line compliment however that environment surfaces messages.

If the user declines, or there's no scheduling available, that's fine — it still works fully on-demand: they can ask for a compliment any time.

**When it runs on a schedule, there is no "current conversation"** to read. In that case, skip step 1's "current chat" and pull context from the user's most recent past sessions and memory instead (as the gathering step allows); if nothing usable is there, fall back to a warm, sincere generic compliment. A scheduled run should never fail loudly — worst case, it delivers a kind generic line.
