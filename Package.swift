// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BoostedLifecycleMethods",
    platforms: [
        .iOS(.v9), .tvOS(.v9)
    ],
    products: [
        .library(
            name: "BoostedLifecycleMethods",
            targets: ["Initializer"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Initializer",
            dependencies: ["BoostedLifecycleMethods"]
        ),
        .target(
            name: "BoostedLifecycleMethods",
            dependencies: []
        ),
    ]
)
