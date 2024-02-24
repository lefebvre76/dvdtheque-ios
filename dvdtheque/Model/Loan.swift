//
//  Loan.swift
//  dvdtheque
//
//  Created by loic lefebvre on 22/01/2024.
//

import Foundation

struct Loan: Decodable {
    let id: Int
    let type: String
    let contact: String
    let reminder: Int?
    let comment: String?
    let box: LightBox
    let parent_box: LightBox?
    
    func reminderDatetoString() -> String? {
        guard let date = reminderDateToDate() else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")
        return dateFormatter.string(from: date)
    }

    func reminderDateToDate() -> Date? {
        guard let timestamp = reminder else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
    
    func reminderDateIsPast() -> Bool {
        guard let timestamp = reminder else { return false }
        return Date.now > Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
}

struct LoanBoxResponse: Decodable {
    let data: [Loan]
    let meta: ResponseMeta
}
