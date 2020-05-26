//
//  PhotoDisplayViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 24/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

protocol PhotoDisplayDelegate {
    func didDeleteImage()
}

class PhotoDisplayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    private let toolImages = ["square.and.arrow.up", "square.and.arrow.down", "trash"]
    private var photoLibraryEngine: PhotoLibraryEngine!
    
    private var collectionView: UICollectionView!
    var imgArray = [UIImage]()
    var passedContentOffset = IndexPath()
    
    private var currentCell: CGFloat = 0
    private var timestampTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    var delegate: PhotoDisplayDelegate?
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoLibraryEngine = PhotoLibraryEngine(caller: self)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: makeLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PhotoDisplayCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        collectionView.isPagingEnabled = true
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: passedContentOffset, at: .left, animated: true)
        
        self.collectionView.backgroundColor = .secondarySystemBackground
        self.view.backgroundColor = .clear
        
        self.view.addSubview(collectionView)
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Collection View datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoDisplayCollectionViewCell
        cell.imgView.image = imgArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let filename = imgArray[indexPath.row].accessibilityIdentifier {
            let timestamp = String(filename.dropFirst())
            let ( date, time ) = parseToDateTime(filename: timestamp)
            timestampTitle.text = "\(date)\n\(time)"
            
            self.navigationItem.titleView = timestampTitle
        }
        
        print("Image size: \(imgArray[indexPath.row].getFileSizeInfo()!)")
        
    }
    
    private func setupUI () {
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        var items: [UIBarButtonItem] = []
        
        for i in 0 ..< toolImages.count {
            let btn = UIButton()
            btn.setImage(IconHelper.shared.getIconImage(iconName: toolImages[i]), for: .normal)
            btn.tintColor = .label
            btn.tag = i
            btn.addTarget(self, action: #selector(toolButtonTapped), for: .touchUpInside)
            
            let toolBtn = UIBarButtonItem(customView: btn)
            items.append(toolBtn)
            if i != toolImages.count - 1 { items.append(flexible) }
        }
        
        self.toolbarItems = items
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func toolButtonTapped(sender: UIButton) {
        
        guard let indexPath = collectionView.indexPathForItem(at: self.view.center) else {
            TapticHelper.shared.errorTaptic()
            AlertHelper.shared.presentDefault(title: "Something went wrong.", message: "There was a problem performing the action. Please try again. Or, contact kevin.laminto@gmail.com", to: self)
            return
        }
        
        TapticHelper.shared.lightTaptic()
        let selectedImage = imgArray[indexPath.row]
        
        switch sender.tag {
        case 0:
            ShareHelper.shared.presentShare(withImage: selectedImage, toView: self)
        case 1:
            photoLibraryEngine.save(selectedImage) { (success, error) in
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
            
        case 2:
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ _ in
                self.deleteImage(at: indexPath)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            
        default: break
        }
    }
    
    /// Helper class to delete the image
    private func deleteImage(at indexPath: IndexPath) {
        SPAlertHelper.shared.present(title: "Image deleted.")
        DataEngine.shared.deleteData(imageToDelete: imgArray[indexPath.row]) { (success) in
            if !success {
                AlertHelper.shared.presentDefault(title: "Something went wrong.", message: "We are unable to delete the image.", to: self)
            }
        }
        imgArray.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
        delegate?.didDeleteImage()
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
    
}

extension PhotoDisplayViewController {
    private func makeLayout() -> UICollectionViewLayout {
        let margin: CGFloat = 0
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(
            top: margin,
            leading: margin,
            bottom: margin,
            trailing: margin)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
