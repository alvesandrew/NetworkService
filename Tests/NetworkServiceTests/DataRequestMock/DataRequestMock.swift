import Foundation
import NetworkService

class DataRequestMock: DataRequest {
    var url: String { "https://www.dnd5eapi.co/api/classes" }
    var method: HTTPMethod { .get }
    var headers: [String : String] { [:] }
    var queryItems: [String : String] { ["key":"value"] }
}
