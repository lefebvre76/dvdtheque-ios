//
//  LoginViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import Foundation
import lefebvre76_utilities
import Combine

class LoginViewModel: ObservableObject {

    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var errorMessage: String?
    @Published public var load: Bool = false

    private var apiService = DvdthequeApiService()
    private var persistance = Persistance()
    private var completion: (() -> Void)?

    init(completion: @escaping () -> Void) {
        self.completion = completion
        if let email = persistance.get(key: .email) as? String {
            Task {
                await setEmail(email)
            }
        }
    }
    
    func auth() {
        Task {
            await setErrorMessage(nil)
            await setLoad(true)
            do {
                let response = try await apiService.auth(email: email, password: password)
                persistance.persiste(key: .email, value: self.email)
                persistance.persiste(key: .token, value: response)
                await setLoad(false)
                self.completion?()
            } catch ApiService.ApiError.unprocessableEntity(let errors) {
                if let message = errors["message"] as? String {
                    await setErrorMessage(message)
                } else {
                    await setErrorMessage("general.error".localized())
                }
                await setLoad(false)
            } catch {
                await setErrorMessage("general.error".localized())
                await setLoad(false)
            }
        }
    }
}

extension LoginViewModel {
    @MainActor private func setEmail(_ value: String) {
        email = value
    }
    
    @MainActor private func setErrorMessage(_ value: String?) {
        errorMessage = value
    }
    
    @MainActor private func setLoad(_ value: Bool) {
        load = value
    }
}
