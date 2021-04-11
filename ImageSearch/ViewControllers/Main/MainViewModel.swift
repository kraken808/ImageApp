//
//  MainViewModel.swift
//  ImageSearch
//
//  Created by Murat Merekov on 10.04.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import UIKit

class MainViewModel{
    var photos = [Photos](){
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    var page = 1
    var reloadCollectionViewClosure: (()->())?
 
    func numberOfItemsInSection() -> Int{
        print("// photos.count = \(photos.count) ")
        return photos.count
    }
    
    func fetch(){
        NetworkManager.shared.request(path:"/mars-photos/api/v1/rovers/curiosity/photos", method: .get, params: ["sol":1000,"page":page,"api_key":"bGgXByaNKYQESnuj3olN9ZYsZp5nlfQjmaSBQIol"]) { (result: Result<Pictures,Error>) in
                       switch result{
                       case .success(let result):
                        self.photos.append(contentsOf: result.photos)
                       case .failure(_):
                           print("\n \n error hetting data! \n \n")
                       }
                   }
        page += 1
        print("// page = \(page)")
    }
    
    func prepareCell(collectionView: UICollectionView, indexPath: IndexPath)-> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
        print("// photo - \(indexPath.row): \(photos[indexPath.row])")
        cell.bind(data: photos[indexPath.row])

        return cell
    }
    
    func isLastCell(at indexPath: IndexPath) -> Bool {
        return (indexPath.row == photos.count - 1)
    }
   
    func checkForFetch(indexPath: IndexPath){
        if isLastCell(at: indexPath) {
            fetch()
        }
    }

}

