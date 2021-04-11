//
//  ViewController.swift
//  ImageSearch
//
//  Created by Murat Merekov on 10.04.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    lazy var viewModel: MainViewModel = {
        return MainViewModel()
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlowLayout()
        registerCells()
        initVM()
        
    }
    
    private func setupFlowLayout(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 0, right: 10)
        flowLayout.itemSize = CGSize(width: collectionView.frame.size.width/2.2, height: collectionView.frame.size.width/2)
        collectionView.collectionViewLayout = flowLayout
    }
    func registerCells(){
        collectionView.register(UINib(nibName: ImageCell.nibName, bundle: Bundle.main), forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
    }
    func initVM() {
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.fetch()
    }


}

extension MainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItemsInSection()
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.prepareCell(collectionView: collectionView, indexPath: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         viewModel.checkForFetch(indexPath: indexPath)
     }
}

extension MainViewController: UICollectionViewDelegate{
    
}

