//
//  BoxViewDetail.swift
//  dvdtheque
//
//  Created by loic lefebvre on 20/12/2023.
//

import Foundation

class BoxViewModel: AuthContainerViewModel {

    @Published public var box: Box?
    
    public let lightBox: LightBox

    init(lightBox: LightBox) {
        self.lightBox = lightBox
    }
    
    override func userIsLogged() {
        super.userIsLogged()
        loadData()
    }

    func loadData() {
        showLoading(value: true)
        Task {
            await self.loadDetails()
        }
    }
    
    private func loadDetails() async {
        do {
            let response = try await apiService.getBox(id: self.lightBox.id)
            await setBox(response)
        } catch {
            self.managerError(error: error)
        }
        showLoading(value: false)
    }
}

extension BoxViewModel {
    @MainActor private func setBox(_ value: Box) {
        box = value
    }
}
