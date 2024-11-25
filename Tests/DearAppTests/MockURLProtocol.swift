import Foundation

class MockURLProtocol: URLProtocol {
  
  enum MockError: Error {
    case invalidURL
  }
  
  nonisolated(unsafe) static var mockURLs: [String : (error: Error?, data: Data?, response: URLResponse?)] = [:]
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func startLoading() {
    guard let url = request.url else { return }
    
    if let (error, data, response) = URLProtocolMock.mockURLs[url.absoluteString] {
      if let response: URLResponse = response {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      }
      if let data = data {
        self.client?.urlProtocol(self, didLoad: data)
      }
      if let error = error {
        self.client?.urlProtocol(self, didFailWithError: error)
      }
    } else {
      self.client?.urlProtocol(self, didFailWithError: MockError.invalidURL)
    }
    
    self.client?.urlProtocolDidFinishLoading(self)
  }
  
  override func stopLoading() { }
}
