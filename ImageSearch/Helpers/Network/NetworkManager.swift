//
//  NetworkManager.swift
//  ImageSearch
//
//  Created by Murat Merekov on 10.04.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import UIKit

typealias JSON = [String: Any]

final class NetworkManager: NSObject, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    static let shared = NetworkManager()
    private var baseUrl  = "https://api.unsplash.com"
    
    func request<T: Codable>(path: String,
                             method: RequestType,
                             params: JSON = [:],
                             completion: @escaping (Result<T,Error>) -> Void) {
        
        var queryItems = [] as [URLQueryItem]
        
        for (key,value) in params {
            let item = URLQueryItem(name: key, value: String(describing: value))
            queryItems.append(item)
        }
        
        let url = URL(baseUrl: baseUrl, path: path, queryItems: queryItems)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        let session = URLSession(configuration: .default,
                                 delegate: nil,
                                 delegateQueue: nil)
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(APIError.connectionEror))
                print(error!)
                return
            }
            guard let data = data else {
                completion(.failure(APIError.errorFetchingdata))
                return
            }
            
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            
            guard status == 200 else {
                let statusResonse: StatusResponse
                do{
                    statusResonse = try JSONDecoder().decode(StatusResponse.self, from: data)
                    completion(.failure(APIError.message(statusResonse.message)))
                } catch _ {
                    statusResonse = StatusResponse(message: "Error fetching data!")
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
        session.finishTasksAndInvalidate()
    }
    
}
