//
//  LightBox.swift
//  dvdtheque
//
//  Created by loic lefebvre on 15/12/2023.
//

import Foundation

struct LigthBox: Decodable {
    let id: Int
    let type: String
    let title: String
    let illustration: Illustration
}

struct LigtBoxResponse: Decodable {
    let data: [LigthBox]
}
