//
//  PhotoDisplayViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 24/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class PhotoDisplayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    private var collectionView: UICollectionView!
    var imgArray = [UIImage]()
    var passedContentOffset = IndexPath()
    
    private let flowLayout: UICollectionViewLayout = {
        let margin: CGFloat = 5
        
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
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        collectionView.isPagingEnabled = true
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: passedContentOffset, at: .left, animated: true)
        
        self.collectionView.backgroundColor = .secondarySystemBackground
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePreviewFullViewCell
        cell.imgView.image = imgArray[indexPath.row]
        return cell
    }
    
    private func setupUI () {
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
        
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped))
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let items = [share, flexible, save, flexible, delete]
        for item in items {
            item.tintColor = .label
        }
        
         self.toolbarItems = items
    }
    
    @objc private func shareTapped() {
        print("Sharing")
    }
    
    @objc private func saveTapped() {
        print("Saving")
    }
    
    @objc private func deleteTapped() {
        print("Deleting")
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
