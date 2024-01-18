//
//  UserEditionViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 12/01/2024.
//

import Foundation

class UserEditionViewModel: AuthContainerViewModel {

    @Published public var username: String
    @Published public var password: String = ""
    @Published public var newPassword: String = ""
    @Published public var newPasswordConfirmation: String = ""

    @Published public var load: Bool = false
    @Published public var errorMessage: String?
    @Published public var passwordErrors: [String] = []
    @Published public var newPasswordErrors: [String] = []
    @Published public var confirmationErrors: [String] = []

    private var completion: ((User?) -> ())?
    
    init(user: User, completion: ((User?) -> ())?) {
        self.username = user.name
        self.completion = completion
        super.init(loading: false)
    }
    
    func close() {
        if let completion = self.completion {
            completion(nil)
        }
    }

    func updateUserInformations() {
        Task {
            await setLoad(true)
            await setPasswordErrors([])
            await setNewPasswordErrors([])
            await setConfirmationErrors([])
            do {
                var parameters = [
                    "name": self.username
                ]
                if newPassword != "" {
                    parameters["password"] = password
                    parameters["new_password"] = newPassword
                    parameters["new_password_confirmation"] = newPasswordConfirmation
                }
                let data = try await apiService.updateUserInformations(parameters: parameters)
                await setLoad(false)
                if let completion = self.completion {
                    completion(data)
                }
            } catch ApiService.ApiError.unprocessableEntity(let errors) {
                if let messages = errors["errors"] as? [String: Any] {
                    if let items = messages["password"] as? [String] {
                        await setPasswordErrors(items)
                    }
                    if let items = messages["new_password"] as? [String] {
                        await setNewPasswordErrors(items)
                    }
                    if let items = messages["new_password_confirmation"] as? [String] {
                        await setConfirmationErrors(items)
                    }
                } else if let message = errors["message"] as? String {
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


extension UserEditionViewModel {
    
    @MainActor private func setErrorMessage(_ value: String?) {
        errorMessage = value
    }
    
    @MainActor private func setPasswordErrors(_ value: [String]) {
        passwordErrors = value
    }
    
    @MainActor private func setNewPasswordErrors(_ value: [String]) {
        newPasswordErrors = value
    }
    
    @MainActor private func setConfirmationErrors(_ value: [String]) {
        confirmationErrors = value
    }
    
    @MainActor private func setLoad(_ value: Bool) {
        load = value
    }
}
