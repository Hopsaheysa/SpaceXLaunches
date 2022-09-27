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
    
    let searchController = UISearchController()
    lazy var viewModel = {
        LaunchViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(systemName: "line.3.horizontal.decrease.circle")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addActionSheet))
        navigationItem.searchController = searchController
        
        let order = Order(fromRawValue: defaults.string(forKey: "ORDER")) 
        
//        searchBar.delegate = self
        initView()
        initViewModel(with: order)
    }


    func initView() {
        // TableView customization
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.gray
        tableView.separatorColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.rowHeight = 72.0

        tableView.register(LaunchCell.nib, forCellReuseIdentifier: LaunchCell.identifier)
    }
    
    func initViewModel(with order: Order) {
        viewModel.getLaunches(with: order)
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
        let alert = UIAlertController(title: "Order by:", message: "Select which order do you want to order launches", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ascending", style: .default, handler: { [weak self] action in
            //TODO: save choice and reload data accordingly
            self?.defaults.set("Ascending", forKey: "ORDER")
            self?.viewModel.getLaunches(with: .ascending)
            self?.tableView.setContentOffset(.zero, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Descending", style: .default, handler: { [weak self] action in
            self?.defaults.set("Descending", forKey: "ORDER")
            self?.viewModel.getLaunches(with: .descending)
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
            return viewModel.launchCellViewModels.count
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
            cell.thumbnailImageView.sizeThatFits(CGSize(width: 24, height: 24))
        }
    
        return cell
    }
}

extension LaunchesViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchedCountry = viewModel.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
//        searching = true
//        tableView.reloadData()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searching = false
//        searchBar.text = ""
//        tableView.reloadData()
//    }
}

