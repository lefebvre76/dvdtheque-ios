//
//  BoxViewDetail.swift
//  dvdtheque
//
//  Created by loic lefebvre on 20/12/2023.
//

import Foundation
import SwiftUI

class BoxViewModel: AuthContainerViewModel {
    @Published public var box: Box?
    @Published public var showActionDialog = false
    
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

    func delete() {
        showLoading(value: true)
        Task {
            do {
                try await apiService.deleteMyBoxes(id: self.lightBox.id)
            } catch {
                self.managerError(error: error)
                self.showToast(title: "general.error", isError: true)
            }
        }
        showLoading(value: false)
    }

    func moveToCollection() {
        showLoading(value: true)
        Task {
            do {
                let box = try await apiService.postMyBoxes(id: self.lightBox.id, wishlist: false)
                await setBox(box)
            } catch {
                self.managerError(error: error)
                self.showToast(title: "general.error", isError: true)
            }
        }
        showLoading(value: false)
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
