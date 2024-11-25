import Foundation

public struct DeveloperDTO: Codable {
  public let wrapperType: SearchResultTypeDTO
  public let artistId: Int
  public let artistName: String
  public let artistType: String
  public let artistLinkUrl: String
}