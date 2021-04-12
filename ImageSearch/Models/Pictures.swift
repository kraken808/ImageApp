//
//  Pictures.swift
//  ImageSearch
//
//  Created by Murat Merekov on 11.04.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import Foundation

struct Picture: Codable{
    var id: String
    var created_at: String
    var updated_at: String
    var description: String?
    var alt_description: String?
    var urls: Urls
    var likes: Int?
    var user: User
}

struct Urls: Codable{
    var full: String
    var regular: String
}

struct User: Codable{
    var name: String?
    var location: String?
    var username: String?
}


