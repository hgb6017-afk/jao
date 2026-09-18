# Runtime verification matrix

Stage 4.1 intentionally keeps both private integration columns unverified.

| Capability | iOS 15.x | iOS 16.2 |
|---|---|---|
| Phone bundle ID | REQUIRES_DEVICE_VERIFICATION | REQUIRES_DEVICE_VERIFICATION |
| Process/executable | REQUIRES_DEVICE_VERIFICATION | REQUIRES_DEVICE_VERIFICATION |
| Keypad host | REQUIRES_DEVICE_VERIFICATION | REQUIRES_DEVICE_VERIFICATION |
| Dial-string change boundary | REQUIRES_DEVICE_VERIFICATION | REQUIRES_DEVICE_VERIFICATION |
| Native complete-number setter | REQUIRES_DEVICE_VERIFICATION | REQUIRES_DEVICE_VERIFICATION |
| Call History provider | REQUIRES_DEVICE_VERIFICATION | REQUIRES_DEVICE_VERIFICATION |
| Call History change notification | REQUIRES_DEVICE_VERIFICATION | REQUIRES_DEVICE_VERIFICATION |
| SIM selector/control | REQUIRES_DEVICE_VERIFICATION | REQUIRES_DEVICE_VERIFICATION |
| SIM line ordering | REQUIRES_DEVICE_VERIFICATION | REQUIRES_DEVICE_VERIFICATION |

A row may move to VERIFIED only from evidence captured on that OS family. Similarity between versions is not evidence.
