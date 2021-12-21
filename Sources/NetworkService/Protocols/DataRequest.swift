import Foundation

public protocol DataRequest {
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }
}

extension DataRequest {
    var headers: [String : String] { [:] }
    
    var queryItems: [String : String] { [:] }
}
