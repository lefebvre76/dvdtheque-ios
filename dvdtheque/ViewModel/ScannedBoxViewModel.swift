//
//  AddBoxViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 16/01/2024.
//

import Foundation

class ScannedBoxViewModel: AuthContainerViewModel {

    public let box: Box
    private var completion: (() -> Void)?
    
    init(box: Box, completion: (() -> Void)? = nil) {
        self.box = box
        self.completion = completion
    }
    
    func close() {
        completion?()
    }

    func add(wishlist: Bool) {
        addBox(id: box.id, wishlist: wishlist)
    }
}

extension ScannedBoxViewModel {
    private func addBox(id: Int, wishlist: Bool) {
        Task {
            do {
                _ = try await apiService.postMyBoxes(id: id, wishlist: wishlist)
            } catch {
                self.managerError(error: error)
            }
        }
    }
}
