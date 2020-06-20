//
//  GrainCustomisationViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 19/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import PanModal

class GrainCustomisationViewController: UIViewController {
    
    private let step: Float = 1
    
    private let strengthLabel: UILabel = {
       let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .label
        v.textAlignment = .left
        v.text = "+0"
        v.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize, weight: .medium)
        return v
    }()
    private let slider: UISlider = {
        let v = UISlider()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.minimumValue = 1
        v.maximumValue = 10
        v.isContinuous = true
        v.tintColor = .label
        return v
    }()
    private let containerView: UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar(tintColor: .label, title: "Grain", preferredLargeTitle: false, removeSeparator: true)
        self.view.backgroundColor = .systemBackground
        
        setupView()
        setupConstraint()
        
        // Overwrite the strengthLabel and slider to match UserDefaults
        strengthLabel.text = "Strength: +\(FilterValue.valueMap[.grain]!)"
        slider.setValue(Float(FilterValue.valueMap[.grain]!), animated: true)
        
        // Add event listener for the slider
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TapticHelper.shared.lightTaptic()
        FilterValue.valueMap[.grain] = CGFloat(slider.value)
        print("Grain strength new value: \(FilterValue.valueMap[.grain]!)")
    }
    
    private func setupView() {
        view.addSubview(strengthLabel)
        view.addSubview(containerView)
        
        containerView.addSubview(slider)
    }
    
    private func setupConstraint() {
        strengthLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        }
        
        containerView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(140)
            make.centerX.equalToSuperview()
            make.top.equalTo(strengthLabel.snp.bottom)
        }
        
        slider.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 0.85)
        }
    }
    
    @objc private func sliderValueDidChange(_ sender:UISlider!) {
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        DispatchQueue.main.async {
            self.strengthLabel.text = "Strength: +\(roundedStepValue)"
        }
    }
}

extension GrainCustomisationViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

}
