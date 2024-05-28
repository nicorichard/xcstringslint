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
        .executable(
            name: "xcstringslint",
            targets: ["StringCatalogLinter"]
        ),
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
            name: "StringCatalogValidator",
            dependencies: ["StringCatalogDecodable"],
            resources: [
                .process("Resources")
            ],
            plugins: [
                // Unfortunately we cannot use this library to meta-lint this library directly
                // However, once we compile the library to an executable we might be able to
                //.plugin(name: "StringCatalogLinterPlugin")
            ]
        ),
        .testTarget(name: "StringCatalogValidatorTests", dependencies: ["StringCatalogValidator"]),
        .target(name: "StringCatalogDecodable"),
        .executableTarget(
            name: "StringCatalogLinter",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "StringCatalogValidator",
            ]
        ),
        .plugin(
            name: "StringCatalogLinterPlugin",
            capability: .buildTool(),
            dependencies: ["StringCatalogLinter"]
        )
    ]
)
