//
//  LightBox.swift
//  dvdtheque
//
//  Created by loic lefebvre on 15/12/2023.
//

import Foundation

struct LightBox: Decodable {
    let id: Int
    let type: String
    let title: String
    let illustration: Illustration
    let loaned: Bool
}

struct LightBoxResponse: Decodable {
    let data: [LightBox]
    let meta: ResponseMeta
}

struct ResponseMeta: Decodable {
    let current_page: Int
    let last_page: Int
    let per_page: Int
    let to: Int?
    let total: Int
}
