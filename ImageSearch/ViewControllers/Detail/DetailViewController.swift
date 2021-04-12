//
//  DetailViewController.swift
//  ImageSearch
//
//  Created by Murat Merekov on 12.04.2021.
//  Copyright © 2021 Murat Merekov. All rights reserved.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var usernameButton: UIButton!
    @IBOutlet private weak var locationButton: UIButton!
    @IBOutlet private weak var likeNumberButton: UIButton!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    let viewModel = DetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        startLoader()
    }
    private func startLoader() {
        let loader =   self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.stopLoader(loader: loader)
        }
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
    private func initUI(){
        guard let url = URL(string: viewModel.imageUrl) else { return }
        imageView.sd_setImage(with: url, completed: nil)
        guard let likeNumber = viewModel.like else { return }
        likeNumberButton.setTitle("\(likeNumber)", for: .normal)
        guard let location = viewModel.location else { return }
        locationButton.setTitle(location, for: .normal)
        guard let username = viewModel.username else { return }
        usernameButton.setTitle(username, for: .normal)
        guard let author = viewModel.author else { return }
        authorLabel.text = author
        dateLabel.text = viewModel.date
        guard let info = viewModel.info else { return }
        infoLabel.text = info
    }
}
