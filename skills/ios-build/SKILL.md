---
name: ios-build
description: Build the current iOS Xcode project in Debug for the iPhone 17 Simulator. Use when the user asks to build the app, verify compilation, or check whether recent Swift or iOS changes still compile. Prefer this skill only for local project builds, not for tests, archives, or release distribution.
---

# iOS Build

- Default target command:

```bash
xcodebuild -project プロジェクト名.xcodeproj -scheme プロジェクト名 -configuration Debug -destination 'platform=iOS Simulator,arch=arm64,name=iPhone 18 Pro' build -quiet
```

- Keep `-quiet` for the first run so normal builds stay readable.
- If you need full diagnostics, remove only the trailing `-quiet`; keep all other arguments unchanged.
