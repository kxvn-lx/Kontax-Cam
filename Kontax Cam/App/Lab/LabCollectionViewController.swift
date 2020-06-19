//
//  LabCollectionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 25/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import Nuke
import DTPhotoViewerController

class LabCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    private let IS_DEMO_MODE = false
    
    var imageObjects = [Photo]()
    private var pipeline = ImagePipeline.shared
    
    private var isSelecting = false
    private var imagesIndexToDelete: [IndexPath] = []
    
    private let photoLibraryEngine = PhotoLibraryEngine()
    private let previewVC = PreviewViewController()
    
    private var selectedImageIndex: Int = 0
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
        v.alpha = 0.5
        v.isHidden = true
        return v
    }()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Navigation configuration
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.configureNavigationBar(tintColor: .label, title: "Lab", preferredLargeTitle: false, removeSeparator: true)
        
        let closeButton = CloseButton()
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: selectButton)
        
        // 2. CollectionView configuration
        self.collectionView.collectionViewLayout = makeLayout()
        fetchData(IS_DEMO_MODE)
        
        setupView()
        setupConstraint()
        toggleElements()
        
        // 3. Gesture Configuration
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.25
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(longPressedGesture)

        ImageLoadingOptions.shared.placeholder = UIImage(named: "labCellPlaceholder")!
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.125)
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
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageObjects.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabCollectionViewCell.reuseIdentifier, for: indexPath) as! LabCollectionViewCell
        let currentImage = imageObjects[indexPath.row]
        
        var request = ImageRequest(url: currentImage.url)
        request.processors = [ImageProcessors.Resize(size: cell.bounds.size)]
        
        loadImage(with: request, into: cell.photoView)
        
        if imagesIndexToDelete.contains(indexPath) { cell.toggleSelection() }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
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
    // MARK: - CollectionView fetching and layout
    private func fetchData(_ isDemoMode: Bool) {
        let urls = isDemoMode ? demoPhotosURLs : DataEngine.shared.readDataToURLs()
        for url in urls {
            self.imageObjects.append(Photo(image: UIImage(named: "labCellPlaceholder")!, url: url))
        }
    }
    
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
            heightDimension: .fractionalWidth(0.33))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: fullPhotoItem,
            count: 3
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension LabCollectionViewController {
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
        isSelecting.toggle()
        selectButton.setTitle(isSelecting ? "cancel" : "Select", for: .normal)
        
        if !isSelecting {
            // Clear all pending queue of images to delete and deselect all active cell.
            for indexPath in imagesIndexToDelete {
                if let cell = collectionView.cellForItem(at: indexPath) as? LabCollectionViewCell {
                    cell.toggleSelection()
                }
            }
            self.collectionView.reloadData()
            imagesIndexToDelete.removeAll()
        }
        
        toggleElements()
        selectButton.sizeToFit()
    }
    
    @objc private func confirmDeleteTapped() {
        let message = imagesIndexToDelete.count > 1 ? "images" : "image"
        let alert = UIAlertController(title: "Delete \(imagesIndexToDelete.count) \(message)?", message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
            guard let self = self else { return }
            
            for indexPath in self.imagesIndexToDelete {
                if let cell = self.collectionView.cellForItem(at: indexPath) as? LabCollectionViewCell {
                    cell.toggleSelection()
                }
                
                
                DataEngine.shared.deleteData(imageURLToDelete: self.imageObjects[indexPath.row].url) { _ in () }
                self.imageObjects.remove(at: indexPath.row)
            }
            
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: self.imagesIndexToDelete)
            }) { (success) in
                if success {
                    self.imagesIndexToDelete.removeAll()
                    self.selectButtonTapped()
                    self.toggleElements()
                    self.collectionView.reloadData()
                } else { fatalError() }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func toggleElements() {
        imageObjects.count == 0 ? setEmptyView() : removeEmptyView()
        
        selectButton.isEnabled = imageObjects.count > 0
        selectButton.alpha = selectButton.isEnabled ? 1 : 0.25
        
        fabDeleteButton.isEnabled = imagesIndexToDelete.count > 0
        fabDeleteButton.isHidden = !isSelecting
        fabDeleteButton.alpha = fabDeleteButton.isEnabled ? 1 : 0.5
    }
    
    @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let p = gestureRecognizer.location(in: collectionView)
        
        switch gestureRecognizer.state {
        case .began:
            if let indexPath = collectionView?.indexPathForItem(at: p) {
                TapticHelper.shared.lightTaptic()
                
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                Nuke.loadImage(with: imageObjects[indexPath.row].url, into: self.previewVC.imageView)
                window?.addSubview(self.previewVC.view)
            }
        case .ended:
            previewVC.animateOut { [weak self] (_) in
                guard let self = self else { return }
                self.previewVC.view.removeFromSuperview()
            }
            
        default: return
        }
    }
}

// MARK: - DTPhotoViewerControllerDataSource
extension LabCollectionViewController: DTPhotoViewerControllerDataSource {
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = collectionView?.cellForItem(at: indexPath) as? LabCollectionViewCell {
            return cell.photoView
        }
        
        return nil
    }
    
    func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
        return imageObjects.count
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        loadImage(with: imageObjects[index].url, into: imageView)
    }
}

// MARK: - DTPhotoViewerControllerDelegate
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
        if let image = UIImage(contentsOfFile: imageObjects[index].url.path) {
            ShareHelper.shared.presentShare(withImage: image, toView: self.presentedViewController!)
        }
    }
    
    func photoDisplayWillSave(photoAt index: Int) {
        if let image = UIImage(contentsOfFile: imageObjects[index].url.path) {
            photoLibraryEngine.saveImageToAlbum(image) { [weak self] (success) in
                guard let self = self else { return }
                if success {
                    DispatchQueue.main.async {
                        SPAlertHelper.shared.present(title: "Saved", preset: .done)
                    }
                    TapticHelper.shared.successTaptic()
                } else {
                    TapticHelper.shared.errorTaptic()
                    DispatchQueue.main.async {
                        AlertHelper.shared.presentDefault(title: "Kontax Cam does not have permission.", message: "Looks like we could not save the photo to your camera roll due to lack of permission. Please check the app's permission under settings.", to: self.presentedViewController!)
                    }
                }
            }
        }
    }
    
    func photoDisplayWillDelete(photoAt index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        DataEngine.shared.deleteData(imageURLToDelete: imageObjects[indexPath.row].url) { [weak self] (success) in
            guard let self = self else { return }
            if success {
                SPAlertHelper.shared.present(title: "Image deleted.")
                self.imageObjects.remove(at: index)
                
                self.collectionView.deleteItems(at: [indexPath])
                self.toggleElements()
                self.collectionView.reloadData()
            } else {
                AlertHelper.shared.presentDefault(title: "Something went wrong.", message: "We are unable to delete the image.", to: self.presentedViewController!)
            }
        }
    }
}
