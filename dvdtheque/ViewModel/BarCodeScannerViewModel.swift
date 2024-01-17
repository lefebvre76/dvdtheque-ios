//
//  BarCodeScannerViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 16/01/2024.
//

import Foundation
import CodeScanner

class BarCodeScannerViewModel: AuthContainerViewModel {
    @Published public var isTorchOn = false
    @Published public var showFoundedBox = false
    @Published public var searchInProgress = false
    @Published public var errorMessage: String?
    @Published public var foundedBox: Box?
    @Published public var scanMode: ScanMode = ScanMode.continuous
    
    override init() {
        super.init()
        showLoading(value: false)
    }
    
    func barCodeFound(response: Result<ScanResult, ScanError>) {
        if case let .success(result) = response {
            searchMovie(barCode: result.string)
        }
    }
    
    func toogleTorch() {
        Task {
            await setIsTorchOn(!isTorchOn)
        }
    }
    
    func closeBoxDetails() {
        Task {
            await setShowFoundedBox(false)
        }
    }

    func showMessage(messageToShow: String? = nil) {
        closeBoxDetails()
        if let message = messageToShow {
            self.showToast(title: message)
        }
    }
}

extension BarCodeScannerViewModel {
    private func searchMovie(barCode: String) {
        if !searchInProgress, !showFoundedBox {
            Task {
                await setSearchInProgress(true)
                await setErrorMessage(nil)
                do {
                    let box = try await apiService.getBox(barCode: barCode)
                    await setFoundedBox(box)
                    await setShowFoundedBox(true)
                    await setIsTorchOn(false)
                    await setSearchInProgress(false)
                } catch {
                    await setSearchInProgress(false)
                    self.managerError(error: error)
                    var message = "general.error".localized()
                    switch error {
                    case ApiService.ApiError.notFound:
                        message = "scan.error".localized()
                    default:
                        message = "general.error".localized()
                    }
                    await setErrorMessage(message)
                }
            }
        }
    }
}

extension BarCodeScannerViewModel {
    
    @MainActor private func setIsTorchOn(_ value: Bool) {
        isTorchOn = value
    }

    @MainActor private func setScanMode(_ value: ScanMode) {
        scanMode = value
    }
    
    @MainActor private func setFoundedBox(_ value: Box?) {
        foundedBox = value
    }
    
    @MainActor private func setShowFoundedBox(_ value: Bool) {
        showFoundedBox = value
    }

    @MainActor private func setSearchInProgress(_ value: Bool) {
        searchInProgress = value
    }

    @MainActor private func setErrorMessage(_ value: String?) {
        errorMessage = value
    }
}
