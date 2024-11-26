# DearApps

A Swift package that provides a convenient wrapper around the iTunes Search API, allowing you to fetch information about your beloved applications as `ApplicationDTO` objects and developer information as `DeveloperDTO` objects.

## Features

### App Information
- Fetch app details using its App Store ID
- Fetch app details using its bundle identifier
- Fetch other apps from the same develop using one of its app bundle identifier

### Developer Information
- List all applications from a developer using their developer ID
- Get developer information using their developer ID

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/nicolasvergoz/DearApps.git", from: "1.0.0")
]
```

## Usage

### Initialize API Client

```swift
let api = DearAppsAPI()
```

Note: Your can initialize with a custom URLSession and Locale

### Fetch App Details

```swift
// Using App Store ID
let app: ApplicationDTO = try await api.getApp(appStoreId: 1533526463)

// Using bundle identifier
let app: ApplicationDTO = try await api.getApp(bundleId: "com.example.app")

// Get other apps from the same developer using a bundle identifier
let otherApps: [ApplicationDTO] = try await api.getOtherApps(bundleId: "com.example.app")
```

### Developer Operations
```swift
// Get developer information
let developer: DeveloperDTO = try await api.getDeveloper(developerId: 1533526465)

// Fetch all apps from a developer
let apps: [ApplicationDTO] = try await api.getApps(developerId: 1533526465)
```

## Requirements

- iOS 14.0+ / macOS 13.0+ / tvOS 16.0+ / watchOS 9.0+
- Swift 6.0+

## Vapor Compatibility

When using DearApps with Vapor, you'll need to extend the DTO models to conform to Vapor's protocols. Add the following extensions to your project:

```swift
import DearApps
import Vapor

extension ApplicationDTO: @retroactive AsyncResponseEncodable {}
extension ApplicationDTO: @retroactive AsyncRequestDecodable {}
extension ApplicationDTO: @retroactive ResponseEncodable {}
extension ApplicationDTO: @retroactive RequestDecodable {}
extension ApplicationDTO: @retroactive Content {}

extension DeveloperDTO: @retroactive AsyncResponseEncodable {}
extension DeveloperDTO: @retroactive AsyncRequestDecodable {}
extension DeveloperDTO: @retroactive ResponseEncodable {}
extension DeveloperDTO: @retroactive RequestDecodable {}
extension DeveloperDTO: @retroactive Content {}
```

## License

This project is available under the MIT license. See the LICENSE file for more info.
