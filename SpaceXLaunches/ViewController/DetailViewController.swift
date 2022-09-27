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
    @IBOutlet weak var detailTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var backgroundView: UIView!
    
    var viewModel: LaunchCellViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageURL = viewModel?.largeImageString {
            imageView.downloaded(from: imageURL)
        }
        
        if ((viewModel?.success) != true ) {
            backgroundView.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        } else {
            backgroundView.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0.5, alpha: 1)
        }
        
        titleLabel.text = viewModel?.rocketName
        
        if let detail = viewModel?.details {
            detailTextView.text = detail
            detailTextViewHeightConstraint.constant = self.detailTextView.contentSize.height
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
    }
    
    
    @IBAction func youtubeButtonPressed(_ sender: Any) {
        if let youtubeId = viewModel?.youtubeId {
            if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
               UIApplication.shared.canOpenURL(youtubeURL) {
                // redirect to app
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId)") {
                // redirect through safari
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: ErrorEnum.urlFail.errorDescription , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    @IBAction func articleButtonPressed(_ sender: Any) {
        openSafari(with: viewModel?.article)
    }
    
    @IBAction func wikiButtonPressed(_ sender: Any) {
        openSafari(with: viewModel?.wikipedia)
    }
    
    
    func openSafari(with urlOptionalString: String?) {
        guard let urlString = urlOptionalString, let url = URL(string: urlString) else {
            let alert = UIAlertController(title: "Error", message: ErrorEnum.urlFail.errorDescription , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        UIApplication.shared.open(url)
    }
}
