// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCStringsLint",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "xcstringslint",
            targets: ["XCStringsLint"]
        ),
        .plugin(
            name: "XCStringsLintBuildToolPlugin",
            targets: ["XCStringsLintBuildToolPlugin"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/jpsim/Yams", from: "5.1.0")
    ],
    targets: [
        .target(
            name: "StringCatalogValidator",
            dependencies: ["StringCatalogDecodable"],
            resources: [
                .process("Resources")
            ],
            plugins: [
                // !!!: We cannot meta-plugin from the same package.
                // If we wanted to do this we could first compile the plugin to a binary.
                //.plugin(name: "StringCatalogLinterPlugin")
            ]
        ),
        .testTarget(
            name: "StringCatalogValidatorTests",
            dependencies: ["StringCatalogValidator"]
        ),
        .target(
            name: "StringCatalogDecodable"
        ),
        .executableTarget(
            name: "XCStringsLint",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Yams",
                "StringCatalogValidator",
            ]
        ),
        .plugin(
            name: "XCStringsLintBuildToolPlugin",
            capability: .buildTool(),
            dependencies: ["XCStringsLint"]
        )
    ]
)
