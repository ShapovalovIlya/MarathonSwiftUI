// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HackingWithSwiftUI",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(name: "HackingWithSwiftUI", targets: ["HackingWithSwiftUI"]),
        .library(name: "WeSplit", targets: ["WeSplit"]),
        .library(name: "GuessTheFlag", targets: ["GuessTheFlag"]),
        .library(name: "UnitConversions", targets: ["UnitConversions"]),
        .library(name: "Shared", targets: ["Shared"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftUDF"),
        .target(name: "Shared"),
        .target(
            name: "HackingWithSwiftUI",
            dependencies: [
                "SwiftUDF",
                "WeSplit",
                "GuessTheFlag",
                "UnitConversions",
            ]),
        .target(
            name: "WeSplit",
            dependencies: ["SwiftUDF"]),
        .target(
            name: "GuessTheFlag",
            dependencies: ["SwiftUDF"],
            resources: [
                .process("Assets.xcassets"),
            ]),
        .target(
            name: "UnitConversions",
            dependencies: [
                "SwiftUDF",
                "Shared",
            ]),
        .testTarget(
            name: "AppTests",
            dependencies: [
                "UnitConversions"
            ]),
    ]
)
