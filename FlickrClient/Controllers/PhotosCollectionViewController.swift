//
//  PhotosCollectionViewController.swift
//  FlickrClient
//
//  Created by Oleksandr Hozhulovskyi on 15.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "pictureCell"
private let cellSize: CGFloat = 124
private let cellSpacing: CGFloat = 2
private let cellToContinueLoading: Int = 7

class PhotosCollectionViewController: UICollectionViewController {
    var urlCollection = [FlickrImage]()
    let imageService = ImageService()
    var urlsPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
    }

    func loadPhotos() {}
}

extension PhotosCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlCollection.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PictureCollectionViewCell

        if indexPath.item == urlCollection.count - cellToContinueLoading {
            urlsPage += 1
            loadPhotos()
        }

        let previewURL = urlCollection[indexPath.item].previewURL
        imageService.imageFromURL(previewURL) { result in
            switch result {
            case .failure(let error): self.getDataError(with: error)
            case .success(let image): cell.imageView.image = image
            }
        }

        return cell
    }
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsInRow = Int(collectionView.bounds.width / cellSize)
        let cellSize = collectionView.bounds.width / CGFloat(cellsInRow) - cellSpacing

        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        flowLayout.invalidateLayout()
    }
}