//
//  Response.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 03/07/23.
//

import Foundation

struct Response: Decodable {
    
    var items: [Video]?
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.items = try container.decodeIfPresent([Video].self, forKey: .items)
    }
}
