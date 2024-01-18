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
    
    @Published public var name: String = ""
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var confirmation: String = ""
    @Published public var errorMessages: [String] = []
    
    @Published public var nameErrors: [String] = []
    @Published public var emailErrors: [String] = []
    @Published public var passwordErrors: [String] = []
    @Published public var confirmationErrors: [String] = []
    
    @Published public var load: Bool = false

    @Published public var showRegistration: Bool = false

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
            await setErrorMessage([])
            await setLoad(true)
            do {
                let response = try await apiService.auth(email: email, password: password)
                persistance.persiste(key: .email, value: self.email)
                persistance.persiste(key: .token, value: response)
                await setLoad(false)
                self.completion?()
            } catch ApiService.ApiError.unprocessableEntity(let errors) {
                if let message = errors["message"] as? String {
                    await setErrorMessage([message])
                } else {
                    await setErrorMessage(["general.error".localized()])
                }
                await setLoad(false)
            } catch {
                await setErrorMessage(["general.error".localized()])
                await setLoad(false)
            }
        }
    }
    
    func register() {
        Task {
            await setLoad(true)
            await setNameErrors([])
            await setEmailErrors([])
            await setPasswordErrors([])
            await setConfirmationErrors([])
            do {
                let response = try await apiService.register(name: name, email: email, password: password, confirmation: confirmation)
                persistance.persiste(key: .email, value: self.email)
                persistance.persiste(key: .token, value: response)
                await setLoad(false)
                self.completion?()
            } catch ApiService.ApiError.unprocessableEntity(let errors) {
                if let messages = errors["errors"] as? [String: Any] {
                    if let items = messages["password"] as? [String] {
                        await setPasswordErrors(items)
                    }
                    if let items = messages["name"] as? [String] {
                        await setNameErrors(items)
                    }
                    if let items = messages["email"] as? [String] {
                        await setEmailErrors(items)
                    }
                    if let items = messages["password_confirmation"] as? [String] {
                        await setConfirmationErrors(items)
                    }
                } else if let message = errors["message"] as? String {
                    await setErrorMessage([message])
                } else {
                    await setErrorMessage(["general.error".localized()])
                }
                await setLoad(false)
            } catch {
                print(error)
                await setErrorMessage(["general.error".localized()])
                await setLoad(false)
            }
        }
    }
}

extension LoginViewModel {
    @MainActor private func setEmail(_ value: String) {
        email = value
    }
    
    @MainActor private func setShowRegistration(_ value: Bool) {
        showRegistration = value
    }
    
    @MainActor private func setErrorMessage(_ value: [String]) {
        errorMessages = value
    }
    
    @MainActor private func setEmailErrors(_ value: [String]) {
        emailErrors = value
    }
    
    @MainActor private func setNameErrors(_ value: [String]) {
        nameErrors = value
    }

    @MainActor private func setPasswordErrors(_ value: [String]) {
        passwordErrors = value
    }
    
    @MainActor private func setConfirmationErrors(_ value: [String]) {
        confirmationErrors = value
    }
    
    @MainActor private func setLoad(_ value: Bool) {
        load = value
    }
}
