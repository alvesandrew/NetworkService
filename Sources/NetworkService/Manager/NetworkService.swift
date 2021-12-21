import Foundation

protocol NetworkServiceProtocol {
    var isConnect: Bool { get set }
    func request<T: DataRequest, M: Codable>(_ request: T, decodableModel: M.Type, completion: @escaping (Result<M, NetworkServiceError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    private let networkFactory: NetworkURLRequestProtocol
    private let session: URLSession
    
    var isConnect: Bool = Reachability.isConnectedToNetwork()
    
    init(networkFactory: NetworkURLRequestProtocol = NetworkURLRequest(), session: URLSession = URLSession.shared) {
        self.networkFactory = networkFactory
        self.session = session
    }
    
    func request<T: DataRequest, M: Codable>(_ request: T, decodableModel: M.Type, completion: @escaping (Result<M, NetworkServiceError>) -> Void) {
        
        guard isConnect else {
            return completion(.failure(.connectionFailure))
        }
        
        do {
            let urlRequest = try networkFactory.createUrlRequest(with: request)
            
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
