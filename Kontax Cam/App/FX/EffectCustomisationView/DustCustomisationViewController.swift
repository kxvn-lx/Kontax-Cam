//
//  DustCustomisationViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 21/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import PanModal
import Backend

class DustCustomisationViewController: UIViewController {

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
        self.setNavigationBarTitle("Dust")
        self.addCloseButton()
        self.view.backgroundColor = .systemBackground
        
        setupView()
        setupConstraint()
        
        controlView.delegate = self
        
        // Overwrite the strengthLabel and slider
        controlView.controlTitleLabel.text = "Strength: +\(FilterValue.Dust.strength)"
        slider.setValue(Float(FilterValue.Dust.strength), animated: true)
        
        // Add event listener for the slider
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
    }

    private func setupView() {
        view.addSubview(controlView)
        view.addSubview(containerView)
        
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
    
    @objc private func sliderValueDidChange(_ sender: UISlider!) {
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        DispatchQueue.main.async {
            self.controlView.controlTitleLabel.text = "Strength: +\(roundedStepValue)"
        }
    }
}

extension DustCustomisationViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
}

extension DustCustomisationViewController: CustomisationControlProtocol {
    func didTapDone() {
        FilterValue.Dust.strength = CGFloat(slider.value)
        print("Dust strength new value: \(FilterValue.Dust.strength)")
        
        TapticHelper.shared.successTaptic()
        dismiss(animated: true, completion: nil)
    }
}
