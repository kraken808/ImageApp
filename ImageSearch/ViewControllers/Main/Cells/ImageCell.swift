//
//  ImageCell.swift
//  ImageSearch
//
//  Created by Murat Merekov on 11.04.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import UIKit
import SDWebImage

final class ImageCell: UICollectionViewCell, CellDetail {
   
    typealias T = Picture
    
    @IBOutlet private weak var ImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    static var nibName: String {
        return "ImageCell"
    }
    
    static var reuseIdentifier: String{
        return "ImageCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bind(data: Picture) {
        guard let url = URL(string: data.urls.regular) else { return }
        ImageView.sd_setImage(with: url, completed: nil)
        guard let title = data.description else {
            guard let description = data.alt_description else { return }
            titleLabel.text = description
            return
        }
        titleLabel.text = title
      }

}
