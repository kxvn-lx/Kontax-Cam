//
//  FiltersGestureEngine.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 8/7/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

protocol FiltersGestureDelegate: class {
    /// Called everytime the gesture detect a new change in the gesture
    func didSwipeToChangeFilter(withNewIndex newIndex: Int)
}

class FiltersGestureEngine {
    
    private let previewView: UIView!
    weak var delegate: FiltersGestureDelegate?
    var filterIndex = 0
    
    var collectionCount = FilterCollection.aCollection.filters.count + 1 {
        didSet {
            filterIndex = 1
        }
    }
    
    init(previewView: UIView) {
        self.previewView = previewView
        attachGesture()
    }
    
    // MARK: - Class methods
    /// Attach the gesture to the view to enable gesture listening
    private func attachGesture() {
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeFilterSwipe))
        leftSwipeGesture.direction = .left
        previewView.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeFilterSwipe))
        rightSwipeGesture.direction = .right
        previewView.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc private func changeFilterSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            filterIndex = (filterIndex + 1) % collectionCount
        } else if gesture.direction == .right {
            filterIndex = (filterIndex + collectionCount - 1) % collectionCount
        }
        
        delegate?.didSwipeToChangeFilter(withNewIndex: filterIndex)
    }
}
