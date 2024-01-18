//
//  AuthContainerViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import Foundation
import AlertToast

class AuthContainerViewModel: ObservableObject {
    @Published public var showAuthView = false
    @Published public var showToast = false
    @Published public var toastType: AlertToast.AlertType = .regular
    @Published public var toastTitle: String?
    @Published public var toastMessage: String?

    @Published public var loading = true

    public var apiService = DvdthequeApiService()

    init(loading: Bool = true) {
        self.loading = loading
    }
    
    func showToast(title: String, message: String? = nil, isError: Bool = false) {
        Task {
            await setToastType(isError ? .error(.red) : .regular)
            await setToastTitle(title)
            await setToastMessage(message)
            await setShowToast(true)
        }
    }
    
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
        case let ApiService.ApiError.other(message):
            showToast(title: message, isError: true)
        default:
            print(error)
        }
    }

    func showLoading(value: Bool) {
        Task {
            await setLoading(value)
        }
    }
}

extension AuthContainerViewModel {
    @MainActor private func setShowAuthView(_ value: Bool) {
        showAuthView = value
    }
    
    @MainActor private func setShowToast(_ value: Bool) {
        showToast = value
    }

    @MainActor private func setToastType(_ value: AlertToast.AlertType) {
        toastType = value
    }
    
    @MainActor private func setToastTitle(_ value: String?) {
        toastTitle = value
    }

    @MainActor private func setToastMessage(_ value: String?) {
        toastMessage = value
    }

    @MainActor private func setLoading(_ value: Bool) {
        loading = value
    }
}
