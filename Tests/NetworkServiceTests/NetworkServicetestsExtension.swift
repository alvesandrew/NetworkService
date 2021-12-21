import Foundation

extension NetworkServiceTests {
    
    func setupModelMock(data: Data? = ResponseMock().modelMock(), error: Error?, response: HTTPURLResponse?) -> URLProtocolMockModel {
        URLProtocolMockModel(data: data, error: error, response: response)
    }
    
    func setupNetwork(with urlprotocolmodel: URLProtocolMockModel) -> URLSession {
        
        URLProtocolMock.modelMock = URLProtocolMockModel(data: urlprotocolmodel.data,
                                                         error: urlprotocolmodel.error,
                                                         response: urlprotocolmodel.response)

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }
}
