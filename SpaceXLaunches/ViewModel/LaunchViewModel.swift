//
//  LaunchViewModel.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation

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
    
    
    func getLaunches(with order: Order) {
        launchService.getLaunches { success, result, error in
            if success, let launches = result {
                self.fetchData(launches: launches, with: order)
            } else {
                self.showError(error: error)
            }
        }
    }
    
    func getFilteredLaunches(_ searchText: String) {
        let filteredLaunches = launchCellViewModels.filter { viewModel in
            viewModel.rocketName.contains(searchText)
        }
        
        //        self.fetchData(launches: filteredLaunches)
    }
    
    
    
    func fetchData(launches: Launches, with order: Order) {
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
        
//        var smallImageData: Observable<Data> = Observable()
//        
//        if let smallImageString = smallImageString {
//            launchService.getImage(from: smallImageString) { success, results, error in
//                if success, let data = results {
//                    smallImageData = Observable<data>
//                }
//            }
//        }
//        
        
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
    
    func fetchImage() {
        
    }
    
}
