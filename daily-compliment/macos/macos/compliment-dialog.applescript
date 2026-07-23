-- Compliment.app source.
--
-- install-daily.sh compiles this into a small, ad-hoc code-signed Compliment.app.
-- The pop-up is shown by this standalone app rather than a raw `osascript` call
-- from bash on purpose: a signed app has a STABLE identity, so macOS records its
-- permission grant once and never re-prompts. A bare bash -> osascript chain has
-- no durable identity, so macOS re-asks for permission on every scheduled run.
--
-- The compliment text is read from ~/.daily-compliment/today.txt, which
-- show-compliment.sh writes just before launching the app. (Reading a file is
-- reliable; passing launch arguments to an AppleScript applet is not.)
on run
	set txtPath to (POSIX path of (path to home folder)) & ".daily-compliment/today.txt"
	set msg to "You showed up today, and that counts."
	try
		set fileText to (read (POSIX file txtPath) as «class utf8»)
		if fileText ends with (ASCII character 10) then set fileText to text 1 thru -2 of fileText
		if fileText is not "" then set msg to fileText
	end try
	activate
	display dialog msg with title "Daily compliment ☀️" buttons {"Thanks"} default button 1 giving up after 3600
end run
