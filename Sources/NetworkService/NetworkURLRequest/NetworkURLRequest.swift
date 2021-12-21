//
//  File.swift
//  
//
//  Created by Andrew on 09/12/21.
//

import Foundation

protocol NetworkURLRequestProtocol {
    func createUrlRequest(with dataRequest: DataRequest) throws -> URLRequest
}

class NetworkURLRequest: NetworkURLRequestProtocol {
    
    func createUrlRequest(with dataRequest: DataRequest) throws -> URLRequest {
        
        guard let url = URL(string: dataRequest.url), var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkURLRequestError.getUrlComponents
        }
        
        var queryItems: [URLQueryItem] = []
        
        dataRequest.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = dataRequest.method.rawValue
        urlRequest.allHTTPHeaderFields = dataRequest.headers
        
        return urlRequest
    }
}
