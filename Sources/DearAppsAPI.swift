import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public actor DearAppsAPI {

  private let urlSession: URLSession
  private let locale: Locale
  private let baseURL: URL = URL(string: "https://itunes.apple.com")!

  public init(urlSession: URLSession = .shared, locale: Locale = .current) {
    self.urlSession = urlSession
    self.locale = locale
  }

  /// Get App Informations by bundleId
  public func getApp(bundleId: String) async throws -> ApplicationDTO {
    var url: URL = baseURL
    let language = locale.language.languageCode?.identifier.lowercased() ?? "en"
    if language != "en" { url.appendPathComponent(language) }
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
  public func getApp(appStoreId: Int) async throws -> ApplicationDTO {
    var url: URL = baseURL
    let language = locale.language.languageCode?.identifier.lowercased() ?? "en"
    if language != "en" { url.appendPathComponent(language) }
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
  public func getOtherApps(bundleId: String) async throws -> [ApplicationDTO] {
    let app = try await getApp(bundleId: bundleId)
    return try await getApps(developerId: app.artistId)
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
  public func getApps(developerId: Int) async throws -> [ApplicationDTO] {
    var url = baseURL
    let language = locale.language.languageCode?.identifier.lowercased() ?? "en"
    if language != "en" { url.appendPathComponent(language) }
    url = url.appendingPathComponent("lookup")
    url.append(queryItems: [
      URLQueryItem(name: "id", value: "\(developerId)"),
      URLQueryItem(name: "entity", value: "software"),
      
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
  private func performRequest<T: Decodable>(method: HTTPMethod, url: URL) async throws -> T {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

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
