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
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var cellDelegate: LaunchCellDelegate?
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil)}
    
    var cellViewModel: LaunchCellViewModel! {
        didSet {
            nameLabel.text = cellViewModel.rocketName
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            dateLabel.text = "Launch date: \(dateFormatter.string(from: cellViewModel.date))"
            
            if let details = cellViewModel.details {
                detailLabel.isHidden = false
                detailLabel.text = details
            } else {
                detailLabel.isHidden = true
            }
            
            if ((cellViewModel.upcoming) == true ) {
                cellView.backgroundColor = .systemGray4
            }
            
            if ((cellViewModel.success) == true ) {
                successLabel.text = "Success"
                successImageView.image = UIImage(systemName: "checkmark.seal.fill")
                successImageView.tintColor = .green
            } else {
                if ((cellViewModel.upcoming) == true ) {
                    successImageView.isHidden = true
                    successLabel.isHidden = true
                } else {
                    successLabel.text = "Fail"
                    successImageView.image = UIImage(systemName: "xmark.seal.fill")
                    successImageView.tintColor = .red
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    func initView() {
        backgroundColor = .clear
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        let tapCardGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        cellView.addGestureRecognizer(tapCardGesture)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        thumbnailImageView.image = nil
        successImageView.isHidden = false
        successLabel.isHidden = false
        cellView.backgroundColor = .clear
    }
    
    @objc func cellTapped() {
        guard let cellVM = cellViewModel else { return }
        self.cellDelegate?.cellPressed(with: cellVM)
    }
}
