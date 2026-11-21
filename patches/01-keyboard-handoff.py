# The keyboard can mark "send dictation to Hex" for a day (say, before Full Access was on).
# When Hex itself dictates with Apple Speech, its model is the keyboard's, so clear that mark
# each time Hex starts. Inserted just before the original's Apple Speech check.
import re, sys
p = "ios/HEXMobile/KeyboardSpeechPreparation.swift"
s = open(p).read()
if "// ours: clear handoff" in s:
    sys.exit(0)
m = re.search(r'^([ \t]*)if appEngine\(\) == "Apple Speech"', s, re.M)
if not m:
    sys.exit("anchor not found")
line = f'{m.group(1)}if appEngine() == "Apple Speech" {{ LanguageSettings().clearKeyboardNeedsHex() }} // ours: clear handoff\n'
open(p, "w").write(s[:m.start()] + line + s[m.start():])
