//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Grey on 9/25/23.
//
import UIKit
//This imports the MFMailComposeViewController from the MessageUI framework
import MessageUI







class DetailViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        
      super.init(coder: aDecoder)
   
        /*
         Cannot assign value of type 'DetailViewController' to type '(any UIViewControllerTransitioningDelegate)?'
        Add missing conformance to 'UIViewControllerTransitioningDelegate' to class 'DetailViewController'
         */
        
      // transitioningDelegate = self

      transitioningDelegate = self
    }
    
  
    var searchResult: SearchResult! {
        didSet {
            if isViewLoaded {
                updateUI() }
        }
    }
    
  var downloadTask: URLSessionDownloadTask?
  var dismissStyle = AnimationStyle.fade
  var isPopUp = false
  
  
  @IBOutlet var popupView: UIView!
  @IBOutlet var artworkImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var artistNameLabel: UILabel!
  @IBOutlet var kindLabel: UILabel!
  @IBOutlet var genreLabel: UILabel!
  @IBOutlet var priceButton: UIButton!





  deinit {
    print("deinit \(self)")
    downloadTask?.cancel()
  }

    enum AnimationStyle {
        
        case slide
        case fade
    }
    
    
    
  // MARK: - Actions
  @IBAction func close() {
        
      dismissStyle = .slide
      dismiss(animated: true, completion: nil)
    }

  @IBAction func openInStore() {
    if let url = URL(string: searchResult.storeURL) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }

  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isPopUp {
            popupView.layer.cornerRadius = 10
            let gestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(close))
            gestureRecognizer.cancelsTouchesInView = false
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
            // Gradient view
            view.backgroundColor = UIColor.clear
            let dimmingView = GradientView(frame: CGRect.zero)
            dimmingView.frame = view.bounds
            view.insertSubview(dimmingView, at: 0)
        } else {
            view.backgroundColor = UIColor(patternImage: UIImage(
                named: "LandscapeBackground")!)
            popupView.isHidden = true
            
            
            // Popover action button
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showPopover(_:)))
            
        }
      
        if searchResult != nil {
      updateUI() }
      }
  
    
    
    @objc func showPopover(_ sender: UIBarButtonItem) {
        
        
      guard let popover = storyboard?.instantiateViewController(withIdentifier: "PopoverView") as? MenuViewController else { return }
      popover.modalPresentationStyle = .popover
      if let ppc = popover.popoverPresentationController {
        ppc.barButtonItem = sender
      }
       //DEBUG
      popover.delegate = self
      present(popover, animated: true, completion: nil)
    }

    
    
    
    
    
    
  
  // MARK: - Helper Methods
  func updateUI() {
    nameLabel.text = searchResult.name

    if searchResult.artist.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = searchResult.artist
    }

    kindLabel.text = searchResult.type
    genreLabel.text = searchResult.genre
    // Show price
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = searchResult.currency

    let priceText: String
    if searchResult.price == 0 {
      priceText = "Free"
    } else if let text = formatter.string(from: searchResult.price as NSNumber) {
      priceText = text
    } else {
      priceText = ""
    }
    priceButton.setTitle(priceText, for: .normal)
    // Get image
    if let largeURL = URL(string: searchResult.imageLarge) {
      downloadTask = artworkImageView.loadImage(url: largeURL)
    }
      popupView.isHidden = false
  }
}




//EXTENSION\\

extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
}


extension DetailViewController: MenuViewControllerDelegate {
  func menuViewControllerSendEmail(_: MenuViewController) {
    dismiss(animated: true) {
        
      if MFMailComposeViewController.canSendMail() {
          
        let controller = MFMailComposeViewController()
        controller.setSubject(
          NSLocalizedString("Support Request", comment: "Email subject"))
        controller.setToRecipients(["your@email-address-here.com"])
        controller.mailComposeDelegate = self
        self.present(controller, animated: true, completion: nil)
      }
    }
  }
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
    
  func mailComposeController(
    _ controller: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error: Error?
  ) {
      
    dismiss(animated: true, completion: nil)
  }
}
