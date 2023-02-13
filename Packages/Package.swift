// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Packages",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "CalculatorUI", targets: ["CalculatorUI"]),
        .library(name: "CalculatorKit", targets: ["CalculatorKit"]),
        .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]), // dev
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "3.12.3"), // dev
        .package(url: "https://github.com/fastlane-community/danger-xcov.git", from: "0.5.0") // dev
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
                .product(name: "danger-xcov", package: "danger-xcov")
            ]
        ), // dev
    ]
)
