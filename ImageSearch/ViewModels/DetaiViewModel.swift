//
//  DetaiViewModel.swift
//  ImageSearch
//
//  Created by Murat Merekov on 12.04.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import UIKit

final class DetailViewModel{
    var picture: Picture!
    var imageUrl: String {
        return picture.urls.regular
    }
    var like: Int? {
        return picture.likes
    }
    var location: String? {
        return picture.user.location
    }
    var username: String? {
        return picture.user.username
    }
    var author: String? {
        return picture.user.name
    }
    var date: String {
        return picture.created_at
    }
    var info: String? {
        return picture.alt_description
    }
}
