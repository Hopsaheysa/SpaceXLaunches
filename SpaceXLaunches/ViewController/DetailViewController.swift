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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    var viewModel: LaunchCellViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = viewModel?.rocketName

        if let detail = viewModel?.details {
            detailTextView.text = detail
        } else {
            detailTextView.isHidden = true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let date = viewModel?.date {
            dateLabel.text = "Launch date: \(dateFormatter.string(from: date))"
        } else {
            dateLabel.text = "not filled"
        }
        
        if let imageURL = viewModel?.largeImageString {
            imageView.downloaded(from: imageURL)
        }

        
        

    }
    

}
