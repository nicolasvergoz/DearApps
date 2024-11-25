# DearApps

A Swift package that provides a convenient wrapper around the iTunes Search API, allowing you to fetch information about your beloved applications as `AppStoreProduct` objects and developer information as `AppStoreDeveloper` objects.

## Features

### App Information
- Fetch app details using its App Store ID
- Fetch app details using its bundle identifier

### Developer Information
- List all applications from a developer using their developer ID
- Find other applications from a developer using an app's bundle identifier (bundle ID → developer ID → developer's apps)

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/DearApps.git", from: "1.0.0")
]
```

## Usage

### Fetch App Details
```swift
// Using App Store ID
let app = try await DearApps.fetchApp(id: "123456789")

// Using bundle identifier
let app = try await DearApps.fetchApp(bundleId: "com.example.app")
```

### Fetch Developer's Apps
```swift
// Using developer ID
let apps = try await DearApps.fetchApps(developerId: "123456789")

// Using an app's bundle identifier
let apps = try await DearApps.fetchDeveloperApps(fromBundleId: "com.example.app")
```

## Requirements

- iOS 16.0+ / macOS 13.0+ / tvOS 16.0+ / watchOS 9.0+
- Swift 6.0+

## License

This project is available under the MIT license. See the LICENSE file for more info.
