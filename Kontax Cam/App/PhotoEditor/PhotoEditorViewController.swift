//
//  PhotoEditorViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 30/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import Combine
import Backend

class PhotoEditorViewController: UIViewController {
    var image: UIImage! {
        didSet {
            editorPreview.image = image
        }
    }
    
    private var globalFilterValue = [FilterType: Any]()
    private var selectedFxs = [FilterType]()
    private var currentCollection = FilterCollection.aCollection
    private var filtersGestureEngine: FiltersGestureEngine!
    private let editorPreview = EditorPreview()
    private let lutImageFilter = LUTImageFilter()
    private var mStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("import to lab".localized, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        return button
    }()
    private var collectionIndex = 1
    
    var editedImage = PassthroughSubject<UIImage, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarTitle("")
        view.backgroundColor = .systemBackground
        self.addCloseButton()
        
        // Setup swipe gesture for filters
        filtersGestureEngine = FiltersGestureEngine(previewView: editorPreview)
        filtersGestureEngine.delegate = self
        
        setupActionButtons()
        setupView()
        setupConstraint()
        
        configureFilterValues()
    }
    
    private func setupView() {
        view.addSubview(editorPreview)
        view.addSubview(mStackView)
        view.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraint() {
        editorPreview.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.95)
            make.height.equalTo(self.view.frame.height * 0.65)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(10)
            make.centerX.equalToSuperview()
        }
        
        mStackView.snp.makeConstraints { (make) in
            make.top.equalTo(editorPreview.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-20)
        }
    }
    
    private func setupActionButtons() {
        let iconNames = ["fx", "filters.icon", "square.and.arrow.up"]
        var buttonTag = 0
        let buttonWidth: CGFloat = self.view.frame.width * 0.175
        let buttonHeight: CGFloat = 35
        
        for name in iconNames {
            let button = UIButton()
            button.frame = CGRect(origin: .zero, size: CGSize(width: buttonWidth, height: buttonHeight))
            button.clipsToBounds = true
            button.setImage(IconHelper.shared.getIconImage(iconName: name), for: .normal)
            button.tintColor = .label
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
            button.tag = buttonTag
            
            mStackView.addArrangedSubview(button)
            buttonTag += 1
        }
    }
    
    @objc private func actionButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let vc = FXCollectionViewController(collectionViewLayout: UICollectionViewLayout())
            vc.delegate = self
            vc.selectedFxs = selectedFxs
            vc.isFromEditor = true
            let navController = PanModalNavigationController(rootViewController: vc)
            self.presentPanModal(navController)
            
        case 1:
            let vc = FiltersCollectionViewController(collectionViewLayout: UICollectionViewLayout())
            vc.delegate = self
            vc.selectedCollection = currentCollection
            
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            
            self.present(navController, animated: true, completion: nil)
            
        case 2:
            if let image = editorPreview.editedImageView.image {
                ShareHelper.shared.presentShare(withImage: image, toView: self)
            }
            
        default: break
        }
    }
    
    @objc private func doneButtonTapped() {
        if let image = editorPreview.editedImageView.image {
            storeBackValue()
            editedImage.send(image)
            self.dismiss(animated: true, completion: nil)
        } else {
            AlertHelper.shared.presentOKAction(withTitle: "Something went wrong.".localized, andMessage: "We are unable to import the image. Please try again.".localized, to: self)
        }
    }
    
    private func smartAppend(_ selectedFx: FilterType) {
        if selectedFxs.contains(selectedFx) {
            selectedFxs.remove(at: selectedFxs.firstIndex(where: { $0 == selectedFx })!)
        } else {
            selectedFxs.append(selectedFx)
        }
        selectedFxs.sort(by: { $0.rawValue < $1.rawValue })
    }
    
    /// Prepare global filter value for photo editor
    private func configureFilterValues() {
        globalFilterValue = [
            .colourleaks: FilterValue.Colourleaks.selectedColourValue,
            .grain: FilterValue.Grain.strength,
            .dust: FilterValue.Dust.strength,
            .lightleaks: FilterValue.Lightleaks.strength]
        
        FilterValue.reset()
    }
    
    /// Store back the camera's filter value back after photo editor has done making changes
    private func storeBackValue() {
        FilterValue.Colourleaks.selectedColourValue = globalFilterValue[.colourleaks] as! FilterValue.Colourleaks.ColourValue
        FilterValue.Grain.strength = globalFilterValue[.grain] as! CGFloat
        FilterValue.Dust.strength = globalFilterValue[.dust] as! CGFloat
        FilterValue.Lightleaks.strength = globalFilterValue[.lightleaks] as! CGFloat
    }
    
    @objc override func closeTapped() {
        storeBackValue()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoEditorViewController: FilterListDelegate {
    func filterListDidSelectCollection(_ collection: FilterCollection) {
        currentCollection = collection
        filtersGestureEngine.collectionCount = currentCollection.filters.count + 1
        
        if let editedImage = FilterEngine.shared.process(image: image, selectedFilters: selectedFxs, lut: currentCollection.filters.first) {
            editorPreview.editedImageView.image = editedImage
            editorPreview.filterLabelView.titleLabel.text = currentCollection.filters.first!.rawValue.uppercased()
        }
    }
}

extension PhotoEditorViewController: FiltersGestureDelegate {
    func didSwipeToChangeFilter(withNewIndex newIndex: Int) {
        collectionIndex = newIndex
        let loadingVC = LoadingViewController()
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        TapticHelper.shared.lightTaptic()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Add loadingVC
            DispatchQueue.main.async {
                window.addSubview(loadingVC.view)
                loadingVC.view.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            
            if newIndex > 0 {
                if let editedImage = FilterEngine.shared.process(image: self.image, selectedFilters: self.selectedFxs, lut: self.currentCollection.filters[newIndex - 1]) {
                    DispatchQueue.main.async {
                        self.editorPreview.editedImageView.image = editedImage
                    }
                }
                
                DispatchQueue.main.async {
                    self.editorPreview.filterLabelView.titleLabel.text = self.currentCollection.filters[newIndex - 1].rawValue.uppercased()
                    loadingVC.view.removeFromSuperview()
                }
            } else {
                if let editedImage = FilterEngine.shared.process(image: self.image, selectedFilters: self.selectedFxs, lut: nil) {
                    DispatchQueue.main.async {
                        self.editorPreview.editedImageView.image = editedImage
                    }
                }
                
                DispatchQueue.main.async {
                    self.editorPreview.filterLabelView.titleLabel.text = "OFF"
                    loadingVC.view.removeFromSuperview()
                }
            }
        }
    }
}

extension PhotoEditorViewController: FXCollectionDelegate {
    func didTapEffect(effect: FilterType) {
        smartAppend(effect)
        let loadingVC = LoadingViewController()
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                window.addSubview(loadingVC.view)
                loadingVC.view.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            
            if let editedImage = FilterEngine.shared.process(image: self.image, selectedFilters: self.selectedFxs, lut: self.collectionIndex == 0 ? nil : self.currentCollection.filters[self.collectionIndex - 1]) {
                DispatchQueue.main.async {
                    self.editorPreview.editedImageView.image = editedImage
                    loadingVC.view.removeFromSuperview()
                }
            }
        }
    }
    
    func didTapDone() {
        let loadingVC = LoadingViewController()
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                window.addSubview(loadingVC.view)
                loadingVC.view.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            
            if let editedImage = FilterEngine.shared.process(image: self.image, selectedFilters: self.selectedFxs, lut: self.collectionIndex == 0 ? nil : self.currentCollection.filters[self.collectionIndex - 1]) {
                DispatchQueue.main.async {
                    self.editorPreview.editedImageView.image = editedImage
                    loadingVC.view.removeFromSuperview()
                }
            }
        }
    }
}
