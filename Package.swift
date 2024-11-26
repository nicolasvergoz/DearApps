// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "DearApps",
  platforms: [
    .macOS(.v13),
    .iOS(.v16),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    .library(
      name: "DearApps",
      targets: ["DearApps"]
    )
  ],
  dependencies: [
    // Add your dependencies here if needed
  ],
  targets: [
    .target(
      name: "DearApps",
      dependencies: []
    ),
    .testTarget(
      name: "DearAppsTests",
      dependencies: ["DearApps"]
    ),
  ]
)
