import Foundation

protocol SearchResultProtocol: Decodable {
  var artistId: Int { get }
}

public struct SearchResponseDTO: Decodable {
  public let resultCount: Int
  public let results: [SearchResultProtocol]
}
