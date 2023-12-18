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
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.user = data
                }
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
            } catch {
                self.managerError(error: error)
            }
        }
    }
}
