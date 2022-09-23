//
//  LaunchManager.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation

protocol LaunchesServiceDelegate {
    func getLaunches(completion: @escaping (_ success: Bool,
                                            _ results: LaunchResponse?,
                                            _ error: String?) -> ())
}

class LaunchService {
}
