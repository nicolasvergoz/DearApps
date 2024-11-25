// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "DearApp",
  platforms: [
    .macOS(.v13),
    .iOS(.v16),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    .library(
      name: "DearApp",
      targets: ["DearApp"]
    )
  ],
  dependencies: [
    // Add your dependencies here if needed
  ],
  targets: [
    .target(
      name: "DearApp",
      dependencies: []
    ),
    .testTarget(
      name: "DearAppTests",
      dependencies: ["DearApp"]
    ),
  ]
)
