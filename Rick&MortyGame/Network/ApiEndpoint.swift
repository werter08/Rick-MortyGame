//
//  Endpoint.swift
//  Academy
//
//  Created by Begench on 20.10.2025.
//

import Alamofire
import Foundation

protocol Endpoint {
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var encoder: ParameterEncoding { get }
    var header: HTTPHeaders { get }
    var body: [String: Codable]? { get }
}

var BASE_URL = "https://rickandmortyapi.com/api"  //Prod


enum Endpoints: Endpoint {
    

    case getCharackter(id: Int)
    
   
    
    var method: Alamofire.HTTPMethod {
        switch self {
        default: .get
            
        }
    }
    
    var path: String {
        var endPath = ""
        switch self { case .getCharackter(let id): endPath = "/character/\(id)" }
        
        return BASE_URL+endPath
    }
    
    var encoder: any Alamofire.ParameterEncoding {
        switch self {
        case .getCharackter: return URLEncoding(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal)
        default: return JSONEncoding.default
        }
    }
        
    
    var header: Alamofire.HTTPHeaders {return ["Content-Type": "application/json"]}
    
    var body: [String: Codable]? { switch self { case .getCharackter: return [:] } }
}



// Custom ParameterEncoder to handle "include[]" correctly
struct CustomURLEncoding: ParameterEncoding {
    
    static let `default` = CustomURLEncoding()
    
    func encode(
        _ urlRequest:  any Alamofire.URLRequestConvertible,
        with parameters: Alamofire.Parameters?
    ) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        // Only modify the request if we have parameters
        guard let parameters = parameters else { return urlRequest }
        
        // Get the URL components of the request
        var components = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)!
        
        // Ensure that the query items are initialized or empty
        var queryItems = components.queryItems ?? []
        
        // Convert parameters into query items
        if parameters is [String: Any] && !parameters.isEmpty {
            for (key, value) in parameters as! [String: Any] {
                if let arrayValue = value as? [String] {
                    // Special handling for arrays (i.e., "include[]")
                    for item in arrayValue {
                        queryItems.append(URLQueryItem(name: "\(key)[]", value: item))
                    }
                } else {
                    queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                }
            }
            
        }

        components.queryItems = queryItems
        
        // Update the URLRequest with the encoded URL
        urlRequest.url = components.url
        
        return urlRequest
    }
}

