//
//  FilterListTableViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 24/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import PanModal

protocol FilterListDelegate {
    func didSelectFilter(filterName: FilterName)
}

class FilterListTableViewController: UITableViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private let CELL_ID = "filtersCell"
    private let filters: [Filter] = [
        .init(title: FilterName.KC01.rawValue, subtitle: "Film preset best suited for day to day photo.", image: #imageLiteral(resourceName: "kc01-ex")),
        .init(title: FilterName.KC02.rawValue, subtitle: "A Beautifully crafted black and white preset to emulate old film.", image: #imageLiteral(resourceName: "kc02-ex")),
        .init(title: FilterName.KC03.rawValue, subtitle: "Soft purple preset best suited for sunset and dusk.", image: #imageLiteral(resourceName: "kc03-ex"))
    ]
    var delegate: FilterListDelegate?
    var selectedFilterName: FilterName!
    
    private var isShortFormEnabled = true
    
    let headerView = FilterListHeaderView()
    let headerPresentable = ModalHeaderPresentable(title: "Filters")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar(tintColor: .label, title: "Filter List")
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = cancel
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filtersCell", for: indexPath) as! FilterListTableViewCell
        
        cell.filterImageView.image = filters[indexPath.row].image
        cell.filterTitleLabel.text = filters[indexPath.row].title
        cell.filterSubLabel.text = filters[indexPath.row].subtitle
        
        if filters[indexPath.row].title == selectedFilterName.rawValue {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.configure(with: headerPresentable)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedFilter = FilterName(rawValue: filters[indexPath.row].title) else { return }
        delegate?.didSelectFilter(filterName: selectedFilter)
        TapticHelper.shared.lightTaptic()
        cancelTapped()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc private func cancelTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}

extension FilterListTableViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return tableView
    }
    
    var shortFormHeight: PanModalHeight {
        return isShortFormEnabled ? .contentHeight(300.0) : longFormHeight
    }

    var anchorModalToLongForm: Bool {
        return false
    }
    
    var scrollIndicatorInsets: UIEdgeInsets {
        let bottomOffset = presentingViewController?.view.safeAreaInsets.bottom ?? 0
        return UIEdgeInsets(top: headerView.frame.size.height, left: 0, bottom: bottomOffset, right: 0)
    }

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let location = panModalGestureRecognizer.location(in: view)
        return headerView.frame.contains(location)
    }

    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state
            else { return }

        isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }
}
