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
        let order = Order(fromRawValue: defaults.string(forKey: "ORDER"))
        let filterImage = UIImage(systemName: "line.3.horizontal.decrease.circle")?.withRenderingMode(.alwaysOriginal)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterImage, style: .plain, target: self, action: #selector(addActionSheet))
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
        

        
        initView()
        initViewModel(with: order)
        
    }


    func initView() {
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.lightGray
        tableView.separatorColor = .white
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
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
    }
    
    @objc func addActionSheet() {
        let alert = UIAlertController(title: "Order by:", message: "Select which order do you want to have...", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ascending", style: .default, handler: { [weak self] action in
            self?.defaults.set("Ascending", forKey: "ORDER")
            self?.viewModel.order = .ascending
            self?.tableView.setContentOffset(.zero, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Descending", style: .default, handler: { [weak self] action in
            self?.defaults.set("Descending", forKey: "ORDER")
            self?.viewModel.order = .descending
            self?.tableView.setContentOffset(.zero, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}



//MARK: - UITableViewDelegate + LaunchCellDelegate
extension LaunchesViewController: LaunchCellDelegate {
    
    func cellPressed(with cell: LaunchCellViewModel) {

        let storyboard = UIStoryboard(name: K.storyboard.main, bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: K.identifier.detailVC) as? DetailViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.viewModel = cell
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource
extension LaunchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searching {
//            return searchedCountry.count
//        } else {
            return viewModel.filteredCellViewModels.count
//        }
        
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchCell.identifier, for: indexPath) as? LaunchCell else { return UITableViewCell() }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        cell.cellDelegate = self
        
        
        if let url = cellVM.smallImageString {
            cell.thumbnailImageView.downloaded(from: url)
        } else {
            cell.thumbnailImageView.image = UIImage(systemName: "photo")
        }
    
        return cell
    }
}

extension LaunchesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterData(searchText: searchText)

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filterData(searchText: "")
    }
}

