//
//  ImageCell.swift
//  ImageSearch
//
//  Created by Murat Merekov on 11.04.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCell: UICollectionViewCell, CellDetail{
   
    typealias T = Photos
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var nibName: String {
        return "ImageCell"
    }
    
    static var reuseIdentifier: String{
        return "ImageCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(data: Photos) {
        guard let url = URL(string: data.img_src) else { return }
        ImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = data.camera.name
      }

}
