//
//  CreateLoanViewModel.swift
//  dvdtheque
//
//  Created by loic lefebvre on 22/01/2024.
//

import Foundation

class CreateLoanViewModel: AuthContainerViewModel {

    public var box: LightBox
    public var isBorrow: Bool
    public var parentBox: LightBox?
    private var completion: (() -> Void)?

    @Published public var load: Bool = false

    @Published public var contact: String = ""
    @Published public var comment: String = ""
    @Published public var showReminder: Bool = false
    @Published public var reminder: Date = Date.now.addingTimeInterval(3600*24*30)
    
    @Published public var errorMessage: String?
    @Published public var contactErrors: [String] = []
    @Published public var commentErrors: [String] = []
    @Published public var reminderErrors: [String] = []

    init(box: Box, parentBox: Box?, isBorrow: Bool = false, completion: (() -> Void)? = nil) {
        self.box = LightBox(id: box.id, type: box.type, title: box.title, illustration: box.illustration, loaned: false)
        self.completion = completion
        self.isBorrow = isBorrow
        super.init(loading: false)
    }

    func persisteLoan() {
        Task {
            await setLoad(true)
            await setContactErrors([])
            await setCommentErrors([])
            await setReminderErrors([])
            do {
                var parameters: [String: Any] = [
                    "box_id": self.box.id,
                    "contact": self.contact,
                    "comment": self.comment,
                    "type": isBorrow ? "BORROW" : "LOAN"
                ]
                if showReminder {
                    parameters["reminder"] = Int(self.reminder.timeIntervalSince1970)
                }
                try await apiService.postLoan(parameters: parameters)
                await setLoad(false)
                if let completion = self.completion {
                    completion()
                }
            } catch ApiService.ApiError.unprocessableEntity(let errors) {
                if let messages = errors["errors"] as? [String: Any] {
                    if let items = messages["contact"] as? [String] {
                        await setContactErrors(items)
                    }
                    if let items = messages["comment"] as? [String] {
                        await setCommentErrors(items)
                    }
                    if let items = messages["reminder"] as? [String] {
                        await setReminderErrors(items)
                    }
                } else if let message = errors["message"] as? String {
                    await setErrorMessage(message)
                } else {
                    await setErrorMessage("general.error".localized())
                }
                await setLoad(false)
            } catch {
                await setErrorMessage("general.error".localized())
                await setLoad(false)
            }
        }
    }
}

extension CreateLoanViewModel {
    
    @MainActor private func setErrorMessage(_ value: String?) {
        errorMessage = value
    }

    @MainActor private func setLoad(_ value: Bool) {
        load = value
    }

    @MainActor private func setContactErrors(_ value: [String]) {
        contactErrors = value
    }
    
    @MainActor private func setCommentErrors(_ value: [String]) {
        commentErrors = value
    }

    @MainActor private func setReminderErrors(_ value: [String]) {
        reminderErrors = value
    }
}
