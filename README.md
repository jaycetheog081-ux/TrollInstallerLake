<div align="center">
    <h1>TrollInstallerLake</h1>
    <img src="Resources/Icon.png" width="125" height="125" />
    <p>Experimental TrollStore installation research</p>
</div>

## Overview

TrollInstallerLake is a fork of TrollInstallerX focused on researching
and integrating additional exploit backends for TrollStore installation.

The primary integration targets are:

- DarkSword — kernel exploitation backend.
- Titan — PPL/SPTM bypass backend.
- Momentarius — separate PPL bypass backend for supported A12–A13 devices.

TrollInstallerLake is experimental. A listed backend or supported
version range does not imply that the complete installation chain
has been implemented or verified.

## Architecture

The intended architecture separates kernel exploitation, security
mitigation bypasses, and TrollStore installation.

### DarkSword

DarkSword is the intended kernel exploitation backend.

Its integration must account for:

- Exact device compatibility.
- Exact iOS version and build.
- Kernel primitive availability.
- Required kernel offsets.
- Failure and recovery handling.

The installer must reject unsupported combinations rather than
attempting an unverified exploit.

### Titan

Titan is a PPL/SPTM bypass backend.

It is not a standalone kernel exploit. It requires the appropriate
kernel-side primitives from an earlier stage.

The documented integration target is:

- iOS 16.5.1–17.3.1.
- Hardware and configurations supported by the upstream implementation.

Titan must only be initialized after its prerequisites have been
validated.

Upstream:
https://github.com/alfiecg24/Titan

### Momentarius

Momentarius is maintained as a separate backend for supported A12–A13
devices.

It must not be confused with Titan or automatically selected for
other hardware.

Upstream:
https://github.com/staturnzz/momentarius

## Intended installation flow

1. Detect the device model.
2. Detect the exact iOS version and build.
3. Determine which kernel exploit backend is compatible.
4. Validate the required kernel primitives.
5. Select a compatible PPL/SPTM bypass.
6. Validate the resulting capabilities.
7. Continue to the TrollStore installation stage.
8. Verify persistence-helper registration.

If any prerequisite fails, installation must stop and report the
specific failure.

## Compatibility

These are research targets, not guarantees of working support.

| Component | Target | Status |
|---|---|---|
| DarkSword | Exact upstream-supported device/build combinations | Integration required |
| Titan | iOS 16.5.1–17.3.1 | Integration required |
| Momentarius | Supported A12–A13 combinations | Separate backend |
| TrollStore installation | Compatible CoreTrust versions | Must be independently verified |

Never infer compatibility from the iOS major version alone.

## Usage

1. Download a release from the Releases page.
2. Sideload the IPA using a compatible installation method.
3. Open TrollInstallerLake.
4. Review the detected device and compatibility information.
5. Only proceed if the selected backend reports that all prerequisites
   are satisfied.

Releases must clearly distinguish tested combinations from
experimental or unsupported combinations.

## Building

The project currently inherits the TrollInstallerX Xcode project.

Run:

```sh
./build.sh
