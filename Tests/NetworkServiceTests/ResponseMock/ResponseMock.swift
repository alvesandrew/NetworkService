//
//  File.swift
//  
//
//  Created by Andrew on 09/12/21.
//

import Foundation

class ResponseMock {
    
    func modelMock() -> Data {
        let data = """
        {
            "count": 1,
            "results": [
                {
                    "index":"barbarian",
                    "name":"Barbarian",
                    "url":"/api/classes/barbarian"
                }
            ]
        }
        """.data(using: .utf8)
        
        return data ?? Data()
    }
}
