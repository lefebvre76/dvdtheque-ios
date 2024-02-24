//
//  MyMoviesViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import Foundation

class MyMoviesViewModel: AuthContainerViewModel {

    @Published public var movies: [LightBox] = []
    @Published public var total: Int = 0
    @Published public var showLoadMore = false
    @Published public var searchText = ""

    private var currentPage = 1
    private var searchTimer: Timer?
    
    override func userIsLogged() {
        super.userIsLogged()
        loadData()
    }

    func loadData() {
        showLoading(value: true)
        currentPage = 1
        Task {
            await setShowLoadMore(false)
            await setMovies([])
            await self.loadMovies()
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

    func loadMoreData() {
        currentPage += 1
        Task {
            await self.loadMovies()
        }
    }
    
    private func loadMovies() async {
        do {
            let response = try await apiService.getMeMovies(page: currentPage, search: searchText)
            await addMovies(response.data)
            await setTotal(response.meta.total)
            await setShowLoadMore(response.meta.current_page < response.meta.last_page)
        } catch {
            self.managerError(error: error)
        }
        showLoading(value: false)
    }
}

extension MyMoviesViewModel {
    
    @MainActor private func addMovies(_ items: [LightBox]) {
        movies.append(contentsOf: items)
    }

    @MainActor private func setMovies(_ items: [LightBox]) {
        movies = items
    }

    @MainActor private func setShowLoadMore(_ value: Bool) {
        showLoadMore = value
    }
    
    @MainActor private func setTotal(_ value: Int) {
        total = value
    }
}
