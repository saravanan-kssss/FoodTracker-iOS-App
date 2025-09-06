// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "FoodTracker",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "FoodTracker",
            targets: ["FoodTracker"]),
    ],
    dependencies: [
        // Add any external dependencies here if needed
    ],
    targets: [
        .target(
            name: "FoodTracker",
            dependencies: []),
        .testTarget(
            name: "FoodTrackerTests",
            dependencies: ["FoodTracker"]),
    ]
)
