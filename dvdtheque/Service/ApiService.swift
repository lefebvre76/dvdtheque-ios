//
//  ApiService.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import Foundation
import Combine

class ApiService {
    
    private var persistance = Persistance()

    enum ApiError: Error {
        case unauthorized
        case unprocessableEntity(_ errors: [String: Any])
        case notFound
        case other
    }
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }

    func call(url: URL, httpMethod: Method = .get, parameters: [String: Any]? = nil, withBearerToken: Bool = true) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if withBearerToken {
            if let token = persistance.get(key: .token) {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                throw ApiError.unauthorized
            }
        }
        request.httpMethod = httpMethod.rawValue
        if let params = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch {
                throw ApiError.other
            }
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 300 {
            switch httpResponse.statusCode {
            case 401:
                throw ApiError.unauthorized
            case 404:
                throw ApiError.notFound
            case 422:
                let json = (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) ?? [:]
                throw ApiError.unprocessableEntity(json)
            default:
                throw ApiError.other
            }
        }
        
        return (data, response)
    }
}
