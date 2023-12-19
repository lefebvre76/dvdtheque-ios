//
//  User.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import Foundation

struct User: Decodable {
    let name: String
    let email: String
    let total_boxes: Int
    let total_movies: Int
    let favorite_kinds: [PopularItem]
    let favorite_directors: [PopularItem]
    let favorite_actors: [PopularItem]
}

struct PopularItem: Decodable {
    let id: Int
    let name: String
    let total: Int
}
