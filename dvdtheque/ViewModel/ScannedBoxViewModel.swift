//
//  AddBoxViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 16/01/2024.
//

import Foundation

class ScannedBoxViewModel: AuthContainerViewModel {

    public var box: Box
    private var completion: ((String?) -> Void)?
    @Published public var showLoanForm = false
    @Published public var isBorrow = false
    
    init(box: Box, completion: ((String?) -> Void)? = nil) {
        self.box = box
        self.completion = completion
        super.init(loading: false)
    }
    
    func close(message: String? = nil) {
        completion?(message)
    }

    func add(wishlist: Bool) {
        addBox(id: box.id, wishlist: wishlist)
    }

    func removeLoan(id: Int) {
        showLoading(value: true)
        Task {
            do {
                _ = try await apiService.deleteLoan(id: id)
                close()
            } catch {
                self.managerError(error: error)
            }
            showLoading(value: false)
        }
    }
}

extension ScannedBoxViewModel {
    private func addBox(id: Int, wishlist: Bool) {
        showLoading(value: true)
        Task {
            do {
                _ = try await apiService.postMyBoxes(id: id, wishlist: wishlist)
                close(message: wishlist ? "box.added_to_wishlist".localized(arguments: box.title) : "box.added_to_collection".localized(arguments: box.title))
            } catch {
                self.managerError(error: error)
            }
            showLoading(value: false)
        }
    }
}
