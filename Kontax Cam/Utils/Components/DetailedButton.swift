//
//  DetailedButton.swift
//  Ghibliii
//
//  Created by Kevin Laminto on 2/8/20.
//

import UIKit

class DetailedButton: UIButton {
    
    var highlightedBackgroundColor: UIColor? = UIColor(displayP3Red: 15/255, green: 15/255, blue: 15/255, alpha: 1)
    private var temporaryBackgroundColor: UIColor?
    private let highlightedAlphaValue: CGFloat = 0.5
    private let disabledAlphaValue: CGFloat = 0.4
    
    required init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setupView()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                if temporaryBackgroundColor == nil {
                    if backgroundColor != nil {
                        if let highlightedColor = highlightedBackgroundColor {
                            temporaryBackgroundColor = backgroundColor
                            backgroundColor = highlightedColor
                        } else {
                            temporaryBackgroundColor = backgroundColor
                            backgroundColor = temporaryBackgroundColor?.withAlphaComponent(highlightedAlphaValue)
                        }
                    }
                }
            } else {
                if let temporaryColor = temporaryBackgroundColor {
                    backgroundColor = temporaryColor
                    temporaryBackgroundColor = nil
                }
            }
        }
    }
    
    private func setupView() {
        self.titleLabel?.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
        setTitleColor(.white, for: .normal)
        setTitleColor(.systemGray3, for: .disabled)
        tintColor = .white
        self.adjustsImageWhenHighlighted = false
        
        layer.cornerRadius = 5
        layer.cornerCurve = .continuous
    }
    
}
