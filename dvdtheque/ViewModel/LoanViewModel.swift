//
//  LoanViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import Foundation
import SwiftUI

class LoanViewModel: AuthContainerViewModel {
    @Published public var loan: Loan
    @Published public var showActionDialog = false
    @Published public var showLoanForm = false
    @Published public var isBorrow = false
    
    public let completion: (() -> Void)?

    init(loan: Loan, completion: (() -> Void)? = nil) {
        self.loan = loan
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
                _ = try await apiService.deleteLoan(id: loan.id)
                Notifications().removeNotification(loanId: loan.id)
                self.completion?()
                completionHandler()
            } catch {
                self.managerError(error: error)
            }
            showLoading(value: false)
        }
    }

    private func loadDetails() async {
        do {
            let response = try await apiService.getLoan(id: self.loan.id)
            await setLoan(response)
        } catch {
            self.managerError(error: error)
        }
        showLoading(value: false)
    }
}

extension LoanViewModel {
    @MainActor private func setLoan(_ value: Loan) {
        loan = value
    }

    @MainActor private func setShowLoanForm(_ value: Bool) {
        showLoanForm = value
    }
}
