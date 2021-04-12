//
//  ViewController.swift
//  ImageSearch
//
//  Created by Murat Merekov on 10.04.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let viewModel = MainViewModel()
    private var searchBar: UISearchBar!
    private var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupFlowLayout()
        registerCells()
        initVM()
    }
    override func viewDidAppear(_ animated: Bool) {
        startLoader()
    }
    private func startLoader() {
        let loader =   self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.stopLoader(loader: loader)
        }
    }
    private func setupSearchBar() {
        navigationItem.title = "Images"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                       style: .done,
                                       target: self,
                                       action: #selector(showSearchBar))
        self.navigationItem.rightBarButtonItem = searchButton
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Title","Description"]
    }
    private func setupFlowLayout(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 0, right: 10)
        flowLayout.itemSize = CGSize(width: collectionView.frame.size.width/2.2,
                                     height: collectionView.frame.size.width/2)
        collectionView.collectionViewLayout = flowLayout
    }
    private func registerCells(){
        collectionView.register(UINib(nibName: ImageCell.nibName,
                                      bundle: Bundle.main),
                                forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
    }
    private func initVM() {
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.fetch()
    }
    @objc func showSearchBar(){
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    private func loader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
    private func stopLoader(loader : UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
}

extension MainViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = searchButton
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBar(searchBar: searchBar, searchText: searchText)
        self.collectionView.reloadData()
    }
}

extension MainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.prepareCell(collectionView: collectionView, indexPath: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if( viewModel.checkForFetch(indexPath: indexPath) ){
            viewModel.fetch()
        }
     }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "moveToDetailVC", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "moveToDetailVC"
        {
            guard let destination = segue.destination as? DetailViewController else { return }
            guard let index = sender as? IndexPath else { return }
            destination.viewModel.picture = viewModel.pictures[index.row]
        }
        
    }
}


