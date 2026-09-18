# SmartDialSIM — Stage 4.1 dual-version source

A RootHide/Theos jailbreak tweak project targeting **iOS 15.x and iOS 16.2**, designed to add Smart Dial suggestions and compact SIM presentation inside Apple's existing Phone keypad while preserving Apple's native dialing/subscription logic.

## Important Stage 4.1 gate
This tree is intentionally **inert** with respect to Phone.app private integration. `SmartDialSIM.plist` uses a non-matching placeholder bundle filter until the actual target is verified on-device. No guessed private Phone class, selector, ivar, notification, entitlement, Call History database path, or SIM identifier is present.

The project now has an explicit runtime family router:

- iOS 15.x -> `SDSRuntimeFamilyIOS15`
- iOS 16.2 -> `SDSRuntimeFamilyIOS162`
- every other version -> unsupported/inert

A supported OS family does **not** enable private integration by itself. Private hooks remain disabled until runtime evidence is captured for that exact family.

## Build environment
Use RootHide's Theos fork/support and build with:

```sh
make clean package
```

The project sets:

```make
THEOS_PACKAGE_SCHEME = roothide
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
```

Deployment target 15.0 allows one package to contain the shared core for iOS 15.x and iOS 16.2. Private Phone integration is version-routed at runtime and must be implemented separately per verified family.

No `/var/jb` path is hard-coded. If a future module must access jailbreak-owned files, use RootHide path translation (`jbroot(...)`) rather than a fixed jailbreak prefix.

## Runtime verification required twice
Before enabling injection/private hooks, capture the runtime scripts on:

1. at least one target device running iOS 15.x
2. the target device running iOS 16.2

For each family record:

1. exact Phone bundle identifier and process/executable
2. Keypad controller/view hierarchy
3. selectors/boundaries called for input/delete/paste
4. native full-number insertion flow
5. Call History service/provider and relevant notification names
6. native SIM selector hierarchy and line-item ordering

Do not copy a private selector verified on iOS 16.2 into the iOS 15 path, or vice versa, without evidence.

## Planned private hook routing after verification

```text
iOS 15.x -> dedicated iOS15 adapter / Logos group
iOS 16.2 -> dedicated iOS162 adapter / Logos group
other OS  -> no private hook
```

## Data/privacy behavior
- Contacts are fetched only if the host process is already authorized. The tweak does not request a new Contacts prompt.
- Call History is disabled in Stage 4.1 rather than guessed.
- No contact or call-history data is sent to the network.
- Logs mask phone-like strings.
- Selecting a suggestion is not wired to place a call; the future verified number setter must only populate the native dialer state.

## Preferences
Domain: `com.smartdialsim.preferences`

Darwin notification: `com.smartdialsim.preferences.changed`

Settings include master enable, Smart Dial enable, Contacts/history/T9 toggles, max result count, compact-SIM toggle, and custom SIM 1/SIM 2 labels.

## Next step
Capture runtime outputs for both supported families, then implement separate version-gated private adapters only from those verified facts.
