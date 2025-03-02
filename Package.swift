// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "H3kit",
    platforms: [.iOS(.v12), .macOS(.v11), .macCatalyst(.v13), .watchOS(.v6), .tvOS(.v12)],
    products: [
        .library(
            name: "H3kit",
            targets: ["H3kit"]
        ),
    ],
    targets: [
        .target(
            name: "H3kitC",
            dependencies: [],
            path: "Sources/H3kitC",
            publicHeadersPath: "include"
        ),
        .target(
            name: "H3kit",
            dependencies: [
                .target(name: "H3kitC"),
            ],
            path: "Sources/Swift"
        ),
        .testTarget(
            name: "H3kitTests",
            dependencies: [
                .target(name: "H3kit"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
