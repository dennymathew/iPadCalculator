// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Packages",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "CalculatorUI",
            targets: ["CalculatorUI"]
        ),
        .library(
            name: "CalculatorKit",
            targets: ["CalculatorKit"]
        )
    ],
    targets: [
        .target(
            name: "CalculatorUI",
            dependencies: ["CalculatorKit"]
        ),
        .target(
            name: "CalculatorKit",
            dependencies: []
        ),
        .testTarget(
            name: "CalculatorKitTests",
            dependencies: ["CalculatorKit"]
        )
    ]
)
