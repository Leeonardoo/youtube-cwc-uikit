//
//  Rating.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 05/07/23.
//

import Foundation

struct Rating: Decodable {
    
    var videoId: String
    var rating: String
    
    enum CodingKeys: String, CodingKey {

        case videoId
        case rating
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.videoId = try container.decode(String.self, forKey: .videoId)
        self.rating = try container.decode(String.self, forKey: .rating)
    }
}
