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
}
