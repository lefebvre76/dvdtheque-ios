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
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoadMore = false
                self.boxes = []
            }
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
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoadMore = false
                self.boxes.append(contentsOf: response.data)
                self.total = 5
                self.showLoadMore = false
            }
        } catch {
            self.managerError(error: error)
        }
    }
}
