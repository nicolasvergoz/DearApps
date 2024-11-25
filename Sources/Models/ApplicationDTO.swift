import Foundation

public struct ApplicationDTO: Codable {
  public let wrapperType: SearchResultTypeDTO
  public let artistId: Int
  public let artistName: String
  public let isGameCenterEnabled: Bool
  public let features: [String]
  public let supportedDevices: [String]
  public let advisories: [String]
  public let kind: String
  public let artistViewUrl: String
  public let artworkUrl60: String
  public let artworkUrl100: String
  public let artworkUrl512: String
  public let screenshotUrls: [String]
  public let ipadScreenshotUrls: [String]
  public let appletvScreenshotUrls: [String]
  public let genres: [String]
  public let price: Double
  public let bundleId: String
  public let releaseDate: String
  public let genreIds: [String]
  public let primaryGenreName: String
  public let primaryGenreId: Int
  public let trackId: Int
  public let trackName: String
  public let sellerName: String
  public let isVppDeviceBasedLicensingEnabled: Bool
  public let currentVersionReleaseDate: String
  public let releaseNotes: String
  public let version: String
  public let currency: String
  public let description: String
  public let minimumOsVersion: String
  public let trackCensoredName: String
  public let averageUserRating: Double
  public let trackViewUrl: String
  public let contentAdvisoryRating: String
  public let averageUserRatingForCurrentVersion: Double
  public let userRatingCountForCurrentVersion: Int
  public let trackContentRating: String
  public let languageCodesISO2A: [String]
  public let fileSizeBytes: String
  public let formattedPrice: String
  public let userRatingCount: Int
}
