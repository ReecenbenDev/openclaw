// swift-tools-version: 6.2
// Package manifest for the Reecenbot macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "Reecenbot",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "ReecenbotIPC", targets: ["ReecenbotIPC"]),
        .library(name: "ReecenbotDiscovery", targets: ["ReecenbotDiscovery"]),
        .executable(name: "Reecenbot", targets: ["Reecenbot"]),
        .executable(name: "openclaw-mac", targets: ["ReecenbotMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/ReecenbotKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "ReecenbotIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "ReecenbotDiscovery",
            dependencies: [
                .product(name: "ReecenbotKit", package: "ReecenbotKit"),
            ],
            path: "Sources/ReecenbotDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "Reecenbot",
            dependencies: [
                "ReecenbotIPC",
                "ReecenbotDiscovery",
                .product(name: "ReecenbotKit", package: "ReecenbotKit"),
                .product(name: "ReecenbotChatUI", package: "ReecenbotKit"),
                .product(name: "ReecenbotProtocol", package: "ReecenbotKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/Reecenbot.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "ReecenbotMacCLI",
            dependencies: [
                "ReecenbotDiscovery",
                .product(name: "ReecenbotKit", package: "ReecenbotKit"),
                .product(name: "ReecenbotProtocol", package: "ReecenbotKit"),
            ],
            path: "Sources/ReecenbotMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "ReecenbotIPCTests",
            dependencies: [
                "ReecenbotIPC",
                "Reecenbot",
                "ReecenbotDiscovery",
                .product(name: "ReecenbotProtocol", package: "ReecenbotKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
