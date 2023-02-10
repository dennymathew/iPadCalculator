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
        ),
        .library(
            name: "DangerDeps",
            type: .dynamic,
            targets: ["DangerDependencies"]
        ), // dev
    ],
    dependencies: [
        // Danger Plugins
        .package(url: "https://github.com/danger/swift.git", from: "3.0.0"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-coverage", from: "0.1.0") // dev
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
        ),
        .target(
            name: "DangerDependencies",
            dependencies: [
                .product(name: "Danger", package: "swift"),
                .product(name: "DangerSwiftCoverage", package: "danger-swift-coverage")
            ]
        ), // dev
    ]
)
