//
//  DvdthequeApi.swift
//  dvdtheque
//
//  Created by loic lefebvre on 15/12/2023.
//

import Foundation

class DvdthequeApiService: ApiService {
    
    enum Endpoint {
        
        static let baseURL: String  = "http://localhost/api/"

        case login
        case logout
        case me
        case myBoxes
        case box(id: Int)
        
        func path() -> String {
            switch self {
            case .login:
                return "login"
            case .logout:
                return "logout"
            case .me:
                return "me"
            case .myBoxes:
                return "me/boxes"
            case let .box(id):
                return "boxes/\(id)"
            }
        }
        
        var absoluteURL: URL {
            URL(string: Endpoint.baseURL + self.path())!
        }
    }
    
    enum ApiError: Error {
        case unauthorized
        case unprocessableEntity(message: [String])
        case notFound
        case other
    }
    
    private struct AuthResponse: Decodable {
        let token: String
    }
    
    func auth(email: String, password: String) async throws -> String {
        let (data, _) = try await self.call(url: Endpoint.login.absoluteURL, httpMethod: .post, parameters: [
            "email": email,
            "password": password
        ], withBearerToken: false)
        let decoded = try JSONDecoder().decode(AuthResponse.self, from: data)
        return decoded.token
    }

    func getUserInformations() async throws -> User {
        let (data, _) = try await self.call(url: Endpoint.me.absoluteURL)
        let decoded = try JSONDecoder().decode(User.self, from: data)
        return decoded
    }
    
    func logout() async throws {
        let (_, _) = try await self.call(url: Endpoint.logout.absoluteURL, httpMethod: .post)
    }
    
    func getMeBoxes(wishlist: Bool = false, page: Int = 1, search: String? = nil) async throws -> LightBoxResponse {
        let (data, _) = try await self.call(url: Endpoint.myBoxes.absoluteURL)
        let decoded = try JSONDecoder().decode(LightBoxResponse.self, from: data)
        return decoded
    }
    
    func getBox(id: Int = 1) async throws -> Box {
        let (data, _) = try await self.call(url: Endpoint.box(id: id).absoluteURL)
        let decoded = try JSONDecoder().decode(Box.self, from: data)
        return decoded
    }
}
