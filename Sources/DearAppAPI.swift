import Foundation

public final class DearAppAPI {

  private let urlSession: URLSession
  private let locale: Locale
  private let baseURL: URL = URL(string: "https://itunes.apple.com")!

  init(urlSession: URLSession = .shared, locale: Locale = .current) {
    self.urlSession = urlSession
    self.locale = locale
  }

  /// Get App Informations by bundleId
  public func getApp(bundleId: String) async throws -> ApplicationDTO {
    var url: URL = baseURL.appendingPathComponent("lookup")
    let language = locale.language.languageCode?.identifier.lowercased() ?? "en"
    if language != "en" { url.appendPathComponent(language) }
    url.appending(queryItems: [
      URLQueryItem(name: "bundleId", value: bundleId)
    ])
    let request = URLRequest(url: url)
    let result: SearchResponseDTO = try await performRequest(method: .get, url: url)
    guard result.resultCount > 0 else { throw DearAppError.noResults }
    let apps: [ApplicationDTO] = result.results.compactMap { $0 as? ApplicationDTO }
    guard let app = apps.first(where: { $0.wrapperType == .software }) else {
      throw DearAppError.appNotFound
    }
    return app
  }

  /// Get App Informations by AppStore Id
  public func getApp(appStoreId: Int) async throws -> ApplicationDTO {
    var url: URL = baseURL.appendingPathComponent("lookup")
    let language = locale.language.languageCode?.identifier.lowercased() ?? "en"
    if language != "en" { url.appendPathComponent(language) }
    url.appending(queryItems: [
      URLQueryItem(name: "id", value: "\(appStoreId)")
    ])
    let request = URLRequest(url: url)
    let result: SearchResponseDTO = try await performRequest(method: .get, url: url)
    guard result.resultCount > 0 else { throw DearAppError.noResults }
    let apps: [ApplicationDTO] = result.results.compactMap { $0 as? ApplicationDTO }
    guard let app = apps.first(where: { $0.wrapperType == .software }) else {
      throw DearAppError.appNotFound
    }
    return app
  }

  /// Get Developer's Apps
  public func getApps(developerId: Int) async throws -> [ApplicationDTO] {
    var url = baseURL.appendingPathComponent("lookup")
    let language = locale.language.languageCode?.identifier.lowercased() ?? "en"
    if language != "en" { url.appendPathComponent(language) }
    url.appending(queryItems: [
      URLQueryItem(name: "id", value: "\(developerId)"),
      URLQueryItem(name: "entity", value: "software"),
      
    ])
    let request = URLRequest(url: url)
    let result: SearchResponseDTO = try await performRequest(method: .get, url: url)
    guard result.resultCount > 0 else { throw DearAppError.noResults }
    return result.results.compactMap { $0 as? ApplicationDTO }
  }

  /// Get Other Apps of from same Developer by current app's bundleId
  public func getOtherApps(bundleId: String) async throws -> [ApplicationDTO] {
    let app = try await getApp(bundleId: bundleId)
    return try await getApps(developerId: app.artistId)
  }

  /// Get Developer Informations
  public func getDeveloper(appStoreId: Int) async throws -> DeveloperDTO {
    var url = baseURL.appendingPathComponent("lookup")
    url.appending(queryItems: [
      URLQueryItem(name: "id", value: "\(appStoreId)")
    ])
    let request = URLRequest(url: url)
    let result: SearchResponseDTO = try await performRequest(method: .get, url: url)
    guard result.resultCount > 0 else { throw DearAppError.noResults }
    let developers: [DeveloperDTO] = result.results.compactMap { $0 as? DeveloperDTO }
    guard let developer = developers.first else {
      throw DearAppError.developerNotFound
    }
    return developer
  }

  /// Perform a request
  private func performRequest<T: Decodable>(method: HTTPMethod, url: URL) async throws -> T {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue

    let (data, _) = try await URLSession.shared.data(for: request)
    let decoder = JSONDecoder()
    let decodedResponse = try decoder.decode(T.self, from: data)
    return decodedResponse
  }
}

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case patch = "PATCH"
}

enum DearAppError: Error {
  case appNotFound
  case developerNotFound
  case noResults
}
