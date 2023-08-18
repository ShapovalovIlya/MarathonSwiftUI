// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

fileprivate let SharedContent: Target.Dependency = "Shared"
fileprivate let AppDependencies: Target.Dependency = "AppDependencies"

fileprivate enum Dependencies: CaseIterable {
    case SwiftUDF
    case SwiftFP
    case SwiftMacro
    case PropertyWrappers
    
    var package: Package.Dependency {
        switch self {
        case .SwiftUDF: return .package(url: "https://github.com/ShapovalovIlya/SwiftUDF.git", branch: "main")
        case .SwiftFP: return .package(url: "https://github.com/ShapovalovIlya/SwiftFP.git", branch: "main")
        case .SwiftMacro: return .package(url: "https://github.com/ShapovalovIlya/SwiftMacro.git", branch: "main")
        case .PropertyWrappers: return .package(url: "https://github.com/ShapovalovIlya/PropertyWrappers.git", branch: "main")
        }
    }
    
    var target: Target.Dependency {
        switch self {
        case .SwiftUDF: return .product(name: "SwiftUDF", package: "SwiftUDF")
        case .SwiftFP: return .product(name: "SwiftFP", package: "SwiftFP")
        case .SwiftMacro: return .product(name: "SwiftMacro", package: "SwiftMacro")
        case .PropertyWrappers: return .product(name: "PropertyWrappers", package: "PropertyWrappers")
        }
    }
}

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
        .library(name: "WordScramble", targets: ["WordScramble"]),
        .library(name: "AppDependencies", targets: ["AppDependencies"]),
        .library(name: "MultiplicationTables", targets: ["MultiplicationTables"]),
        .library(name: "iExpense", targets: ["iExpense"]),
        .library(name: "Moonshot", targets: ["Moonshot"]),
        .library(name: "HabitsTracker", targets: ["HabitsTracker"]),
    ],
    dependencies: [
        Dependencies.SwiftUDF.package,
        Dependencies.SwiftFP.package,
    ],
    targets: [
        .target(name: "Shared"),
        .target(
            name: "AppDependencies",
            dependencies: [
                SharedContent,
                .product(name: "SwiftFP", package: "SwiftFP"),
            ],
            resources: [
                .process("Resources")
            ]),
        .target(
            name: "HackingWithSwiftUI",
            dependencies: [
                Dependencies.SwiftUDF.target,
                SharedContent,
                "GuessTheFlag",
                "UnitConversions",
                "RockPaperScissors",
                "WeSplit",
                "BetterRest",
                "WordScramble",
                "MultiplicationTables",
                "iExpense",
                "Moonshot",
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
                Dependencies.SwiftUDF.target,
                SharedContent,
            ]),
        .target(
            name: "RockPaperScissors",
            dependencies: [
                Dependencies.SwiftUDF.target,
                SharedContent,
            ]),
        .target(
            name: "BetterRest",
            dependencies: [
                Dependencies.SwiftUDF.target,
                SharedContent,
            ],
            resources: [
                .process("Resources"),
            ]),
        .target(
            name: "WordScramble",
            dependencies: [
                Dependencies.SwiftUDF.target,
                AppDependencies,
            ]),
        .target(
            name: "MultiplicationTables",
            dependencies: [
                Dependencies.SwiftUDF.target,
                SharedContent,
                AppDependencies,
            ]),
        .target(
            name: "iExpense",
            dependencies: [
                Dependencies.SwiftUDF.target,
                SharedContent,
                AppDependencies,
            ]),
        .target(
            name: "Moonshot",
            dependencies: [
                Dependencies.SwiftUDF.target,
                SharedContent,
                AppDependencies,
            ],
            resources: [
                .process("Assets.xcassets"),
            ]),
        .target(
            name: "HabitsTracker", dependencies: [
                Dependencies.SwiftUDF.target,
                SharedContent,
                AppDependencies,
                Dependencies.SwiftFP.target,
            ]),
        .testTarget(
            name: "AppTests",
            dependencies: [
                "UnitConversions",
                "RockPaperScissors",
                "BetterRest",
                "WordScramble",
                "GuessTheFlag",
                "MultiplicationTables",
                "iExpense",
                "Moonshot",
                "HabitsTracker"
            ]),
    ]
)
