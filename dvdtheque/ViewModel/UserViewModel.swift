//
//  UserViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import Foundation

class UserViewModel: AuthContainerViewModel {

    @Published public var user: User?

    private var persistance = Persistance()
    
    override func userIsLogged() {
        super.userIsLogged()
        loadUserInformations()
    }

    func loadUserInformations() {
        Task {
            do {
                let data = try await apiService.getUserInformations()
                await setUser(data)
            } catch {
                self.managerError(error: error)
            }
        }
    }
    
    func logout() {
        Task {
            do {
                try await apiService.logout()
                persistance.clear(key: .token)
                await setShowAuthView(true)
            } catch {
                self.managerError(error: error)
            }
        }
    }
    
    @MainActor private func setShowAuthView(_ value: Bool) {
        showAuthView = value
    }

    @MainActor private func setUser(_ value: User?) {
        user = value
    }
}
