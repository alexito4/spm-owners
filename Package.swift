// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "spm-owners",
    platforms: [.macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "spm-owners",
            targets: ["spm-owners"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing", exact: "0.13.0", owner: "Martin"),
        .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.5.0", owner: "Martin"),
        // Just for example purposes
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.13.0", owner: "Alex")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "spm-owners",
            dependencies: [
                .product(name: "Parsing", package: "swift-parsing"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "spm-ownersTests",
            dependencies: ["spm-owners"]),
    ]
)

extension PackageDescription.Package.Dependency {
    static func package(
        url: String,
        exact version: Version,
        owner: String
    ) -> PackageDescription.Package.Dependency {
        .package(url: url, exact: version)
    }
}
