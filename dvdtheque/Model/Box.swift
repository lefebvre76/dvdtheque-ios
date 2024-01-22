//
//  Box.swift
//  dvdtheque
//
//  Created by loic lefebvre on 20/12/2023.
//

import Foundation

struct Box: Decodable {
    let id: Int
    let type: String
    let title: String
    let original_title: String?
    let year: Int
    let synopsis: String
    let edition: String?
    let editor: String?
    let illustration: Illustration
    let kinds: [Kind]
    let directors: [Celebrity]
    let actors: [Celebrity]
    let composers: [Celebrity]
    let boxes: [LightBox]
    let in_collection: Bool
    let in_wishlist: Bool
    let loans: [Loan]
}
