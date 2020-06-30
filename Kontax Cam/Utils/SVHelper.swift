//
//  SVHelper.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct SVHelper {
    
    static let shared = SVHelper()
    private init() { }
    
    /// Create a stackview complete with its property
    /// - Parameters:
    ///   - axis: The axis of the Stack view
    ///   - spacing: The spacing of the stack view, default: 10
    ///   - alignment: The alignment of the stack view
    ///   - distribution: The distribution of the stack view
    /// - Returns: The created stack view
    func createSV(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 10, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution) -> UIStackView {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        
        return stackView
    }
}
