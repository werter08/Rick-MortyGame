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
                        promise(.failure(APIError.fromAlamofire(error, responseData: response.data)))
                    }
                }

        }
        .eraseToAnyPublisher()
    }
}

struct APIError: LocalizedError {
    let detail: String
    var errorDescription: String? { detail }

    static func fromAlamofire(_ error: Error, responseData: Data?) -> APIError {
        if let data = responseData,
           let message = String(data: data, encoding: .utf8),
           !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           message.hasPrefix("{") || message.hasPrefix("[") {
            if message.contains("\"error\"") {
                return APIError(detail: "Server: \(message)")
            }
        }

        if let af = error as? AFError {
            switch af {
            case .responseSerializationFailed(let reason):
                switch reason {
                case .decodingFailed(let underlying):
                    return APIError(
                        detail: "Could not parse the response. \(underlying.localizedDescription)"
                    )
                default:
                    break
                }
            default:
                break
            }
            return APIError(detail: af.localizedDescription)
        }

        return APIError(detail: error.localizedDescription)
    }
}
