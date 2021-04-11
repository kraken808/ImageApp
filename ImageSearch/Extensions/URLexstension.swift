//
//  URLexstension.swift
//  ChocofoodProject
//
//  Created by Murat Merekov on 11.01.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import Foundation
import UIKit

extension URL {
    init(baseUrl: String, path: String, queryItems: [URLQueryItem] = []) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        components.queryItems = queryItems
        self = components.url!
       
    }
}


