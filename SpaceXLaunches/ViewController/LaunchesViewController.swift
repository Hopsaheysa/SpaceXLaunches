//
//  ViewController.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 22.09.2022.
//

import UIKit
import SwiftUI

class LaunchesViewController: UIViewController { // UISearchBarDelegate
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var viewModel = {
        LaunchViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        searchBar.delegate = self
        initView()
        initViewModel()
    }


    func initView() {
        // TableView customization
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.gray
        tableView.separatorColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false

        tableView.register(LaunchCell.nib, forCellReuseIdentifier: LaunchCell.identifier)
    }
    
    func initViewModel() {
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
}



//MARK: - UITableViewDelegate + LaunchCellDelegate
extension LaunchesViewController: LaunchCellDelegate { 
    func cellPressed(with cell: LaunchCellViewModel) {

        let storyboard = UIStoryboard(name: K.storyboard.main, bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: K.identifier.detailVC) as? DetailViewController {
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }
        
//        performSegue(withIdentifier: K.segue.toDetail, sender: self)
        
        //        let detailView = LaunchDetailView(data: cell)
//
//        let swiftUIViewController = UIHostingController(rootView: detailView)
//        self.navigationController?.pushViewController(swiftUIViewController, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension LaunchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.launchCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchCell.identifier, for: indexPath) as? LaunchCell else { return UITableViewCell() }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        cell.cellDelegate = self
        
        //I know this is terrible but I failed to move it directly to ViewModel :( probably with caching
        if let smallUrlString = cellVM.smallImageString, let url = URL(string: smallUrlString) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let data = data {
                        cell.thumbnailImageView.image = UIImage(data:data)
                    }
                }
            }
        }
    
        return cell
    }
}


