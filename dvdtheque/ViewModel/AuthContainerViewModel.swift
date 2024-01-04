//
//  AuthContainerViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import Foundation

class AuthContainerViewModel: ObservableObject {
    @Published public var showAuthView = false

    public var apiService = DvdthequeApiService()

    func userIsLogged() {
        Task {
            await setShowAuthView(false)
        }
    }
    
    func managerError(error: Error) {
        switch error {
        case ApiService.ApiError.unauthorized:
            Task {
                await setShowAuthView(true)
            }
        default:
            print(error)
        }
    }
}

extension AuthContainerViewModel {
    @MainActor private func setShowAuthView(_ value: Bool) {
        showAuthView = value
    }
}
