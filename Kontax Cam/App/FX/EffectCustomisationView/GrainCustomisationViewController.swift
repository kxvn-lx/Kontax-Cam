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
    private let controlView = CustomisationControlHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar(tintColor: .label, title: "Grain", preferredLargeTitle: false, removeSeparator: true)
        self.view.backgroundColor = .systemBackground
        
        setupView()
        setupConstraint()
        
        // Overwrite the strengthLabel and slider
        controlView.controlTitleLabel.text = "Strength: +\(FilterValue.Grain.strength)"
        slider.setValue(Float(FilterValue.Grain.strength), animated: true)
        
        // Add event listener for the slider
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        
        // Setup delegate
        controlView.delegate = self
    }
    
    private func setupView() {
        view.addSubview(containerView)
        view.addSubview(controlView)
        
        containerView.addSubview(slider)
    }
    
    private func setupConstraint() {
        controlView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 0.85)
            make.height.equalTo(40)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(115)
            make.centerX.equalToSuperview()
            make.top.equalTo(controlView.snp.bottom)
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
            self.controlView.controlTitleLabel.text = "Strength: +\(roundedStepValue)"
        }
    }
}

extension GrainCustomisationViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
}

extension GrainCustomisationViewController: CustomisationControlProtocol {
    func didTapDone() {
        TapticHelper.shared.lightTaptic()
        FilterValue.Grain.strength = CGFloat(slider.value)
        print("Grain strength new value: \(FilterValue.Grain.strength)")
        SPAlertHelper.shared.present(title: "Grain set to: \(slider.value)")
        dismiss(animated: true, completion: nil)
    }
}
