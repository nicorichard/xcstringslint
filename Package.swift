// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCStringsLint",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(name: "XCStringsLint", targets: ["XCStringsLint"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        .target(name: "Validator"),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "XCStringsLint",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Validator"
            ]
        ),
        .testTarget(
            name: "XCStringsLintTests",
            dependencies: ["XCStringsLint"]),
    ]
)
