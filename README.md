# RVA for Swift

[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)

The Apple adapter for **RVA (Responsive Visual Asset)**. It links the shared Rust
core (shipped here as a prebuilt dynamic `RVAFFI.xcframework`) and renders the
resolved scene with **Core Graphics / Core Text**.

The core decides *what* to draw (deterministic geometry for a viewport); this
package decides *how*, using the native Apple graphics stack.

## Requirements

- iOS 15+ / macOS 13+
- Swift 5.9+

## Install

Add the package in Xcode (**File → Add Package Dependencies…**) or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/airovo/rva-swift", from: "0.1.0")
]
```

## Usage

```swift
import RVA

// A path, a file:// URL, or an http(s):// URL.
let image = try RVAImage(source: "hero.rva")

// Resolve for a logical viewport (deterministic; matches every other runtime).
let scene = try image.resolve(width: 1280, height: 720)
print(scene.topology, scene.viability)

// Rasterize with Core Graphics.
let png = try RVARenderer.pngData(image: image, width: 1280, height: 720)
try png.write(to: URL(fileURLWithPath: "hero.png"))
```

### `RVAImage`

| Member | Description |
| --- | --- |
| `init(source:)` | Load a `.rva` from a path, `file://` or `http(s)://` URL. |
| `describe()` | Human-readable asset summary. |
| `resolve(width:height:)` | Deterministic `ResolvedScene` for a viewport. |
| `resource(_:)` | Raw bytes for a declared resource id. |
| `hasResource(_:)` / `relativeFor(_:)` | Resource helpers. |
| `renderPNG(width:height:)` | Optional PNG from the Rust core (instead of Core Graphics). |

### `RVARenderer`

Core Graphics / Core Text rasterizer: `pngData(image:width:height:scale:)` and
`render(image:scene:scale:)`.

## Command-line renderer

```bash
swift run rva-render <asset.rva> [out-dir]
```

Renders the canonical viewport matrix (wide, desktop, tablet, square, mobile,
ultrawide) to PNG.

## How the core is provided

This package does **not** build the Rust core. `Package.swift` pins a specific core
release's `RVAFFI.xcframework` by URL + checksum; the core repo
([`airovo/rva`](https://github.com/airovo/rva)) builds and hosts it. To develop
against a locally built core, build it in `airovo/rva` with
`scripts/build-xcframework.sh` and switch the binary target to
`path: "RVAFFI.xcframework"` (see the comment in `Package.swift`).

## Maintainers

Release a new version with **Actions → Release** (inputs: a new `version` and the
`core_tag` to pin). The workflow downloads that core's binary, recomputes the
checksum, commits the pin, and tags the new version. See
[`.github/workflows/release.yml`](./.github/workflows/release.yml).

---

[RVA](https://rva.airovo.tech) — Responsive Visual Asset, built by
[Airovo Technologies](https://airovo.tech).
