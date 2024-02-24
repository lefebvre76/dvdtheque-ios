//
//  MovieViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import Foundation
import SwiftUI

class MovieViewModel: AuthContainerViewModel {
    @Published public var movie: Movie?
    
    public let lightBox: LightBox

    init(lightBox: LightBox) {
        self.lightBox = lightBox
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

    private func loadDetails() async {
        do {
            let response = try await apiService.getMovie(id: self.lightBox.id)
            await setMovie(response)
        } catch {
            self.managerError(error: error)
        }
        showLoading(value: false)
    }
}

extension MovieViewModel {
    @MainActor private func setMovie(_ value: Movie) {
        movie = value
    }
}
