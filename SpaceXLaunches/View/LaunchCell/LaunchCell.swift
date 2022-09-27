//
//  LaunchCell.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import UIKit

protocol LaunchCellDelegate {
    func cellPressed(with cell: LaunchCellViewModel)
}


class LaunchCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    
    
    @IBOutlet weak var cellView: UIView!
    
    var cellDelegate: LaunchCellDelegate?
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil)}
    
    var cellViewModel: LaunchCellViewModel? {
        didSet {
            nameLabel.text = cellViewModel?.rocketName
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            if let date = cellViewModel?.date {
                dateLabel.text = dateFormatter.string(from: date)
            } else {
                dateLabel.text = "not filled"
            }

            
            thumbnailImageView.image = UIImage(systemName: "photos")
            
        }
    }
    
    var downloadedImage: UIImage? {
        didSet {
            thumbnailImageView.image = downloadedImage
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
        
        let tapCardGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        cellView.addGestureRecognizer(tapCardGesture)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
    
    @objc func cellTapped() {
        guard let cellVM = cellViewModel else { return }
        self.cellDelegate?.cellPressed(with: cellVM)
    }
}
