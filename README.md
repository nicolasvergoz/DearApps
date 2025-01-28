# DearApps

A Swift package that provides a convenient and type-safe wrapper around the iTunes Search API, allowing you to fetch information about applications and developers from the App Store. The package is built with modern Swift features including async/await and actors for thread-safe operations.

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)](https://developer.apple.com/macos/)
[![tvOS](https://img.shields.io/badge/tvOS-16.0+-blue.svg)](https://developer.apple.com/tvos/)
[![watchOS](https://img.shields.io/badge/watchOS-9.0+-blue.svg)](https://developer.apple.com/watchos/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/nicolasvergoz/DearApps/blob/main/LICENSE)

## Features

### App Information
- 📱 Fetch app details using App Store ID
- 📦 Fetch app details using bundle identifier
- 🔍 Get other apps by the same developer from a bundle identifier
- 🌍 Full localization support
- 🔒 Thread-safe operations using Swift actors

### Developer Information
- 👨‍💻 List all applications from a developer
- ℹ️ Get detailed developer information
- 🔄 Automatic error handling and type-safe responses

## Requirements

- iOS 16.0+ / macOS 13.0+ / tvOS 16.0+ / watchOS 9.0+
- Swift 6.0+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/nicolasvergoz/DearApps.git", from: "1.1.1")
]
```

Or in Xcode:
1. File > Add Packages...
2. Enter package URL: `https://github.com/nicolasvergoz/DearApps.git`
3. Select version requirements
4. Click "Add Package"

## Usage

### Initialize API Client

```swift
// Basic initialization
let api = DearAppsAPI()

// Custom initialization with specific locale and URLSession
let customSession = URLSession(configuration: .ephemeral)
let api = DearAppsAPI(
    urlSession: customSession,
    locale: Locale(identifier: "fr_FR")
)
```

### Fetch App Details

```swift
// Using App Store ID
let app = try await api.getApp(appStoreId: 1533526463)
print(app.trackName) // Prints the app name
print(app.version) // Prints the app version

// Using bundle identifier
let app = try await api.getApp(bundleId: "com.example.app")

// Get other apps from the same developer (excluding current app)
let otherApps = try await api.getOtherApps(
    bundleId: "com.example.app",
    excludeCurrentId: true
)
```

### Developer Operations
```swift
// Get developer information
let developer = try await api.getDeveloper(developerId: 1533526465)
print(developer.artistName) // Prints developer name

// Fetch all apps from a developer
let apps = try await api.getApps(developerId: 1533526465)
```

### Error Handling

The package provides comprehensive error handling through the `DearAppsError` enum:

```swift
do {
    let app = try await api.getApp(bundleId: "com.example.app")
} catch DearAppsError.appNotFound {
    print("App not found")
} catch DearAppsError.noResults {
    print("No results found")
} catch DearAppsError.httpError(let statusCode) {
    print("HTTP error: \(statusCode)")
} catch {
    print("Other error: \(error)")
}
```

## Vapor Compatibility

When using DearApps with Vapor, extend the DTO models to conform to Vapor's protocols:

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

## Best Practices

1. **Localization**: Always consider using the appropriate locale for your users:
```swift
let frenchApp = try await api.getApp(
    bundleId: "com.example.app",
    locale: Locale(identifier: "fr_FR")
)
```

2. **Error Handling**: Always handle potential errors appropriately in production code
3. **URLSession**: Consider using a custom URLSession for better control over network behavior
4. **Rate Limiting**: Be mindful of App Store API rate limits in production environments

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Support

If you encounter any issues or have questions, please [create an issue](https://github.com/nicolasvergoz/DearApps/issues/new) on GitHub.
