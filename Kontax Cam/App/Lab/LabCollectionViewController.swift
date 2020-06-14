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
    
    private var isSelecting = false
    private var imagesIndexToDelete: [IndexPath] = []
    
    private var images: [UIImage] = []
    private var selectedImageIndex: Int = 0
    private let photoLibraryEngine = PhotoLibraryEngine()
    private let selectButton: UIButton = {
        let v = UIButton()
        v.setTitle("Select", for: .normal)
        v.titleLabel?.numberOfLines = 0
        v.setTitleColor(.label, for: .normal)
        return v
    }()
    private let fabDeleteButton: UIButton = {
        let v = UIButton()
        v.isEnabled = false
        v.setImage(IconHelper.shared.getIconImage(iconName: "trash"), for: .normal)
        v.tintColor = .white
        v.backgroundColor = .systemRed
        v.alpha = 0.25
        v.isHidden = true
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Making the back button has no title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.configureNavigationBar(tintColor: .label, title: "Lab", preferredLargeTitle: false, removeSeparator: true)
        
        let closeButton = CloseButton()
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: selectButton)
        
        //UICollectionView setup
        self.collectionView.collectionViewLayout = makeLayout()
        
        // Fetch all images
        images = fetchData()
        
        setupView()
        setupConstraint()

    }
    
    private func setupView() {
        // Setup FABDeleteButton
        fabDeleteButton.addTarget(self, action: #selector(confirmDeleteTapped), for: .touchUpInside)
        self.view.addSubview(fabDeleteButton)
    }
    
    private func setupConstraint() {
        fabDeleteButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-(self.view.getSafeAreaInsets().bottom + 20))
            make.height.equalTo(50)
            make.width.equalTo(self.view.frame.width * 0.8)
            make.centerX.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toggleElements()
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
        TapticHelper.shared.mediumTaptic()
        
        if isSelecting {
            let cell = collectionView.cellForItem(at: indexPath) as! LabCollectionViewCell
            cell.toggleSelection()
            
            if self.imagesIndexToDelete.contains(indexPath) {
                // User wished to undo tapping on cell
                imagesIndexToDelete.remove(at: imagesIndexToDelete.firstIndex(of: indexPath)!)
            } else {
                // User tapped on cell
                self.imagesIndexToDelete.append(indexPath)
            }
            
            self.toggleElements()
            
            self.imagesIndexToDelete.sort(by: { $0.row > $1.row })

        } else {
            self.selectedImageIndex = indexPath.row
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
    
    @objc private func selectButtonTapped() {
        let onPosition: CGFloat = 0
        let offPosition: CGFloat = 100
        let duration: Double = 0.25
        
        isSelecting.toggle()
        fabDeleteButton.transform = CGAffineTransform(translationX: 0, y: isSelecting ? offPosition : onPosition)
        
        if isSelecting {
            selectButton.setTitle("Cancel", for: .normal)
            fabDeleteButton.isHidden = false
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                self.fabDeleteButton.transform = CGAffineTransform(translationX: 0, y: onPosition)
            }, completion: nil)
            
        } else {
            // Clear all pending queue of images to delete and deselect all active cell.
            for indexPath in imagesIndexToDelete {
                let cell = collectionView.cellForItem(at: indexPath) as! LabCollectionViewCell
                cell.toggleSelection()
            }
            imagesIndexToDelete.removeAll()
            toggleElements()
            
            selectButton.setTitle("Select", for: .normal)
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                self.fabDeleteButton.transform = CGAffineTransform(translationX: 0, y: offPosition)
            }, completion: { _ in self.fabDeleteButton.isHidden = true })
        }
        
        selectButton.sizeToFit()
    }
    
    @objc private func confirmDeleteTapped() {
        let message = imagesIndexToDelete.count > 1 ? "images" : "image"
        let alert = UIAlertController(title: "Delete \(imagesIndexToDelete.count) \(message)?", message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            for indexPath in self.imagesIndexToDelete {
                let cell = self.collectionView.cellForItem(at: indexPath) as! LabCollectionViewCell
                cell.toggleSelection()
                
                DataEngine.shared.deleteData(imageToDelete: self.images[indexPath.row]) { (success) in
                    if !success {
                        if let child = self.presentedViewController {
                            AlertHelper.shared.presentDefault(title: "Something went wrong.", message: "We are unable to delete the image.", to: child)
                        }
                        return
                    }
                }
                
                self.images.remove(at: indexPath.row)
            }
            
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: self.imagesIndexToDelete)
            }) { (_) in
                self.imagesIndexToDelete.removeAll()
                self.selectButtonTapped()
                
                self.toggleElements()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func toggleElements() {
        images.count == 0 ? setEmptyView() : removeEmptyView()
        selectButton.isEnabled = images.count > 0
        selectButton.alpha = selectButton.isEnabled ? 1 : 0.25
        
        fabDeleteButton.isEnabled = imagesIndexToDelete.count > 0
        fabDeleteButton.alpha = fabDeleteButton.isEnabled ? 1 : 0.25
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
    func photoDisplayWillShare(photoAt index: Int) {
        if let child = self.presentedViewController {
            ShareHelper.shared.presentShare(withImage: images[index], toView: child)
        }
    }
    
    func photoDisplayWillSave(photoAt index: Int) {
        photoLibraryEngine.saveImageToAlbum(images[index]) { (success) in
            if success {
                DispatchQueue.main.async {
                    SPAlertHelper.shared.present(title: "Saved", message: nil, preset: .done)
                }
                TapticHelper.shared.successTaptic()
            } else {

                DispatchQueue.main.async {
                    if let child = self.presentedViewController {
                        AlertHelper.shared.presentDefault(title: "Kontax Cam does not have permission.", message: "Looks like we could not save the photo to your camera roll due to lack of permission. Please check the app's permission under settings.", to: child)
                    }
                }
                TapticHelper.shared.errorTaptic()
            }
        }
    }
    
    func photoDisplayWillDelete(photoAt index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        SPAlertHelper.shared.present(title: "Image deleted.")
        DataEngine.shared.deleteData(imageToDelete: images[index]) { (success) in
            if !success {
                if let child = self.presentedViewController {
                    AlertHelper.shared.presentDefault(title: "Something went wrong.", message: "We are unable to delete the image.", to: child)
                }
                
            }
        }
        images.remove(at: index)
        
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
    
    
}


