//
//  LoginViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import Foundation

class LoginViewModel: ObservableObject {

    @Published public var email: String = ""
    @Published public var password: String = ""

    private var apiService = DvdthequeApiService()
    private var persistance = Persistance()
    private var completion: (() -> Void)?
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
        if let email = persistance.get(key: .email) as? String {
            self.email = email
        }
    }
    
    func auth() {
        Task {
            do {
                let response = try await apiService.auth(email: email, password: password)
                persistance.persiste(key: .email, value: self.email)
                persistance.persiste(key: .token, value: response)
                self.completion?()
            } catch {
                print(error)
            }
        }
    }
}
