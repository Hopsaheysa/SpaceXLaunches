//
//  DetailViewController.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 26.09.2022.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    var viewModel: LaunchCellViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.rocketName
        

    }
    

}
