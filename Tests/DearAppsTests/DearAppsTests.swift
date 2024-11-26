import XCTest
@testable import DearApps

final class DearAppsTests: XCTestCase {
  var api: DearAppsAPI!
  var mockSession: URLSession!

  override func setUp() {
    super.setUp()
    api = DearAppsAPI(urlSession: URLSession.shared, locale: .init(identifier: "fr_FR"))
  }

  func testGetAppByBundleId() async throws {
    let bundleId = "com.vrgz.per100"
    let appStoreId = 1533526463
    
    let app: ApplicationDTO = try await api.getApp(bundleId: bundleId)
    
    XCTAssertEqual(app.artistId, 1533526465)
    XCTAssertEqual(app.bundleId, bundleId)
    XCTAssertEqual(app.trackId, appStoreId)
    XCTAssertEqual(app.wrapperType, .software)
    XCTAssertNotEqual(app.wrapperType, .artist)
  }

  func testGetAppByAppStoreId() async throws {
    let bundleId = "com.vrgz.per100"
    let appStoreId = 1533526463
    let developerId = 1533526465
    
    let app: ApplicationDTO = try await api.getApp(appStoreId: appStoreId)
    XCTAssertEqual(app.artistId, developerId)
    XCTAssertEqual(app.bundleId, bundleId)
    XCTAssertEqual(app.trackId, appStoreId)
    XCTAssertEqual(app.wrapperType, .software)
    XCTAssertNotEqual(app.wrapperType, .artist)
  }

  func testGetDeveloperById() async throws {
    let developerId = 1533526465
    
    let developer: DeveloperDTO = try await api.getDeveloper(developerId: developerId)
    XCTAssertEqual(developer.artistId, developerId)
    XCTAssertEqual(developer.wrapperType, .artist)
    XCTAssertNotEqual(developer.wrapperType, .software)
  }
  
  func testGetAppsByDeveloperId() async throws {
    let bundleId = "com.vrgz.redacto"
    let appStoreId = 6451260167
    let developerId = 1533526465
    
    let apps: [ApplicationDTO] = try await api.getApps(developerId: developerId)
    XCTAssertEqual(apps.first?.artistId, developerId)
    XCTAssertEqual(apps.first?.bundleId, bundleId)
    XCTAssertEqual(apps.first?.trackId, appStoreId)
    XCTAssertEqual(apps.first?.wrapperType, .software)
    XCTAssertNotEqual(apps.first?.wrapperType, .artist)
  }
}
