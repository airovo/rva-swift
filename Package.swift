// swift-tools-version:5.9
// RVA — Swift Package (the Apple adapter).
//
// The Rust core is shipped as a prebuilt *dynamic* xcframework by the core repo
// (airovo/rva) and pinned here. Re-pin it by running the "Release" workflow, which
// downloads the chosen core tag, recomputes the SwiftPM checksum, commits and tags.
//
// Local development against a freshly built core: build it in airovo/rva with
// `scripts/build-xcframework.sh`, then temporarily replace the target below with
//   .binaryTarget(name: "RVAFFI", path: "RVAFFI.xcframework")

import PackageDescription

let rvaFFIUrl = "https://github.com/airovo/rva/releases/download/v0.1.2/RVAFFI.xcframework.zip"
let rvaFFIChecksum = "0000000000000000000000000000000000000000000000000000000000000000"

let package = Package(
    name: "RVA",
    platforms: [.macOS(.v13), .iOS(.v15)],
    products: [
        .library(name: "RVA", targets: ["RVA"]),
        .executable(name: "rva-render", targets: ["RVARenderCLI"]),
    ],
    targets: [
        .binaryTarget(name: "RVAFFI", url: rvaFFIUrl, checksum: rvaFFIChecksum),
        .target(name: "RVA", dependencies: ["RVAFFI"]),
        .executableTarget(name: "RVARenderCLI", dependencies: ["RVA"], path: "Examples/RVARenderCLI"),
    ]
)
