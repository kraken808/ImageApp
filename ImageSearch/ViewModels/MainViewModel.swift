//
//  MainViewModel.swift
//  ImageSearch
//
//  Created by Murat Merekov on 10.04.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import UIKit

final class MainViewModel {
    var pictures = [Picture]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    var page = 1
    var reloadCollectionViewClosure: (() -> ())?
    func numberOfItemsInSection() -> Int{
        return pictures.count
    }
    func fetch(){
        NetworkManager.shared.request(path: "/photos/",
                                      method: .get,
                                      params: [ "client_id": "1RyIFhvnObxo-RqgWm_5WtQsodycfj5-Gcigj-_1_CE",
                                                "page": page] )
        {
            (result: Result<[Picture],Error>) in
            switch result {
            case .success(let result):
                self.pictures.append(contentsOf: result)
            case .failure(let error):
                print("\n \n error hetting data! \n \n")
                assertionFailure("\(error)")
            }
        }
        page += 1
    }
    func prepareCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier,
                                                            for: indexPath) as? ImageCell else {
                                                                assertionFailure("Cannot dequeue collectionView cell")
                                                                return UICollectionViewCell()
        }
        cell.bind(data: pictures[indexPath.row])
        return cell
    }
    func isLastCell(at indexPath: IndexPath) -> Bool {
        return (indexPath.row == pictures.count - 1)
    }
    func checkForFetch(indexPath: IndexPath) -> Bool{
        if isLastCell(at: indexPath) {
            return true
        }
        return false
    }
    func searchBar( searchBar: UISearchBar, searchText: String){
        if searchText == ""{
            page = 1
            fetch()
        }else{
            if searchBar.selectedScopeButtonIndex == 0{
                pictures = pictures.filter({ (detail) -> Bool in
                    guard let title = detail.description else { return false}
                    return title.lowercased().contains(searchText.lowercased())
                })
            }else{
                pictures = pictures.filter({ (detail) -> Bool in
                    guard let description = detail.alt_description else { return false}
                    return description.lowercased().contains(searchText.lowercased())
                })
            }
        }
    }
}

