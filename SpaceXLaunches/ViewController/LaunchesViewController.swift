//
//  ViewController.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 22.09.2022.
//

import UIKit
import SwiftUI

class LaunchesViewController: UIViewController, UINavigationControllerDelegate { // UISearchBarDelegate
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let defaults = UserDefaults.standard
    let refreshControl = UIRefreshControl()
    
    lazy var searchController: UISearchController = ({
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search launches..."
        return controller
    })()
    
    lazy var viewModel = {
        LaunchViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let order = Order(fromRawValue: defaults.string(forKey: K.defaultsKey.order))

        initNavBar()
        initView()
        initViewModel(with: order)
    }
    
    func initNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let filterImage = UIImage(systemName: "line.3.horizontal.decrease.circle")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterImage, style: .plain, target: self, action: #selector(addActionSheet))
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
    }
    
    func initView() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.systemGray6
        tableView.separatorColor = .black
        tableView.rowHeight = 72.0
        tableView.register(LaunchCell.nib, forCellReuseIdentifier: LaunchCell.identifier)
    }
    
    func initViewModel(with order: Order) {
        viewModel.order = order
        viewModel.getLaunches()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.showError = {
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: "Error", message: self?.viewModel.error , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                    self?.viewModel.getLaunches()
                }))
                self?.present(alert, animated: true)
            }
        }
    }
    
    @objc func addActionSheet() {
        let alert = UIAlertController(title: "Order by:", message: "Select which order do you want to have...", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Date - Ascending", style: .default, handler: { [weak self] action in
            self?.defaults.set(Order.ascending.rawValue, forKey: K.defaultsKey.order)
            self?.viewModel.order = .ascending
            self?.tableView.setContentOffset(.zero, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Date - Descending", style: .default, handler: { [weak self] action in
            self?.defaults.set(Order.descending.rawValue, forKey: K.defaultsKey.order)
            self?.viewModel.order = .descending
            self?.tableView.setContentOffset(.zero, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Name - Ascending", style: .default, handler: { [weak self] action in
            self?.defaults.set(Order.nameAscending.rawValue, forKey: K.defaultsKey.order)
            self?.viewModel.order = .nameAscending
            self?.tableView.setContentOffset(.zero, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Name - Descending", style: .default, handler: { [weak self] action in
            self?.defaults.set(Order.nameDescending.rawValue, forKey: K.defaultsKey.order)
            self?.viewModel.order = .nameDescending
            self?.tableView.setContentOffset(.zero, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func refresh() {
        viewModel.getLaunches()
        refreshControl.endRefreshing()
    }
}



//MARK: - LaunchCellDelegate
extension LaunchesViewController: LaunchCellDelegate {
    func cellPressed(with cell: LaunchCellViewModel) {
        let storyboard = UIStoryboard(name: K.storyboard.main, bundle: Bundle.main)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: K.identifier.detailVC) as? DetailViewController {
            detailVC.modalPresentationStyle = .fullScreen
            detailVC.viewModel = cell
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource
extension LaunchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCellViewModels.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchCell.identifier, for: indexPath) as? LaunchCell else { return UITableViewCell() }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        cell.cellDelegate = self
        
        if let smallImageUrl = cellVM.smallImageString {
            cell.thumbnailImageView.downloaded(from: smallImageUrl) {
                //TODO: image downloaded - completion handler can be used, bool can be added if the download was successful or not
            }
        } else {
            cell.thumbnailImageView.image = UIImage(systemName: "photo")
        }
        
        return cell
    }
}

//MARK: - UISearchBarDelegate
extension LaunchesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterData(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filterData(searchText: "")
    }
}

