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
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var articleButton: UIButton!
    @IBOutlet weak var wikiButton: UIButton!
    

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewModel: LaunchCellViewModel!
    var temporaryDirectoryURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLoadingView()
        
        if let imageURL = viewModel?.largeImageString {
            imageView.downloaded(from: imageURL) { [weak self] success in
                self?.showDetailView(success)
            }
        } else if let imageSmall = viewModel?.smallImageString {
            imageView.downloaded(from: imageSmall) { [weak self] success in
                self?.showDetailView(success)
            }
        } else {
            showDetailView(false)
        }
    }
    
    func prepareLoadingView() {
        detailView.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func showDetailView(_ success: Bool) {
        if !success {
            imageView.image = UIImage(systemName: "photo")
        }
        detailView.isHidden = false
        spinner.isHidden = true
        
        if ((viewModel.success) == true) {
            backgroundView.backgroundColor = UIColor(named: K.color.lightGreen)
        } else if ((viewModel.upcoming) == true){
            backgroundView.backgroundColor = UIColor(named: K.color.lightBlue)
        } else {
            backgroundView.backgroundColor = UIColor(named: K.color.lightRed)
        }
        
        titleLabel.text = viewModel.rocketName
        
        if let detail = viewModel.details {
            detailTextView.text = detail
        } else {
            detailTextView.isHidden = true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateLabel.text = "Launch date: \(dateFormatter.string(from: viewModel.date ))"

        if viewModel.youtubeId == nil {
            youtubeButton.isHidden = true
        }
        if viewModel.article == nil {
            articleButton.isHidden = true
        }
        if viewModel.wikipedia == nil {
            wikiButton.isHidden = true
        }
    }
    
    
    
    @IBAction func youtubeButtonPressed(_ sender: Any) {
        if let youtubeId = viewModel.youtubeId {
            if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
               UIApplication.shared.canOpenURL(youtubeURL) {
                // app
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId)") {
                // safari
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: ErrorEnum.urlFail.errorDescription , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    @IBAction func articleButtonPressed(_ sender: Any) {
        openSafari(with: viewModel.article)
    }
    
    @IBAction func wikiButtonPressed(_ sender: Any) {
        openSafari(with: viewModel.wikipedia)
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
