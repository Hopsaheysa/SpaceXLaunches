//
//  ViewController.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 22.09.2022.
//

import UIKit

class LaunchesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
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
        //TODO: add code
    }
}

//MARK: - UITableViewDelegate
extension LaunchesViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource
extension LaunchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchCell.identifier, for: indexPath)
                as? LaunchCell else { return UITableViewCell() }
        return cell
    }
    
    
}
