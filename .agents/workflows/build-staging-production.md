---
description: Build both SuperApp_PQ Staging and Production simulator schemes.
---

# Build Staging And Production

1. Run the Staging build:

```bash
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace -scheme SuperApp_PQ\ Staging -destination generic/platform=iOS\ Simulator -quiet build
```

2. Run the Production build:

```bash
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace -scheme SuperApp_PQ\ Production -destination generic/platform=iOS\ Simulator -quiet build
```

3. If either fails, inspect the first project source error before changing code.
4. Report the exact failing file and line when available.
