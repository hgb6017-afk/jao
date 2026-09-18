# SmartDialSIM Stage 4.1 dual-version status

## Supported target scope
- iOS 15.x
- iOS 16.2
- RootHide
- arm64 + arm64e when supported by the device/toolchain

## READY / implemented without private Phone assumptions
- RootHide Theos project scaffold (`THEOS_PACKAGE_SCHEME=roothide`)
- shared deployment target iOS 15.0
- explicit runtime family detection for iOS 15.x vs iOS 16.2
- unsupported-OS fail-closed routing
- Preferences cache + Darwin reload notification
- Contacts service that never triggers a new permission prompt
- phone-number formatting normalization
- conservative Vietnam `0` / `+84` identity handling
- Vietnamese T9 normalization
- Contacts + history merge model
- search index and ranking
- debounce + stale-query cancellation
- native UIKit suggestion list/cells
- SIM label sanitization/presentation helpers
- masked debug/release logger
- fail-safe runtime capability object
- Preferences bundle
- Frida/runtime inspection scripts

## REQUIRES_DEVICE_VERIFICATION — iOS 15.x
- exact Phone bundle identifier/process
- Keypad host controller/view
- dial-string change boundary
- native complete-number setter flow
- actual Call History provider/model/API and change notification
- SIM selector/control, line item ordering, label/image subviews

## REQUIRES_DEVICE_VERIFICATION — iOS 16.2
- exact Phone bundle identifier/process
- Keypad host controller/view
- dial-string change boundary
- native complete-number setter flow
- actual Call History provider/model/API and change notification
- SIM selector/control, line item ordering, label/image subviews

## Safety gate
`SmartDialSIM.plist` deliberately filters on `REQUIRES_DEVICE_VERIFICATION.invalid`, so this Stage 4.1 package does not inject into Phone by default.

After runtime evidence is captured for both families, replace only the integration adapters and filter with verified identifiers. Never reuse an unverified private selector across the two OS families.
