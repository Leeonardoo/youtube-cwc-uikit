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
    
    func getSubscription(channelId: String) async throws -> SubscriptionResponse {
        var url = URL(string: Constants.ytApiBaseUrl + Constants.subscriptionsPath)!
        url.append(queryItems: [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "part", value: "subscriberSnippet"),
            URLQueryItem(name: "mine", value: "true"),
            URLQueryItem(name: "forChannelId", value: channelId)
        ])
        
        let dataTask = AF.request(url)
            .validate()
            .serializingDecodable(SubscriptionResponse.self, automaticallyCancelling: true, decoder: decoder)
        
        return try await dataTask.value
    }
    
    func setSubscription(channelId: String) async throws {
        var url = URL(string: Constants.ytApiBaseUrl + Constants.subscriptionsPath)!
        url.append(queryItems: [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "part", value: "snippet")
        ])
        
        let body: [String: Any] = [
            "snippet": [
                "resourceId": [
                    "channelId": channelId,
                    "kind": "youtube#channel"
                ]
            ]
        ]
        
        let dataTask = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding())
            .validate()
            .serializingData(automaticallyCancelling: true)
        
        let _ = try await dataTask.value
    }
}
