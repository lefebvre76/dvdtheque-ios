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
}

struct LightBoxResponse: Decodable {
    let data: [LightBox]
}
