// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "ThemeParty",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "ThemeParty",
            targets: ["ThemeParty"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "ThemeParty",
            dependencies: []),
        .testTarget(
            name: "ThemePartyTests",
            dependencies: ["ThemeParty"]),
    ]
)
