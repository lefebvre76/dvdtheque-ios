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
        self.showAuthView = false
    }
    
    func managerError(error: Error) {
        switch error {
        case ApiService.ApiError.unauthorized:
            self.showAuthView = true
        default:
            print(error)
        }
    }
}
