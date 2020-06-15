//
//  VC+.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

/// EXTENSIONS
// MARK: - UIViewController
extension UIViewController {
    func configureNavigationBar(largeTitleColor: UIColor? = nil, backgoundColor: UIColor? = nil, tintColor: UIColor? = nil, title: String? = "", preferredLargeTitle: Bool = true, removeSeparator: Bool = false) {
        
        let largeTitleColour = largeTitleColor == nil ? UIColor.label : largeTitleColor
        let backgroundColour = backgoundColor == nil ? UIColor.systemBackground : backgoundColor
        let tintColour = tintColor == nil ? UIColor.systemBlue : tintColor
        let prefLargeTitle = preferredLargeTitle
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColour!]
        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColour!]
        navBarAppearance.backgroundColor = backgroundColour
        navBarAppearance.shadowColor = removeSeparator ? .clear : .quaternaryLabel
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationController?.navigationBar.prefersLargeTitles = prefLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColour
        navigationItem.title = title
    }
}


// MARK: - UIStackView
extension UIStackView {
    func addBackground(color: UIColor, cornerRadius: CGFloat? = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.layer.cornerRadius = cornerRadius!
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
    
    func addArrangedSubview(_ v: UIView, withMargin m: UIEdgeInsets ) {
        let containerForMargin = UIView()
        containerForMargin.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: containerForMargin.topAnchor, constant: m.top ),
            v.bottomAnchor.constraint(equalTo: containerForMargin.bottomAnchor, constant: m.bottom ),
            v.leftAnchor.constraint(equalTo: containerForMargin.leftAnchor, constant: m.left),
            v.rightAnchor.constraint(equalTo: containerForMargin.rightAnchor, constant: m.right)
        ])
        
        addArrangedSubview(containerForMargin)
    }
}

// MARK: - UIFont
extension UIFont {
    func makeRoundedFont(ofSize style: UIFont.TextStyle, multiplier: CGFloat = 1, weight: UIFont.Weight) -> UIFont {
        let fontSize = UIFont.preferredFont(forTextStyle: style).pointSize * multiplier
        if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: fontSize)
        } else {
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
}

// MARK: - UIButton
extension UIButton {
    func addBlurEffect(style: UIBlurEffect.Style = .regular, cornerRadius: CGFloat = 0, padding: CGFloat = 0) {
        backgroundColor = .clear
        
        let blur = UIBlurEffect(style: style)
        
        let blurView = UIVisualEffectView()
        blurView.effect = blur
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear
        if cornerRadius > 0 {
            blurView.layer.cornerRadius = cornerRadius
            blurView.layer.masksToBounds = true
        }
        
        self.insertSubview(blurView, at: 0)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -padding).isActive = true
        self.topAnchor.constraint(equalTo: blurView.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -padding).isActive = true
        
        if let imageView = self.imageView {
            imageView.backgroundColor = .clear
            self.bringSubviewToFront(imageView)
        }
    }
}

// MARK: - UIViewController
extension UIViewController {
    func addVC(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func removeVC() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

// MARK: - UIImage
extension UIImage {
    
    func getFileSizeInfo(allowedUnits: ByteCountFormatter.Units = .useMB, countStyle: ByteCountFormatter.CountStyle = .file) -> String? {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.countStyle = countStyle
        
        guard let imageData = jpegData(compressionQuality: 1.0) else { return nil }
        return formatter.string(fromByteCount: Int64(imageData.count))
    }
    
    func remakeOrientation(fromImage image: UIImage, withScale scale: CGFloat = 1.0) -> UIImage {
        return UIImage(cgImage: self.cgImage!, scale: scale, orientation: image.imageOrientation)
    }
}

// MARK: - String
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

// MARK: - UIView
extension UIView {
    
    /// Get the safe area layout of the device
    /// - Returns: The safe area layout
    func getSafeAreaInsets() -> UIEdgeInsets {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return .zero
        }
        return window.safeAreaInsets
    }
}
