#!/bin/sh
set -eu
cd "$(dirname "$0")"

echo '[1/8] Checking required files...'
for f in Makefile control SmartDialSIM.plist Tweak.xm README.md STATUS.md Runtime/SDSRuntimeVersion.h Runtime/SDSRuntimeVersion.m RUNTIME_MATRIX.md PrivateHeaders/iOS15/README.md PrivateHeaders/iOS162/README.md Preferences/Resources/Root.plist; do
  test -f "$f" || { echo "Missing: $f"; exit 1; }
done

echo '[2/8] Ensuring Stage 4.1 filter remains inert...'
grep -q 'REQUIRES_DEVICE_VERIFICATION.invalid' SmartDialSIM.plist || {
  echo 'FAIL: Stage 4.1 filter was changed. Only enable a verified Phone target after runtime inspection.'
  exit 1
}

echo '[3/8] Checking dual-version deployment target...'
grep -q '^TARGET = iphone:clang:latest:15.0$' Makefile || { echo 'FAIL: deployment target must remain 15.0 for the shared iOS 15.x / 16.2 core.'; exit 1; }
grep -q 'firmware (>= 15.0)' control || { echo 'FAIL: package firmware dependency must allow iOS 15.0+.'; exit 1; }

echo '[4/8] Checking explicit runtime family routing...'
grep -q 'SDSRuntimeFamilyIOS15' Runtime/SDSRuntimeVersion.m || { echo 'FAIL: iOS 15 runtime family missing.'; exit 1; }
grep -q 'SDSRuntimeFamilyIOS162' Runtime/SDSRuntimeVersion.m || { echo 'FAIL: iOS 16.2 runtime family missing.'; exit 1; }
grep -q 'SDSRuntimeFamilyUnsupported' Runtime/SDSRuntimeVersion.m || { echo 'FAIL: unsupported fail-closed family missing.'; exit 1; }

echo '[5/8] Checking forbidden fixed RootHide path...'
if grep -R -n --exclude=README.md --exclude=VERIFY_STAGE4.sh --exclude=VERIFY_STAGE4_1.sh '/var/jb' .; then
  echo 'FAIL: fixed /var/jb path found.'
  exit 1
fi

echo '[6/8] Checking for accidentally introduced guessed private calls...'
if grep -R -nE 'NSClassFromString|objc_msgSend|performSelector|CHManager|CallHistory\.framework' --include='*.m' --include='*.h' --include='*.xm' .; then
  echo 'FAIL: review private API usage before Stage 4.1 can remain marked safe.'
  exit 1
fi

echo '[7/8] Checking Frida JavaScript syntax when Node is available...'
if command -v node >/dev/null 2>&1; then
  for f in Scripts/*.js; do node --check "$f"; done
else
  echo 'SKIP: node not installed.'
fi

echo '[8/8] Checking XML plists when Python 3 is available...'
if command -v python3 >/dev/null 2>&1; then
python3 - <<'PY'
import plistlib
for name in ('Preferences/Resources/Info.plist','Preferences/Resources/Root.plist'):
    with open(name,'rb') as f: plistlib.load(f)
    print('OK', name)
PY
else
  echo 'SKIP: python3 not installed.'
fi

echo 'PASS: SmartDialSIM Stage 4.1 dual-version structural verification.'
echo 'NOTE: this does not replace a real Theos/iOS SDK compile.'
