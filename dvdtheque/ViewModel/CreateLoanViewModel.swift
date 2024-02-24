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
    public var loanId: Int?
    private var completion: ((Loan) -> Void)?

    @Published public var load: Bool = false

    @Published public var contact: String = ""
    @Published public var comment: String = ""
    @Published public var showReminder: Bool = false
    @Published public var reminder: Date = Date.now.addingTimeInterval(3600*24*30) // Add 1 month
    
    @Published public var errorMessage: String?
    @Published public var contactErrors: [String] = []
    @Published public var commentErrors: [String] = []
    @Published public var reminderErrors: [String] = []
    @Published public var showContactSelection = false
    @Published public var selectedContact: PhoneContact?

    init(box: Box, parentBox: Box?, isBorrow: Bool = false, completion: ((Loan) -> Void)? = nil) {
        self.box = LightBox(id: box.id, type: box.type, title: box.title, illustration: box.illustration, loaned: false)
        if let pBox = parentBox {
            self.parentBox = LightBox(id: pBox.id, type: pBox.type, title: pBox.title, illustration: pBox.illustration, loaned: false)
        }
        self.completion = completion
        self.isBorrow = isBorrow
        super.init(loading: false)
    }
    
    init(loan: Loan, completion: ((Loan) -> Void)? = nil) {
        self.loanId = loan.id
        self.contact = loan.contact
        self.comment = loan.comment ?? ""
        if let date = loan.reminderDateToDate() {
            self.showReminder = true
            self.reminder = date
        }
        self.box = loan.box
        self.parentBox = loan.parent_box
        self.isBorrow = loan.type == "BORROW"
        self.completion = completion
        super.init(loading: false)
    }
    
    func askNotificationPermissions() {
        Task {
            let result = await Notifications().notificationPermissions()
            await setShowReminder(result)
        }
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
                if let pBox = parentBox {
                    parameters["box_parent_id"] = pBox.id
                }
                if let id = self.loanId {
                    Notifications().removeNotification(loanId: id)
                    let loan = try await apiService.putLoan(id: id, parameters: parameters)
                    Notifications().createNotification(loan: loan)
                    if let completion = self.completion {
                        completion(loan)
                    }
                } else {
                    let loan = try await apiService.postLoan(parameters: parameters)
                    Notifications().createNotification(loan: loan)
                    if let completion = self.completion {
                        completion(loan)
                    }
                }
                await setLoad(false)
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

    @MainActor private func setShowReminder(_ value: Bool) {
        showReminder = value
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
