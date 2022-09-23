//
//  LaunchCell.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import UIKit

class LaunchCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil)}
    
    var cellViewModel: LaunchCellViewModel? {
        didSet {
            nameLabel.text = cellViewModel?.rocketName
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    func initView() {
        // Cell view customization
        backgroundColor = .clear
        
        // Line separator full width
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
