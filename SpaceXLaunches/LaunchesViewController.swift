//
//  ViewController.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 22.09.2022.
//

import UIKit

class LaunchesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel = {
        LaunchViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }


    func initView() {
        // TableView customization
        tableView.delegate = self
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
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: self.viewModel.error , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension LaunchesViewController: UITableViewDelegate {
    
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
        return cell
    }
    
    
}
