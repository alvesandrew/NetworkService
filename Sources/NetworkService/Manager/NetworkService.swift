import Foundation

public protocol NetworkServiceProtocol {
    var isConnect: Bool { get set }
    func request<T: DataRequest, M: Codable>(_ request: T, decodableModel: M.Type, completion: @escaping (Result<M, NetworkServiceError>) -> Void)
}

final public class NetworkService: NetworkServiceProtocol {

    private let session: URLSession
    
    public var isConnect: Bool = Reachability.isConnectedToNetwork()
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func request<T: DataRequest, M: Codable>(_ request: T, decodableModel: M.Type, completion: @escaping (Result<M, NetworkServiceError>) -> Void) {
        
        guard isConnect else {
            return completion(.failure(.connectionFailure))
        }
        
        do {
            let factory: NetworkURLRequestProtocol = NetworkURLRequest()
            let urlRequest = try factory.createUrlRequest(with: request)
            
            session.dataTask(with: urlRequest) { (data, response, error) in
                if let _ = error {
                    return completion(.failure(.sessionError))
                }
                
                if let response = response as? HTTPURLResponse, !(200..<300 ~= response.statusCode) {
                    return completion(.failure(.httpError))
                }
                
                guard let data = data, !data.isEmpty else {
                    return completion(.failure(.dataError))
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decode = try decoder.decode(decodableModel.self, from: data)
                    return completion(.success(decode))
                } catch {
                    return completion(.failure(.decodeError))
                }
            }.resume()
        } catch let error{
            switch error as? NetworkURLRequestError  {
            case .getUrlComponents, .none:
                return completion(.failure(.urlRequestError))
            }
        }
    }
}
