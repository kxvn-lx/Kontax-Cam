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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar(tintColor: .label, title: "Lab")
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
        
        //UICollectionView setup
        self.collectionView.collectionViewLayout = makeLayout()
        
        // Fetch all images
        images = fetchData()
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TapticHelper.shared.lightTaptic()
        self.presentPhotoDisplayVC(indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let selectedImage = images[indexPath.row]
        
        return UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: {
                return PhotoPreviewViewController(image: selectedImage)
            },
            actionProvider: { suggestedActions in
                return ShareHelper.shared.presentContextShare(image: selectedImage, toVC: self)
            })
    }
    
    override func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {

        guard let indexPath = configuration.identifier as? IndexPath else { return }

        animator.addAnimations {
            self.presentPhotoDisplayVC(indexPath: indexPath)
        }
    }
}

extension LabCollectionViewController {
    // MARK: - Class functions
    private func makeLayout() -> UICollectionViewLayout  {
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
         section.boundarySupplementaryItems = [makeSectionHeader()]
         
         let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func makeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
             heightDimension: .estimated(40))
        
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return layoutSectionHeader
    }
    
    /// Helper to present the photo display VC
    /// - Parameter indexPath: the indexpath
    private func presentPhotoDisplayVC(indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "photoDisplayVC") as! PhotoDisplayViewController

        vc.imgArray = self.images
        vc.passedContentOffset = indexPath
        vc.delegate = self

        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    private func fetchData() -> [UIImage] {
        var images: [UIImage] = []
        let imageUrls = DataEngine.shared.readDataToURLs()
        
        for url in imageUrls {
            if let image = UIImage(contentsOfFile: url.path) {
                let filename = url.path.replacingOccurrences(of: DataEngine.shared.getDocumentsDirectory().path, with: "", options: .literal, range: nil)
                image.accessibilityIdentifier = filename
                images.append(image)
            }
        }
        
        return images
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
        
        formatter.dateFormat = "h:mm a"
        let time = formatter.string(from: ts)
        
        return(date, time)
        
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        // 1
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95),
                                                             heightDimension: .estimated(80))
        
        // 2
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize,
                                                                              elementKind: UICollectionView.elementKindSectionHeader,
                                                                              alignment: .top)
        return layoutSectionHeader
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension LabCollectionViewController: PhotoDisplayDelegate {
    func didDeleteImage() {
        images = self.fetchData()
        self.collectionView.reloadData()
    }
}
