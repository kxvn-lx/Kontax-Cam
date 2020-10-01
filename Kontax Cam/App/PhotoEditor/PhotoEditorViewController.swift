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
    
    private let globalFilterValue: [FilterType: Any] = [
        .colourleaks: FilterValue.Colourleaks.selectedColourValue,
        .grain: FilterValue.Grain.strength,
        .dust: FilterValue.Dust.strength,
        .lightleaks: FilterValue.Lightleaks.strength
    ]
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
    private var collectionIndex = 0
    
    var editedImage = PassthroughSubject<UIImage, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarTitle("")
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Setup swipe gesture for filters
        filtersGestureEngine = FiltersGestureEngine(previewView: editorPreview)
        filtersGestureEngine.delegate = self
        
        setupActionButtons()
        setupView()
        setupConstraint()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FilterValue.Colourleaks.selectedColourValue = globalFilterValue[.colourleaks] as! FilterValue.Colourleaks.ColourValue
        FilterValue.Grain.strength = globalFilterValue[.grain] as! CGFloat
        FilterValue.Dust.strength = globalFilterValue[.dust] as! CGFloat
        FilterValue.Lightleaks.strength = globalFilterValue[.lightleaks] as! CGFloat
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
            editedImage.send(image)
            self.navigationController?.popViewController(animated: true)
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
}

extension PhotoEditorViewController: FilterListDelegate {
    func filterListDidSelectCollection(_ collection: FilterCollection) {
        currentCollection = collection
        filtersGestureEngine.collectionCount = currentCollection.filters.count + 1
        if let processedImage = lutImageFilter.process(filterName: currentCollection.filters.first!, imageToEdit: image) {
            if !selectedFxs.isEmpty {
                if let editedImage = FilterEngine.shared.process(image: processedImage, selectedFilters: self.selectedFxs) {
                    editorPreview.editedImageView.image = editedImage
                }
            } else {
                editorPreview.editedImageView.image = processedImage
            }
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
            
            DispatchQueue.main.async {
                window.addSubview(loadingVC.view)
                loadingVC.view.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            
            if newIndex > 0 {
                if let processedImage = self.lutImageFilter.process(filterName: self.currentCollection.filters[newIndex - 1], imageToEdit: self.image) {
                    if !self.selectedFxs.isEmpty {
                        if let editedImage = FilterEngine.shared.process(image: processedImage, selectedFilters: self.selectedFxs) {
                            DispatchQueue.main.async {
                                self.editorPreview.editedImageView.image = editedImage
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.editorPreview.editedImageView.image = processedImage
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.editorPreview.filterLabelView.titleLabel.text = self.currentCollection.filters[newIndex - 1].rawValue.uppercased()
                        loadingVC.view.removeFromSuperview()
                    }
                }
            } else {
                if !self.selectedFxs.isEmpty {
                    if let editedImage = FilterEngine.shared.process(image: self.image, selectedFilters: self.selectedFxs) {
                        DispatchQueue.main.async {
                            self.editorPreview.editedImageView.image = editedImage
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.editorPreview.editedImageView.image = self.image
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
                
                if self.editorPreview.filterLabelView.titleLabel.text != "OFF" {
                    if let processedImage = self.lutImageFilter.process(filterName: self.currentCollection.filters[self.collectionIndex - 1], imageToEdit: self.image) {
                        if let editedImage = FilterEngine.shared.process(image: processedImage, selectedFilters: self.selectedFxs) {
                            DispatchQueue.main.async {
                                self.editorPreview.editedImageView.image = editedImage
                                loadingVC.view.removeFromSuperview()
                            }
                        }
                    }
                } else {
                    if let editedImage = FilterEngine.shared.process(image: self.image, selectedFilters: self.selectedFxs) {
                        DispatchQueue.main.async {
                            self.editorPreview.editedImageView.image = editedImage
                            loadingVC.view.removeFromSuperview()
                        }
                    }
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
                
                if self.editorPreview.filterLabelView.titleLabel.text != "OFF" {
                    if let processedImage = self.lutImageFilter.process(filterName: self.currentCollection.filters[self.collectionIndex - 1], imageToEdit: self.image) {
                        if let editedImage = FilterEngine.shared.process(image: processedImage, selectedFilters: self.selectedFxs) {
                            DispatchQueue.main.async {
                                self.editorPreview.editedImageView.image = editedImage
                                loadingVC.view.removeFromSuperview()
                            }
                        }
                    }
                } else {
                    if let editedImage = FilterEngine.shared.process(image: self.image, selectedFilters: self.selectedFxs) {
                        DispatchQueue.main.async {
                            self.editorPreview.editedImageView.image = editedImage
                            loadingVC.view.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
}
