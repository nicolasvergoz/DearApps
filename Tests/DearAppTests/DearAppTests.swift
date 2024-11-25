import XCTest
@testable import DearApp

final class DearAppTests: XCTestCase {
  var api: DearAppAPI!
  var mockSession: URLSession!

  override func setUp() {
    super.setUp()
    let sessionConfiguration = URLSessionConfiguration.ephemeral
    sessionConfiguration.protocolClasses = [MockURLProtocol.self]
    mockSession = URLSession(configuration: sessionConfiguration)
    api = DearAppAPI(urlSession: mockSession, locale: .init(identifier: "en_US"))
  }

  func testGetAppByBundleId() async throws {
    let bundleId = "com.vrgz.per100"
    let appStoreId = 1533526463
    let app: ApplicationDTO = try await api.getApp(bundleId: bundleId)
    XCTAssertEqual(app.artistId, 1533526465)
    XCTAssertEqual(app.bundleId, bundleId)
    XCTAssertEqual(app.trackId, appStoreId)
  }

  func testGetAppByAppStoreId() async throws {
    let bundleId = "com.vrgz.per100"
    let appStoreId = 1533526463
    let app: ApplicationDTO = try await api.getApp(appStoreId: appStoreId)
    XCTAssertEqual(app.artistId, 1533526465)
    XCTAssertEqual(app.bundleId, bundleId)
    XCTAssertEqual(app.trackId, appStoreId)
  }

  func testGetDeveloperById() async throws {
    let appStoreId = 1533526465
    let developer: DeveloperDTO = try await api.getDeveloper(appStoreId: appStoreId)
    XCTAssertEqual(developer.artistId, appStoreId)
  }
}
