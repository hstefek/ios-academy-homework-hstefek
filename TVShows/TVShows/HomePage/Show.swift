//
//  Show.swift
//  TVShows
//
//  Created by Infinum on 7/25/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct Show: Codable {
    let _id: String
    let title: String
    let imageUrl: String
    let likesCount: Int
    
    enum CodingKeys: Any, CodingKey{
        case _id
        case title
        case imageUrl
        case likesCount
    }
}
