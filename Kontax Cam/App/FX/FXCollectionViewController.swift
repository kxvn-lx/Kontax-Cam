//
//  FXCollectionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import PanModal
import SwiftUI

private struct CellPath {
    static let colourleaksCell = IndexPath(row: FilterType.allCases.firstIndex(of: .colourleaks)! - 1, section: 0)
    static let grainCell = IndexPath(row: FilterType.allCases.firstIndex(of: .grain)! - 1, section: 0)
    static let dustCell = IndexPath(row: FilterType.allCases.firstIndex(of: .dust)! - 1, section: 0)
    static let lightleaksCell = IndexPath(row: FilterType.allCases.firstIndex(of: .lightleaks)! - 1, section: 0)
    static let datestampCell = IndexPath(row: FilterType.allCases.firstIndex(of: .datestamp)! - 1, section: 0)
}

class FXCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    private let effects: [Effect] = FilterType.allCases.map({ Effect(name: $0, icon: $0.iconName) }).filter({ $0.name != FilterType.lut })
    private let scaleFactor: CGFloat = 0.95
    private let scaleDuration: Double = 0.0625
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle("Effects")
        self.addCloseButton()
        self.collectionView.backgroundColor = .systemBackground
        
        // UICollectionView setup
        collectionView.collectionViewLayout = makeLayout()
        collectionView.register(FXCollectionViewCell.self, forCellWithReuseIdentifier: FXCollectionViewCell.ReuseIdentifier)
        
        // Setup Long press gesture
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.25
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
        
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(infoButtonTapped))
        self.navigationItem.rightBarButtonItem = infoButton
    }

    @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let p = gestureRecognizer.location(in: collectionView)
        
        switch gestureRecognizer.state {
        case .began:
            guard let indexPath = collectionView?.indexPathForItem(at: p) else { return }
            guard let cell = collectionView.cellForItem(at: indexPath) as? FXCollectionViewCell else { return }
            
            UIView.animate(withDuration: scaleDuration) {
                cell.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
            }
            
            if cell.isFxSelected {
                // Multiple designated view controllers for each customisation for the future. Maybe we need to add a new customisation option only to a specific effects?
                // Perhaps there is a better way on doing this.
                switch indexPath {
                case CellPath.colourleaksCell:
                    presentPanModal(PanModalNavigationController(rootViewController: ColourleaksCustomisationViewController()))
                    
                case CellPath.grainCell:
                    presentPanModal(PanModalNavigationController(rootViewController: GrainCustomisationViewController()))
                    
                case CellPath.dustCell:
                    presentPanModal(PanModalNavigationController(rootViewController: DustCustomisationViewController()))
                    
                case CellPath.lightleaksCell:
                    presentPanModal(PanModalNavigationController(rootViewController: LightleaksCustomisationViewController()))
                    
                case CellPath.datestampCell:
                    TapticHelper.shared.errorTaptic()
                    AlertHelper.shared.presentOKAction(withTitle: "No customisation available", andMessage: "Kontax Cam does not support Datestamp customisation at the moment.", to: self)
                    
                default: break
                }
            }
            
        default:
            guard let indexPath = collectionView?.indexPathForItem(at: p) else { return }
            guard let cell = collectionView.cellForItem(at: indexPath) as? FXCollectionViewCell else { return }
            UIView.animate(withDuration: scaleDuration) {
                cell.transform = .identity
            }
        }
    }
    
    @objc private func infoButtonTapped() {
        let fxInfoView = UIHostingController(rootView: FXInfoView(dismissAction: {
            self.dismiss(animated: true)
        }))
        self.present(fxInfoView, animated: true, completion: nil)
    }
}

// MARK: - Collectionview delegate and datasource
extension FXCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return effects.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FXCollectionViewCell.ReuseIdentifier, for: indexPath) as! FXCollectionViewCell
        let currentFx = effects[indexPath.row]
        
        cell.titleLabel.text = currentFx.name.description
        cell.iconImageView.image = IconHelper.shared.getIconImage(iconName: currentFx.icon)
        
        if FilterEngine.shared.allowedFilters.contains(currentFx.name) { cell.isFxSelected.toggle() }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TapticHelper.shared.lightTaptic()
        
        // 1. Update UI
        let selectedCell = collectionView.cellForItem(at: indexPath) as! FXCollectionViewCell
        selectedCell.isFxSelected.toggle()
        
        // 2. Update datasource
        let selectedFx = effects[indexPath.row]
        smartAppend(selectedCell, selectedFx)
        
        // Start animation
        UIView.animate(withDuration: scaleDuration) {
            selectedCell.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
        } completion: { (_) in
            UIView.animate(withDuration: self.scaleDuration) {
                selectedCell.transform = .identity
            }
        }
    }
    
    /// Append the selecteed FX to the allowed filters list. If exist, simply remove it.
    /// - Parameters:
    ///   - selectedCell: The selected cell
    ///   - selectedFx: The selected Effects
    private func smartAppend(_ selectedCell: FXCollectionViewCell, _ selectedFx: Effect) {
        if selectedCell.isFxSelected {
            FilterEngine.shared.allowedFilters.append(selectedFx.name)
        } else {
            FilterEngine.shared.allowedFilters.remove(at: FilterEngine.shared.allowedFilters.firstIndex(of: selectedFx.name)!)
        }
        FilterEngine.shared.allowedFilters.sort(by: { $0.rawValue < $1.rawValue })
    }
}

extension FXCollectionViewController {
    // MARK: - Class functions
    private func createSection() -> NSCollectionLayoutSection {
        let contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = contentInsets
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalWidth(0.325))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createSection()
        }
        
        // Configure the Layout with interSectionSpacing
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
}

extension FXCollectionViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return collectionView
    }
}
