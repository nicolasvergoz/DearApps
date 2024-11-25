import StickerFoundation

public struct SearchResponseDTO: Decodable {
  public let resultCount: Int
  public let results: [SearchResult]
  
  private enum CodingKeys: String, CodingKey {
    case resultCount, results
  }
}

public enum SearchResult: Decodable {
  case application(ApplicationDTO)
  case developer(DeveloperDTO)
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let application = try? container.decode(ApplicationDTO.self) {
      self = .application(application)
    } else if let developer = try? container.decode(DeveloperDTO.self) {
      self = .developer(developer)
    } else {
      throw DecodingError.typeMismatch(SearchResult.self, DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Data matches neither ApplicationDTO nor DeveloperDTO"
      ))
    }
  }
}
