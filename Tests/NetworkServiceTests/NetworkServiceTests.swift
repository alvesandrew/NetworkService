import XCTest
@testable import NetworkService

final class NetworkServiceTests: XCTestCase {
    
    private let testURL = "https://www.dnd5eapi.co/api/classes"
    private var network: NetworkServiceProtocol!
    
    override func setUp() {
        network = NetworkService(session: setupNetwork(with: setupModelMock(error: nil, response: nil)))
    }
    
    override func tearDown() {
        network = nil
    }
    
    func testing_response_success() {
        
        var successfulModel: SuccessfulCodableModelMock?
        
        let dataRequest = DataRequestMock()
        let expectation = expectation(description: "loading class list request")
        
        network.request(dataRequest, decodableModel: SuccessfulCodableModelMock.self) { result in
            switch result {
            case .success(let model):
                successfulModel = model
                expectation.fulfill()
            case .failure: break
            }
        }
        
        waitForExpectations(timeout: 3)
        
        XCTAssertNotNil(successfulModel)
        XCTAssertNotNil(successfulModel?.results)
        XCTAssertEqual(successfulModel?.count, 1)
    }
    
    func testing_decode_error() {
        
        var decodeError: NetworkServiceError?
        
        let dataRequest = DataRequestMock()
        let expectation = expectation(description: "failure decode with list class request")
        
        network.request(dataRequest, decodableModel: FailureCodableModelMock.self) { result in
            switch result {
            case .success: break
            case .failure(let error):
                decodeError = error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)
        
        XCTAssertNotNil(decodeError)
        XCTAssertEqual(decodeError, NetworkServiceError.decodeError)
    }
    
    func testing_connectivity_failure() {
        
        var callbackError: NetworkServiceError?
        
        let dataRequest = DataRequestMock()
        let expectation = expectation(description: "network connectivity failure")
        
        network.isConnect = false
        network.request(dataRequest, decodableModel: SuccessfulCodableModelMock.self) { result in
            switch result {
            case .success: break
            case .failure(let error):
                callbackError = error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)
        
        XCTAssertNotNil(callbackError)
        XCTAssertEqual(callbackError, NetworkServiceError.connectionFailure)
    }
    
    func testing_generic_error() {
        
        var callbackError: NetworkServiceError?
        
        let dataRequest = DataRequestMock()
        let expectation = expectation(description: "network generic error")
        
        let setupModelMock = setupModelMock(error: NetworkServiceError.sessionError, response: nil)
        network = NetworkService(session: setupNetwork(with: setupModelMock))
        
        network.request(dataRequest, decodableModel: SuccessfulCodableModelMock.self) { result in
            switch result {
            case .success: break
            case .failure(let error):
                callbackError = error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)
        
        XCTAssertNotNil(callbackError)
        XCTAssertEqual(callbackError, NetworkServiceError.sessionError)
    }
    
    func testing_status_code_error() {
        
        var callbackError: NetworkServiceError?
        
        let dataRequest = DataRequestMock()
        let expectation = expectation(description: "status code error")
        
        let setupModelMock = setupModelMock(error: nil, response: HTTPURLResponse(url: URL(string: testURL)!,
                                                                                  statusCode: 500,
                                                                                  httpVersion: nil,
                                                                                  headerFields: nil))
        network = NetworkService(session: setupNetwork(with: setupModelMock))
        
        network.request(dataRequest, decodableModel: SuccessfulCodableModelMock.self) { result in
            switch result {
            case .success: break
            case .failure(let error):
                callbackError = error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)
        
        XCTAssertNotNil(callbackError)
        XCTAssertEqual(callbackError, NetworkServiceError.httpError)
    }
    
    func testing_without_data_error() {
        
        var callbackError: NetworkServiceError?
        
        let dataRequest = DataRequestMock()
        let expectation = expectation(description: "request without data error")
        
        let setupModelMock = setupModelMock(data: nil, error: nil, response: nil)
        network = NetworkService(session: setupNetwork(with: setupModelMock))
        
        network.request(dataRequest, decodableModel: SuccessfulCodableModelMock.self) { result in
            switch result {
            case .success: break
            case .failure(let error):
                callbackError = error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)

        XCTAssertNotNil(callbackError)
        XCTAssertEqual(callbackError, NetworkServiceError.dataError)
    }
    
    func testing_without_url_error() {
        
        var callbackError: NetworkServiceError?
        
        let dataRequest = DataRequestWithoutUrlMock()
        let expectation = expectation(description: "status code error")
        
        network.request(dataRequest, decodableModel: SuccessfulCodableModelMock.self) { result in
            switch result {
            case .success: break
            case .failure(let error):
                callbackError = error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)

        XCTAssertNotNil(callbackError)
        XCTAssertEqual(callbackError, NetworkServiceError.urlRequestError)
    }
}
