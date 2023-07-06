//
//  RatingResponse.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 05/07/23.
//

import Foundation

struct RatingResponse: Decodable {
    
    var items: Rating?
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // We only care about the first one
        self.items = try container.decodeIfPresent([Rating].self, forKey: .items)?.first
    }
}
