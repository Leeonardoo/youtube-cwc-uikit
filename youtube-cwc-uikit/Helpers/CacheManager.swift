//
//  CacheManager.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 04/07/23.
//

import Foundation

class CacheManager {
    
    static var cache = [String: Data]()
    
    static func setVideoCache(_ url: String, data: Data) {
        cache[url] = data
    }
    
    static func getVideoCache(_ url: String) -> Data? {
        return cache[url]
    }
}
