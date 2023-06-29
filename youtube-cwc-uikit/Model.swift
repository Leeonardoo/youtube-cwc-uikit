//
//  Model.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 28/06/23.
//

import Foundation

class Model {
    
    func getVideos() {
        
        guard let url = URL(string: Constants.apiUrl) else { return }
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            
            if (error != nil || data == nil) {
                return
            }
            
            
        }
        
        dataTask.resume()
    }
    }
