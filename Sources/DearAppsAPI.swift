import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// A client for interacting with the iTunes App Store API.
/// This client provides methods to fetch information about apps and developers.
/// Example usage:
/// ```swift
/// let api = DearAppsAPI()
/// let app = try await api.getApp(bundleId: "com.example.app")
/// ```
public actor DearAppsAPI {

  public enum Constants {
    public static let baseURL = URL(string: "https://itunes.apple.com")!
    public static let contentType = "application/json"
    public static let entitySoftware = "software"
  }

  private let urlSession: URLSession
  private let globalLocale: Locale?
  private let baseURL: URL

  /// Initialize a new DearAppsAPI client
  /// - Parameters:
  ///   - urlSession: The URLSession to use for network requests. Defaults to URLSession.shared
  ///   - locale: The default locale to use for requests. Defaults to current locale
  ///   - baseURL: The base URL for the API. Defaults to iTunes API URL
  public init(
    urlSession: URLSession = .shared,
    locale globalLocale: Locale? = .current,
    baseURL: URL = Constants.baseURL
  ) {
    self.urlSession = urlSession
    self.globalLocale = globalLocale
    self.baseURL = baseURL
  }

  /// Get App Informations by bundleId
  public func getApp(bundleId: String, locale: Locale? = nil) async throws -> ApplicationDTO {
    var url: URL = baseURL
    url.addLanguageToURL(locale: locale ?? self.globalLocale)
    url = url.appendingPathComponent("lookup")
    url.append(queryItems: [
      URLQueryItem(name: "bundleId", value: bundleId)
    ])
    let result: SearchResponseDTO = try await performRequest(method: .get, url: url)
    guard result.resultCount > 0 else { throw DearAppsError.noResults }
    let apps: [ApplicationDTO] = result.results.compactMap {
      switch $0 {
      case .application(let app): app
      case .developer(_): nil
      }
    }
    guard let app = apps.first(where: { $0.wrapperType == .software }) else {
      throw DearAppsError.appNotFound
    }
    return app
  }

  /// Get App Informations by AppStore Id
  public func getApp(appStoreId: Int, locale: Locale? = nil) async throws -> ApplicationDTO {
    var url: URL = baseURL
    url.addLanguageToURL(locale: locale ?? self.globalLocale)
    url = url.appendingPathComponent("lookup")
    url.append(queryItems: [
      URLQueryItem(name: "id", value: "\(appStoreId)")
    ])
    let result: SearchResponseDTO = try await performRequest(method: .get, url: url)
    guard result.resultCount > 0 else { throw DearAppsError.noResults }
    let apps: [ApplicationDTO] = result.results.compactMap {
      switch $0 {
      case .application(let app): app
      case .developer(_): nil
      }
    }
    guard let app = apps.first else {
      throw DearAppsError.appNotFound
    }
    return app
  }

  /// Get Other Apps of from same Developer by current app's bundleId
  public func getOtherApps(bundleId: String, excludeCurrentId: Bool = false, locale: Locale? = nil) async throws -> [ApplicationDTO] {
    let app = try await getApp(bundleId: bundleId)
    let apps = try await getApps(developerId: app.artistId, locale: locale)
    if excludeCurrentId {
      return apps.filter { $0.bundleId != bundleId }
    } else {
      return apps
    }
  }

  /// Get Developer Informations
  public func getDeveloper(developerId: Int) async throws -> DeveloperDTO {
    var url = baseURL
    url.append(queryItems: [
      URLQueryItem(name: "id", value: "\(developerId)")
    ])
    url = url.appendingPathComponent("lookup")
    let result: SearchResponseDTO = try await performRequest(method: .get, url: url)
    guard result.resultCount > 0 else { throw DearAppsError.noResults }
    let developers: [DeveloperDTO] = result.results.compactMap {
      switch $0 {
      case .application(_): nil
      case .developer(let dev): dev
      }
    }
    guard let developer = developers.first else {
      throw DearAppsError.developerNotFound
    }
    return developer
  }

  /// Get Developer's Apps
  public func getApps(developerId: Int, locale: Locale? = nil) async throws -> [ApplicationDTO] {
    var url = baseURL
    url.addLanguageToURL(locale: locale ?? self.globalLocale)
    url = url.appendingPathComponent("lookup")
    url.append(queryItems: [
      URLQueryItem(name: "id", value: "\(developerId)"),
      URLQueryItem(name: "entity", value: Constants.entitySoftware),
    ])
    let result: SearchResponseDTO = try await performRequest(method: .get, url: url)
    guard result.resultCount > 0 else { throw DearAppsError.noResults }
    let apps: [ApplicationDTO] = result.results.compactMap {
      switch $0 {
      case .application(let app): app
      case .developer(_): nil
      }
    }
    return apps
  }

  /// Perform a request
  /// - Parameters:
  ///   - method: The HTTP method to use
  ///   - url: The URL to request
  /// - Returns: Decoded response of type T
  /// - Throws: DearAppsError if the request fails
  private func performRequest<T: Decodable>(method: HTTPMethod, url: URL) async throws -> T {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.setValue(Constants.contentType, forHTTPHeaderField: "Content-Type")

    do {
      let (data, response) = try await urlSession.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse else {
        throw DearAppsError.invalidResponse
      }

      guard (200...299).contains(httpResponse.statusCode) else {
        throw DearAppsError.httpError(statusCode: httpResponse.statusCode)
      }

      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch let decodingError as DecodingError {
      throw DearAppsError.decodingError(decodingError)
    } catch {
      throw DearAppsError.networkError(error)
    }
  }
}

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case patch = "PATCH"
}

enum DearAppsError: Error {
  case appNotFound
  case developerNotFound
  case noResults
  case invalidResponse
  case httpError(statusCode: Int)
  case decodingError(DecodingError)
  case networkError(Error)
}

extension URL {
  public mutating func addLanguageToURL(locale: Locale?) {
    if let locale: Locale,
      let language: String = locale.language.languageCode?.identifier.lowercased(),
      language != "en" {
      self.appendPathComponent(language)
    }
  }
}