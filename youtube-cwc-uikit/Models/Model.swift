//
//  Model.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 28/06/23.
//

import Foundation
import Alamofire

class Model {
    
    private let session = URLSession.shared
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    func getVideos() async throws -> VideoResponse {
        let url = URL(string: Constants.ytApiBaseUrl + Constants.playListApiPath)!
        let (data, _) = try await session.data(from: url)
        
        return try decoder.decode(VideoResponse.self, from: data)
    }
    
    func getVideoRating(videoId: String) async throws -> RatingResponse {
        var url = URL(string: Constants.ytApiBaseUrl + Constants.getVideoRatingPath)!
        url.append(queryItems: [
            URLQueryItem(name: "id", value: videoId),
            URLQueryItem(name: "access_token", value: token)
        ])
        
        let dataTask = AF.request(url)
            .validate()
            .serializingDecodable(RatingResponse.self, automaticallyCancelling: true, decoder: decoder)
        
        return try await dataTask.value
    }
    
    func rate(videoId: String, rating: String) async throws {
        var url = URL(string: Constants.ytApiBaseUrl + Constants.rateVideoPath)!
        url.append(queryItems: [
            URLQueryItem(name: "id", value: videoId),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "rating", value: rating)
        ])
        
        let dataTask = AF.request(url, method: .post, encoding: URLEncoding.httpBody)
            .validate()
            .serializingData(automaticallyCancelling: true)
        
        let _ = try await dataTask.value
    }
}
