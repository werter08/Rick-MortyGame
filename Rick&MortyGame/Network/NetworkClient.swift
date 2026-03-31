//
//  Network.swift
//  Academy
//
//  Created by Begench on 20.10.2025.
//



import Foundation
import Alamofire
import Combine



class Network {
    class func perform<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        return Future { promise in
            AF.request(endpoint.path,
                       method: endpoint.method,
                       parameters: endpoint.body,
                       encoding: endpoint.encoder,
                       headers: endpoint.header
            )
                .validate()
                .responseDecodable(of: T.self) { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(let data):
                        promise(.success(data))
                    case .failure(let error):
                        if let data = response.data,
                           let message = String(data: data, encoding: .utf8) {
                            promise(.failure(APIError(detail: message)))
                        } else {
                            promise(.failure(APIError(detail: error.localizedDescription)))
                        }
                    }
                }

        }
        .eraseToAnyPublisher()
    }
}

struct APIError: LocalizedError {
    let detail: String
    var errorDescription: String? { detail }
}
