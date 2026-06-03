// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BoostedLifecycleMethods",
    platforms: [
        .iOS(.v12), .tvOS(.v12)
    ],
    products: [
        .library(
            name: "BoostedLifecycleMethods",
            targets: ["InitializerBLM"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "InitializerBLM",
            dependencies: ["BoostedLifecycleMethods"]
        ),
        .target(
            name: "BoostedLifecycleMethods",
            dependencies: []
        )
    ]
)
