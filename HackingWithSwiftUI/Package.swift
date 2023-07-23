// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

fileprivate let SwiftUDF: Target.Dependency = "SwiftUDF"
fileprivate let SharedContent: Target.Dependency = "Shared"

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
        .library(name: "RockPaperScissors", targets: ["RockPaperScissors"]),
        .library(name: "BetterRest", targets: ["BetterRest"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftUDF"),
        .target(name: "Shared"),
        .target(
            name: "HackingWithSwiftUI",
            dependencies: [
                SwiftUDF,
                SharedContent,
                "GuessTheFlag",
                "UnitConversions",
                "RockPaperScissors",
                "WeSplit",
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
                SwiftUDF,
                SharedContent,
            ]),
        .target(
            name: "RockPaperScissors",
            dependencies: [
                SwiftUDF,
                SharedContent,
            ]),
        .target(
            name: "BetterRest",
            dependencies: [
                SwiftUDF,
                SharedContent,
            ],
            resources: [
                .process("Resources"),
            ]),
        .testTarget(
            name: "AppTests",
            dependencies: [
                "UnitConversions",
                "RockPaperScissors",
                "BetterRest"
            ]),
    ]
)
