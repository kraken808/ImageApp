//
//  Protocols.swift
//  ImageSearch
//
//  Created by Murat Merekov on 11.04.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import UIKit

protocol CellDetail{
    associatedtype T
    static var nibName: String { get }
    static var reuseIdentifier: String { get }
    func bind(data: T)
}
