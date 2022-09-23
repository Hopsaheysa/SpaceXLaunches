//
//  LaunchViewModel.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation

class LaunchViewModel: NSObject {
    private var launchService: LaunchServiceProtocol
    
    
    var reloadTableView: (() -> Void)?
    var launches = Launches()
    
    var launchCellViewModels = [LaunchCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    init(launchService: LaunchServiceProtocol = LaunchService()) {
        self.launchService = launchService
    }
    
    
    func getLaunches() {
        launchService.getLaunches { success, result, error in
            if success, let launches = result {
                self.fetchData(launches: launches)
            } else {
                //TODO: let user know what was the problem
            }
        }
    }
    
    func fetchData(launches: Launches) {
        self.launches = launches
        var vms = [LaunchCellViewModel]()
        for launch in launches {
            vms.append(createCellModel(launch: launch))
        }
        launchCellViewModels = vms
    }
    
    func createCellModel(launch: Launch) -> LaunchCellViewModel {
        let rocketName = launch.rocketName
        
        return LaunchCellViewModel(rocketName: rocketName ?? "---")
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> LaunchCellViewModel {
        return launchCellViewModels[indexPath.row]
    }
}
