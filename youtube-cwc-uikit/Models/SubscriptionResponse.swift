//
//  SubscriptionResponse.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 05/07/23.
//

import Foundation

struct SubscriptionResponse: Decodable {
    
    var items: ChannelSubscription?
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // We only care about the first one too
        self.items = try container.decodeIfPresent([ChannelSubscription].self, forKey: .items)?.first
    }
}
