//
//  MyBoxesViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import Foundation

class MyBoxesViewModel: AuthContainerViewModel {

    @Published public var boxes: [LightBox] = []
    @Published public var total: Int = 0
    @Published public var showLoadMore = false

    private var currentPage = 1
    
    override func userIsLogged() {
        super.userIsLogged()
        loadData()
    }

    func loadData() {
        currentPage = 1
        Task {
            await setBoxes([])
            await setShowLoadMore(false)
            await self.loadBoxes()
        }
    }
    
    func loadMoreData() {
        currentPage += 1
        Task {
            await self.loadBoxes()
        }
    }
    
    private func loadBoxes() async {
        do {
            let response = try await apiService.getMeBoxes(wishlist: false, page: currentPage)
            await addBoxes(response.data)
            await setShowLoadMore(false)
            await setTotal(response.meta.total)
        } catch {
            self.managerError(error: error)
        }
    }
}

extension MyBoxesViewModel {
    
    @MainActor private func addBoxes(_ items: [LightBox]) {
        boxes.append(contentsOf: items)
    }
    
    @MainActor private func setBoxes(_ items: [LightBox]) {
        boxes = items
    }

    @MainActor private func setShowLoadMore(_ value: Bool) {
        showLoadMore = value
    }
    
    @MainActor private func setTotal(_ value: Int) {
        total = value
    }
}
