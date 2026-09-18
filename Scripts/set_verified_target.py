#!/usr/bin/env python3
"""Replace the deliberately inert Stage-4.1 bundle filter after device verification.

Usage:
  python3 Scripts/set_verified_target.py <verified.bundle.id> [second.verified.bundle.id]

Pass one ID if iOS 15.x and iOS 16.2 use the same verified Phone bundle ID.
Pass two IDs if runtime inspection proves they differ. This script only changes the
bundle filter; it does NOT enable any private hook or declare a runtime adapter verified.
"""
from pathlib import Path
import re, sys

if len(sys.argv) not in (2, 3):
    raise SystemExit('usage: set_verified_target.py <verified.bundle.id> [second.verified.bundle.id]')

ids = []
for raw in sys.argv[1:]:
    bundle = raw.strip()
    if not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9.-]+', bundle):
        raise SystemExit(f'invalid bundle identifier syntax: {bundle!r}')
    if bundle not in ids:
        ids.append(bundle)

path = Path(__file__).resolve().parents[1] / 'SmartDialSIM.plist'
text = path.read_text(encoding='utf-8')
needle = '            "REQUIRES_DEVICE_VERIFICATION.invalid"'
if needle not in text:
    raise SystemExit('refusing: inert Stage-4.1 marker is not present')
replacement = ',\n'.join(f'            "{bundle}"' for bundle in ids)
path.write_text(text.replace(needle, replacement, 1), encoding='utf-8')
print('Updated filter to verified bundle ID(s):', ', '.join(ids))
print('Private hooks remain disabled until iOS 15.x and iOS 16.2 adapters are verified independently.')
