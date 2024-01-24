//
//  MyBoxesViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import Foundation

class MyBoxesViewModel: AuthContainerViewModel {

    public var isWishlist: Bool
    
    @Published public var boxes: [LightBox] = []
    @Published public var total: Int = 0
    @Published public var showLoadMore = false
    @Published public var toBeDeleted: LightBox?
    @Published public var showingDeleteAlert = false
    @Published public var searchText = ""

    private var currentPage = 1
    private var searchTimer: Timer?
    
    init(isWishlist: Bool = false) {
        self.isWishlist = isWishlist
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
            await setBoxes([])
            await self.loadBoxes()
        }
    }
    
    func runSearch() {
        if let timer = searchTimer {
            timer.invalidate()
        }
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
            guard let self = self else { return }
            self.loadData()
        }
    }
    
    func launchDeleteItem(box: LightBox) {
        Task {
            await setToBeDeleted(box)
            await setShowingDeleteAlert(true)
        }
    }

    func addToWishlist(box: LightBox) {
        Task {
            do {
                showLoading(value: true)
                _ = try await apiService.postMyBoxes(id: box.id, wishlist: !isWishlist)
                await removeBox(box)
            } catch {
                self.managerError(error: error)
                self.showToast(title: "general.error", isError: true)
            }
            showLoading(value: false)
        }
    }

    func deleteItem() {
        guard let box = toBeDeleted else { return }
        Task {
            do {
                showLoading(value: true)
                _ = try await apiService.deleteMyBoxes(id: box.id)
                await removeBox(box)
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
            await self.loadBoxes()
        }
    }
    
    private func loadBoxes() async {
        do {
            let response = try await apiService.getMeBoxes(wishlist: isWishlist, page: currentPage, search: searchText)
            await addBoxes(response.data)
            await setTotal(response.meta.total)
            await setShowLoadMore(response.meta.current_page < response.meta.last_page)
        } catch {
            self.managerError(error: error)
        }
        showLoading(value: false)
    }
}

extension MyBoxesViewModel {
    
    @MainActor private func addBoxes(_ items: [LightBox]) {
        boxes.append(contentsOf: items)
    }

    @MainActor private func removeBox(_ value: LightBox) {
        guard let index = boxes.firstIndex(where: { $0.id == value.id }) else { return }
        boxes.remove(at: index)
    }
    
    @MainActor private func setToBeDeleted(_ value: LightBox) {
        toBeDeleted = value
    }
    
    @MainActor private func setBoxes(_ items: [LightBox]) {
        boxes = items
    }

    @MainActor private func setShowLoadMore(_ value: Bool) {
        showLoadMore = value
    }
    
    @MainActor private func setShowingDeleteAlert(_ value: Bool) {
        showingDeleteAlert = value
    }
    
    @MainActor private func setTotal(_ value: Int) {
        total = value
    }
}
