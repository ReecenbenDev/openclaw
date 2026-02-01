// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "ReecenbotKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "ReecenbotProtocol", targets: ["ReecenbotProtocol"]),
        .library(name: "ReecenbotKit", targets: ["ReecenbotKit"]),
        .library(name: "ReecenbotChatUI", targets: ["ReecenbotChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "ReecenbotProtocol",
            path: "Sources/ReecenbotProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "ReecenbotKit",
            dependencies: [
                "ReecenbotProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/ReecenbotKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "ReecenbotChatUI",
            dependencies: [
                "ReecenbotKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/ReecenbotChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "ReecenbotKitTests",
            dependencies: ["ReecenbotKit", "ReecenbotChatUI"],
            path: "Tests/ReecenbotKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
