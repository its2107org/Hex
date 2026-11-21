# Match the keyboard's dark background to the iOS panel on Ian's phone (22, 22, 24).
import re, sys
p = "ios/HEXShared/FullKeyboard/KeyboardBackdropView.swift"
s = open(p).read()
new, n = re.subn(r'\?\s*UIColor\(red: \d+ / 255, green: \d+ / 255, blue: \d+ / 255, alpha: 1\)',
                 '? UIColor(red: 22 / 255, green: 22 / 255, blue: 24 / 255, alpha: 1)', s, count=1)
if n != 1:
    sys.exit("anchor not found")
open(p, "w").write(new)
