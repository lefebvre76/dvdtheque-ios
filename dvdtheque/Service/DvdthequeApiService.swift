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
        case register
        case logout
        case me
        case myBoxes
        case boxes
        case box(id: Int)
        case setMyBoxes(id: Int)
        
        func path() -> String {
            switch self {
            case .login:
                return "login"
            case .register:
                return "register"
            case .logout:
                return "logout"
            case .me:
                return "me"
            case .boxes:
                return "boxes"
            case let .box(id):
                return "boxes/\(id)"
            case let .setMyBoxes(id):
                return "me/boxes/\(id)"
            case .myBoxes:
                return "me/boxes"
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
    
    func register(name: String, email: String, password: String, confirmation: String) async throws -> String {
        let (data, reponse) = try await self.call(url: Endpoint.register.absoluteURL, httpMethod: .post, parameters: [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": confirmation
        ], withBearerToken: false)
        print(reponse)
        let decoded = try JSONDecoder().decode(AuthResponse.self, from: data)
        return decoded.token
    }

    func getUserInformations() async throws -> User {
        let (data, _) = try await self.call(url: Endpoint.me.absoluteURL)
        let decoded = try JSONDecoder().decode(User.self, from: data)
        return decoded
    }
    
    func updateUserInformations(parameters: [String: Any]) async throws -> User {
        let (data, _) = try await self.call(url: Endpoint.me.absoluteURL, httpMethod: .put, parameters: parameters)
        let decoded = try JSONDecoder().decode(User.self, from: data)
        return decoded
    }
    
    func logout() async throws {
        let (_, _) = try await self.call(url: Endpoint.logout.absoluteURL, httpMethod: .post)
    }
    
    func getMeBoxes(wishlist: Bool = false, page: Int = 1, search: String? = nil) async throws -> LightBoxResponse {
        let (data, _) = try await self.call(url: Endpoint.myBoxes.absoluteURL.appending(parameters: [
            "wishlist": wishlist,
            "page": page
        ]))
        let decoded = try JSONDecoder().decode(LightBoxResponse.self, from: data)
        return decoded
    }
    
    func getBox(id: Int = 1) async throws -> Box {
        let (data, _) = try await self.call(url: Endpoint.box(id: id).absoluteURL)
        let decoded = try JSONDecoder().decode(Box.self, from: data)
        return decoded
    }
    
    func getBox(barCode: String) async throws -> Box {
        let (data, _) = try await self.call(url: Endpoint.boxes.absoluteURL, httpMethod: .post, parameters: [
            "bar_code": barCode
        ])
        let decoded = try JSONDecoder().decode(Box.self, from: data)
        return decoded
    }

    func postMyBoxes(id: Int, wishlist: Bool) async throws -> Box {
        let (data, _) = try await self.call(url: Endpoint.setMyBoxes(id: id).absoluteURL, httpMethod: .post, parameters: [
            "wishlist": wishlist
        ])
        let decoded = try JSONDecoder().decode(Box.self, from: data)
        return decoded
    }
    
    func deleteMyBoxes(id: Int) async throws {
        let (_, _) = try await self.call(url: Endpoint.setMyBoxes(id: id).absoluteURL, httpMethod: .delete)
    }
}
