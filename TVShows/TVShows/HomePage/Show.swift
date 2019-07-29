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
    
    enum CodingKeys: Any, CodingKey {
        case _id
        case title
        case imageUrl
        case likesCount
    }
}

struct ShowDetails: Codable {
    let type: String
    let title: String
    let description: String
    let _id: String
    let likesCount: Int
    let imageUrl: String
    
    enum CodingKeys: Any, CodingKey {
        case type
        case title
        case description
        case _id
        case likesCount
        case imageUrl
    }
}

struct ShowEpisodes: Codable {
    let _id: String
    let title: String
    let description: String
    let imageUrl: String
    let episodeNumber: String
    let season: String
    
    enum CodingKeys: Any, CodingKey {
        case _id
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
    }
}
