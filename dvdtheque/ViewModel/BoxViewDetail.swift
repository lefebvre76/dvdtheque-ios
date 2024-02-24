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
    @Published public var parent_box: Box?
    @Published public var showActionDialog = false
    @Published public var showLoanForm = false
    @Published public var isBorrow = false
    
    public let lightBox: LightBox
    public let completion: (() -> Void)?

    init(lightBox: LightBox, parent_box: Box? = nil, completion: (() -> Void)? = nil) {
        self.lightBox = lightBox
        self.parent_box = parent_box
        self.completion = completion
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

    func delete(completionHandler: @escaping () -> Void) {
        showLoading(value: true)
        Task {
            do {
                try await apiService.deleteMyBoxes(id: self.lightBox.id)
                self.completion?()
                completionHandler()
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
    
    func removeLoan(id: Int) {
        showLoading(value: true)
        Task {
            do {
                _ = try await apiService.deleteLoan(id: id)
                Notifications().removeNotification(loanId: id)
                await self.loadDetails()
            } catch {
                self.managerError(error: error)
            }
            showLoading(value: false)
        }
    }

    func closeLoanView() {
        Task {
            await setShowLoanForm(false)
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

    @MainActor private func setShowLoanForm(_ value: Bool) {
        showLoanForm = value
    }
}
