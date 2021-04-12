//
//  URLexstension.swift
//  ChocofoodProject
//
//  Created by Murat Merekov on 11.01.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import UIKit

extension URL {
    init(baseUrl: String, path: String, queryItems: [URLQueryItem] = []) {
        guard let urlComponents = URLComponents(string: baseUrl) else {
            self.init(baseUrl: baseUrl, path: path, queryItems: queryItems)
            return
        }
        var components = urlComponents
        components.path += path
        components.queryItems = queryItems
        guard let url = components.url else {
            assertionFailure("Error in unwrapping URL")
            self.init(baseUrl: baseUrl, path: path, queryItems: queryItems)
            return
        }
        self = url
    }
}


