//
//  LabCollectionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 25/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import DTPhotoViewerController

private let reuseIdentifier = "labCell"

class LabCollectionViewController: UICollectionViewController {
    
    private var images: [UIImage] = []
    private var selectedImageIndex: Int = 0
    private let photoLibraryEngine = PhotoLibraryEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoLibraryEngine.checkStatus { (hasUserAccess) in
            if hasUserAccess == false {
                AlertHelper.shared.presentDefault(title: "Looks like we can't check your permission.", message: "Please ensure that the app has sufficient permission before proceeding.", to: self)
            }
        }
        
        // Making the back button nhas no title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.configureNavigationBar(tintColor: .label, title: "Lab", preferredLargeTitle: false)
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
        
        //UICollectionView setup
        self.collectionView.collectionViewLayout = makeLayout()
        
        // Fetch all images
        images = fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        images.count == 0 ? setEmptyView() : removeEmptyView()
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
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TapticHelper.shared.lightTaptic()
        self.selectedImageIndex = indexPath.row
        self.presentPhotoDisplayVC(indexPath: indexPath)
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
    private func presentPhotoDisplayVC(indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? LabCollectionViewCell {
            let viewController = PhotoDisplayViewController(referencedView: cell.photoView, image: cell.photoView.image)
            viewController.photoDisplayDelegate = self
            viewController.dataSource = self
            viewController.delegate = self
            present(viewController, animated: true, completion: nil)
        }

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
    
    /// Setting a meaningful empty view when the collectionview is empty
    private func setEmptyView() {
        let v = EmptyView(frame: self.collectionView.frame)
        self.collectionView.backgroundView = v
    }
    
    /// Remove the emptyview when an item is present
    private func removeEmptyView() {
        self.collectionView.backgroundView = nil
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
}

// MARK: DTPhotoViewerControllerDataSource
extension LabCollectionViewController: DTPhotoViewerControllerDataSource {
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = collectionView?.cellForItem(at: indexPath) as? LabCollectionViewCell {
            return cell.photoView
        }

        return nil
    }

    func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
        return images.count
    }

    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        self.photoDisplayWillChangeCell(atNewIndex: index)
        imageView.image = images[index]
    }
}

// MARK: DTPhotoViewerControllerDelegate
extension LabCollectionViewController: DTPhotoViewerControllerDelegate {
    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: selectedImageIndex, animated: false)
    }

    func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToPhotoAt index: Int) {
        selectedImageIndex = index
        if let collectionView = collectionView {
            let indexPath = IndexPath(item: selectedImageIndex, section: 0)
            
            // If cell for selected index path is not visible
            if !collectionView.indexPathsForVisibleItems.contains(indexPath) {
                // Scroll to make cell visible
                collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
            }
        }
    }
}

// MARK: - PhotoDisplayDelegate
extension LabCollectionViewController: PhotoDisplayDelegate {
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
        
        formatter.dateFormat = "h:mm:ss a"
        let time = formatter.string(from: ts)
        
        return(date, time)
        
    }
    
    func photoDisplayWillChangeCell(atNewIndex index: Int) {
        if let child = self.presentedViewController as? PhotoDisplayViewController {
            if let timestamp = images[index].accessibilityIdentifier {
                
                let (date, time) = parseToDateTime(filename: timestamp)
                child.navTitleLabel.text = "\(date)\n\(time)"
            }
        }
    }
    
    func photoDisplayWillShare(photoAt index: Int) {
        if let child = self.presentedViewController {
            ShareHelper.shared.presentShare(withImage: images[index], toView: child)
        }
    }
    
    func photoDisplayWillSave(photoAt index: Int) {
        photoLibraryEngine.save(images[index]) { (success, error) in
            if let error = error {
                AlertHelper.shared.presentDefault(title: "Something went wrong.", message: error.localizedDescription, to: self)
                TapticHelper.shared.errorTaptic()
                return
            }
            DispatchQueue.main.async {
                SPAlertHelper.shared.present(title: "Saved", message: nil, preset: .done)
            }
            
            TapticHelper.shared.successTaptic()
        }
        
    }
    
    func photoDisplayWillDelete(photoAt index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        SPAlertHelper.shared.present(title: "Image deleted.")
        DataEngine.shared.deleteData(imageToDelete: images[index]) { (success) in
            if !success {
                AlertHelper.shared.presentDefault(title: "Something went wrong.", message: "We are unable to delete the image.", to: self)
            }
        }
        images.remove(at: index)
        
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
    
    
}


