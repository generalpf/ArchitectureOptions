// swift-tools-version:5.9
//
// Vendored copy of https://github.com/nalexn/ViewInspector at c8671332c41bfa784da5c932fce9d5af285c60b3.
// Local changes: removed `.visionOS(.v2)` (unavailable in Xcode 27) and the package's own test target.
// Switch back to the remote package once an upstream release supports Xcode 27.

import PackageDescription

let package = Package(
    name: "ViewInspector",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v9)
    ],
    products: [
        .library(
            name: "ViewInspector", targets: ["ViewInspector"]),
    ],
    targets: [
        .target(
            name: "ViewInspector", dependencies: []),
    ]
)
