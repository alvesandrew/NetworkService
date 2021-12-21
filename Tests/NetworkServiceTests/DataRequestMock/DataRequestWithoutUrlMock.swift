import Foundation
import NetworkService

class DataRequestWithoutUrlMock: DataRequest {
    var url: String { "" }
    var method: HTTPMethod { .get }
    var headers: [String : String] { [:] }
    var queryItems: [String : String] { [:] }
}
