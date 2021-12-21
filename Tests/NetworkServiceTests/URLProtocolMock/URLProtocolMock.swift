import Foundation

struct URLProtocolMockModel {
    var data: Data?
    var error: Error?
    var response: HTTPURLResponse?
}

class URLProtocolMock: URLProtocol {
    
    static var modelMock: URLProtocolMockModel?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let data = URLProtocolMock.modelMock?.data {
            self.client?.urlProtocol(self, didLoad: data)
        }
        
        if let error = URLProtocolMock.modelMock?.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        
        if let response = URLProtocolMock.modelMock?.response {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
            
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
