//
//  LabCollectionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 25/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "labCell"

class LabCollectionViewController: UICollectionViewController {
    
    private var images: [UIImage] = []
    private let flowLayout: UICollectionViewLayout = {
        let margin: CGFloat = 5
        
        let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
        )
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
            top: margin,
            leading: margin,
            bottom: margin,
            trailing: margin
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.425))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: fullPhotoItem,
            count: 3
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar(tintColor: .label, title: "Lab")
        
        //UICollectionView setup
        self.collectionView.collectionViewLayout = flowLayout
        
        // Fetch all images
        DataEngine.shared.read { (images) in
            self.images = images
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LabCollectionViewCell
        
        let currentImage = images[indexPath.row]

        cell.photoView.image = currentImage


        if let id = currentImage.accessibilityIdentifier {
            let (date, _) = parseToDateTime(filename: id)
            cell.dateLabel.text = date
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let selectedImage = images[indexPath.row]
        
        return UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: nil) { (_) -> UIMenu? in
                return self.makeContextMenu()
        }
    }
    
    // MARK: - Class functions
    private func makeContextMenu() -> UIMenu {

        // Create a UIAction for sharing
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
            //TODO: show system sharesheet.
        }

        // Create and return a UIMenu with the share action
        return UIMenu(title: "", children: [share])
    }
        
    /// Parse the given encoded timestamp and render it into strings for readability
    /// - Parameter filename: The filename of the image (in timestamp format)
    /// - Returns: The parsed timestamp into Date, and time.
    private func parseToDateTime(filename: String) -> (String, String) {
        let filenameArr = filename.components(separatedBy: "_")
        let timestamp = String(filenameArr[1].dropLast(4))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        let ts = Date(timeIntervalSince1970: (timestamp as NSString).doubleValue)
        let date = formatter.string(from: ts)
        
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: ts)
        
        return(date, time)
        
    }
}
