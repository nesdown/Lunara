// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Models",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Models",
            targets: ["Models"])
    ],
    targets: [
        .target(
            name: "Models",
            dependencies: [])
    ]
) 