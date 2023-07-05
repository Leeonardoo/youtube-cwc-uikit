//
//  Model.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 28/06/23.
//

import Foundation

class Model {
    
    private let url = URL(string: Constants.apiUrl)!
    private let session = URLSession.shared
    
    func getVideos() async throws -> Response {
        let (data, _) = try await session.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(Response.self, from: data)
    }
}
