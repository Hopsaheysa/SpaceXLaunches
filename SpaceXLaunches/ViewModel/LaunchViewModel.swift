//
//  LaunchViewModel.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation
import UIKit

class LaunchViewModel {
    private var launchService: LaunchServiceProtocol
    //    private var cellPressedDelegate: LaunchCellDelegate
    
    
    var reloadTableView: (() -> Void)?
    var showError: (() -> Void)?
    
    var launches = Launches()
    
    var launchCellViewModels = [LaunchCellViewModel]() {
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
        for launch in launches {
            vms.append(createCellModel(launch: launch))
        }
        launchCellViewModels = vms
    }
    
    func showError(error: String?) {
        if let error = error {
            self.error = error
        } else {
            self.error = ErrorResponse.unknownFail.errorDescription
        }
    }
    
    func getDate(date: String) -> Date {
        return DateHelper.stringToDate(date)
    }
    
    func createCellModel(launch: Launch) -> LaunchCellViewModel {
        let rocketName = launch.rocketName ?? ""
        let details = launch.details ?? ""
        let upcoming = launch.upcoming ?? false
        let date = launch.date ?? Date.distantPast
        
        let webcast = launch.webcast
        let article = launch.article
        let wikipedia = launch.wikipedia
        let youtubeId = launch.youtubeId
        
        let smallImageString = launch.smallImage
        let largeImageString = launch.largeImage
        
        
        
        return LaunchCellViewModel(rocketName: rocketName,
                                   details: details,
                                   upcoming: upcoming,
                                   date: date,
                                   webcast: webcast,
                                   article: article,
                                   wikipedia: wikipedia,
                                   youtubeId: youtubeId,
                                   smallImageString: smallImageString,
                                   largeImageString: largeImageString)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> LaunchCellViewModel {
        return launchCellViewModels[indexPath.row]
    }
    
}
