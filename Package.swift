// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DansStreams",
	platforms: [
		.macOS(.v10_15), .iOS(.v18)
	],
    products: [
        .library(
            name: "DansStreams",
            targets: ["DansStreams"]),
    ],
    targets: [
        .target(
            name: "DansStreams"),
        .testTarget(
            name: "DansStreamsTests",
            dependencies: ["DansStreams"]
        ),
    ]
)
