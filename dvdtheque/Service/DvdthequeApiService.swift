//
//  DvdthequeApi.swift
//  dvdtheque
//
//  Created by loic lefebvre on 15/12/2023.
//

import Foundation


class DvdthequeApiService: ApiService {
    
    enum Endpoint {
        
        static let baseURL: String  = "https://dvd.llefebvre.fr/api/"
//        static let baseURL: String  = "http://192.168.1.62/api/"

        case login
        case register
        case logout
        case me
        case myBoxes
        case myMovies
        case boxes
        case loans
        case loan(id: Int)
        case box(id: Int)
        case movie(id: Int)
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
            case .loans:
                return "loans"
            case let .loan(id):
                return "loans/\(id)"
            case .boxes:
                return "boxes"
            case let .box(id):
                return "boxes/\(id)"
            case let .setMyBoxes(id):
                return "me/boxes/\(id)"
            case .myBoxes:
                return "me/boxes"
            case .myMovies:
                return "me/movies"
            case .movie(id: let id):
                return "movies/\(id)"
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
    
    func getMeBoxes(wishlist: Bool = false, page: Int = 1, search: String = "") async throws -> LightBoxResponse {
        let (data, _) = try await self.call(url: Endpoint.myBoxes.absoluteURL.appending(parameters: [
            "wishlist": wishlist,
            "page": page,
            "search": search
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

    func getLoans(page: Int = 1) async throws -> LoanBoxResponse {
        let (data, _) = try await self.call(url: Endpoint.loans.absoluteURL.appending(parameters: [
            "page": page
        ]))
        let decoded = try JSONDecoder().decode(LoanBoxResponse.self, from: data)
        return decoded
    }

    func getLoan(id: Int) async throws -> Loan {
        let (data, _) = try await self.call(url: Endpoint.loan(id: id).absoluteURL)
        let decoded = try JSONDecoder().decode(Loan.self, from: data)
        return decoded
    }
    
    func deleteMyBoxes(id: Int) async throws {
        let (_, _) = try await self.call(url: Endpoint.setMyBoxes(id: id).absoluteURL, httpMethod: .delete)
    }
    
    func postLoan(parameters: [String: Any]) async throws -> Loan {
        let (data, _) = try await self.call(url: Endpoint.loans.absoluteURL, httpMethod: .post, parameters: parameters)
        let decoded = try JSONDecoder().decode(Loan.self, from: data)
        return decoded
    }
    
    func putLoan(id: Int, parameters: [String: Any]) async throws -> Loan {
        let (data, _) = try await self.call(url: Endpoint.loan(id: id).absoluteURL, httpMethod: .put, parameters: parameters)
        let decoded = try JSONDecoder().decode(Loan.self, from: data)
        return decoded
    }
    
    func deleteLoan(id: Int) async throws {
        let (_, _) = try await self.call(url: Endpoint.loan(id: id).absoluteURL, httpMethod: .delete)
    }

    func getMeMovies(page: Int = 1, search: String = "") async throws -> LightBoxResponse {
        let (data, _) = try await self.call(url: Endpoint.myMovies.absoluteURL.appending(parameters: [
            "page": page,
            "search": search
        ]))
        let decoded = try JSONDecoder().decode(LightBoxResponse.self, from: data)
        return decoded
    }
    
    func getMovie(id: Int = 1) async throws -> Movie {
        let (data, _) = try await self.call(url: Endpoint.movie(id: id).absoluteURL)
        let decoded = try JSONDecoder().decode(Movie.self, from: data)
        return decoded
    }
}
