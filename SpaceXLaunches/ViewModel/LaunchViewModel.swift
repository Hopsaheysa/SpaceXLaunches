//
//  LaunchViewModel.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation

class LaunchViewModel {
    private var launchService: LaunchServiceProtocol
    
    
    var reloadTableView: (() -> Void)?
    var showError: (() -> Void)?
    
    var launches = Launches()
    var order: Order? = Order(fromRawValue: "other") {
        didSet {
            fetchData(launches: launches)
        }
    }
    
    var launchCellViewModels = [LaunchCellViewModel]() {
        didSet {
            filteredCellViewModels = launchCellViewModels
        }
    }
    
    var filteredCellViewModels = [LaunchCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    
    var error: String? {
        didSet {
            showError?()
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
                self.showError(error: error)
            }
        }
    }
    
    
    
    func fetchData(launches: Launches) {
        self.launches = launches
        var vms = [LaunchCellViewModel]()
        
        if order == .descending {
            for launch in launches {
                vms.insert(createCellModel(launch: launch), at: 0)
            }
        } else {
            for launch in launches {
                vms.append(createCellModel(launch: launch))
            }
        }
        launchCellViewModels = vms
    }
    
    func filterData(searchText: String) {
        filteredCellViewModels = searchText.isEmpty ? launchCellViewModels : launchCellViewModels.filter { $0.rocketName.range(of: searchText, options: .caseInsensitive) != nil }
    }
    
    func showError(error: String?) {
        if let error = error {
            self.error = error
        } else {
            self.error = ErrorEnum.unknownFail.errorDescription
        }
    }
    
    func getDate(date: String) -> Date {
        return DateHelper.stringToDate(date)
    }
    
    func createCellModel(launch: Launch) -> LaunchCellViewModel {
        let rocketName = launch.rocketName ?? ""
        let details = launch.details ?? ""
        let upcoming = launch.upcoming ?? false
        let success = launch.success ?? false
        let date = launch.date ?? Date.distantPast
        
        let article = launch.article
        let wikipedia = launch.wikipedia
        let youtubeId = launch.youtubeId
        
        let smallImageString = launch.smallImage
        let largeImageString = launch.largeImage
        
        return LaunchCellViewModel(rocketName: rocketName,
                                   details: details,
                                   upcoming: upcoming,
                                   success: success,
                                   date: date,
                                   article: article,
                                   wikipedia: wikipedia,
                                   youtubeId: youtubeId,
                                   smallImageString: smallImageString,
                                   largeImageString: largeImageString)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> LaunchCellViewModel {
        return filteredCellViewModels[indexPath.row]
    }
    
}
