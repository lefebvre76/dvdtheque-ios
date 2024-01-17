//
//  UserViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import Foundation

class UserViewModel: AuthContainerViewModel {

    @Published public var user: User?
    @Published public var editionPagePresented = false

    private var persistance = Persistance()
    
    override func userIsLogged() {
        super.userIsLogged()
        loadUserInformations()
    }

    func loadUserInformations() {
        showLoading(value: true)
        Task {
            do {
                let data = try await apiService.getUserInformations()
                await setUser(data)
            } catch {
                self.managerError(error: error)
            }
            showLoading(value: false)
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
    
    public func showEditionPage() {
        Task {
            await setEditionPagePresented(true)
        }
    }

    public func hideEditionPage() {
        Task {
            await setEditionPagePresented(false)
        }
    }

    public func updateUser(user: User) {
        Task {
            await setUser(user)
        }
    }
    
    @MainActor private func setEditionPagePresented(_ value: Bool) {
        editionPagePresented = value
    }
    
    @MainActor private func setShowAuthView(_ value: Bool) {
        showAuthView = value
    }

    @MainActor private func setUser(_ value: User?) {
        user = value
    }
}
