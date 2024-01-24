//
//  LoansViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/01/2024.
//

import Foundation

class LoansViewModel: AuthContainerViewModel {

    @Published public var loans: [Loan] = []
    @Published public var total: Int = 0
    @Published public var showLoadMore = false

    private var currentPage = 1
    
    init(isWishlist: Bool = false) {
    }
    
    override func userIsLogged() {
        super.userIsLogged()
        loadData()
    }

    func loadData() {
        showLoading(value: true)
        currentPage = 1
        Task {
            await setShowLoadMore(false)
            await setLoans([])
            await self.loadLoans()
        }
    }

    func deleteItem(loan: Loan) {
        Task {
            do {
                showLoading(value: true)
                _ = try await apiService.deleteLoan(id: loan.id)
                await removeLoan(loan)
            } catch {
                self.managerError(error: error)
                self.showToast(title: "general.error", isError: true)
            }
            showLoading(value: false)
        }
    }
    
    func loadMoreData() {
        currentPage += 1
        Task {
            await self.loadLoans()
        }
    }
    
    private func loadLoans() async {
        do {
            let response = try await apiService.getLoans(page: currentPage)
            await addLoans(response.data)
            await setTotal(response.meta.total)
            await setShowLoadMore(response.meta.current_page < response.meta.last_page)
        } catch {
            self.managerError(error: error)
        }
        showLoading(value: false)
    }
}

extension LoansViewModel {
    
    @MainActor private func addLoans(_ items: [Loan]) {
        loans.append(contentsOf: items)
    }

    @MainActor private func removeLoan(_ value: Loan) {
        guard let index = loans.firstIndex(where: { $0.id == value.id }) else { return }
        loans.remove(at: index)
    }

    @MainActor private func setLoans(_ items: [Loan]) {
        loans = items
    }

    @MainActor private func setShowLoadMore(_ value: Bool) {
        showLoadMore = value
    }

    @MainActor private func setTotal(_ value: Int) {
        total = value
    }
}
