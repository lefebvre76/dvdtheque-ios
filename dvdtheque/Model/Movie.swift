//
//  Movie.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import Foundation

struct Movie: Decodable {
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
    let parent_boxes: [LightBox]
    let loans: [Loan]
}
