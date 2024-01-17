//
//  AddBoxViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 16/01/2024.
//

import Foundation

class ScannedBoxViewModel: AuthContainerViewModel {

    public let box: Box
    private var completion: ((String?) -> Void)?
    
    init(box: Box, completion: ((String?) -> Void)? = nil) {
        self.box = box
        self.completion = completion
    }
    
    func close(message: String? = nil) {
        completion?(message)
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
                close(message: wishlist ? "box.addedToWishlist" : "box.addedToCollection")
            } catch {
                self.managerError(error: error)
            }
        }
    }
}
