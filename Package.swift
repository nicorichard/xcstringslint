// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StringCatalogLinter",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "StringCatalogLinter", targets: ["StringCatalogLinter"]),
        .plugin(
            name: "StringCatalogLinterPlugin",
            targets: ["StringCatalogLinterPlugin"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "Validator",
            dependencies: ["StringCatalogDecodable"],
            plugins: [
                // Unfortunately we cannot use this library to meta-lint this library directly
                // However, once we compile the library to an executable we might be able to
                //.plugin(name: "StringCatalogLinterPlugin")
            ]
        ),
        .target(name: "StringCatalogDecodable"),
        .executableTarget(
            name: "StringCatalogLinter",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Validator",
            ]
        ),
        .plugin(
            name: "StringCatalogLinterPlugin",
            capability: .buildTool(),
            dependencies: ["StringCatalogLinter"]
        )
    ]
)
