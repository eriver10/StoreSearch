//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Grey on 9/22/23.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    
        

    override func awakeFromNib() {
        
        //Reminder: just like in viewdidload, its a good idea to call the method you are overriding.
        super.awakeFromNib()
        
        let selectedView = UIView(frame: CGRect.zero)
          selectedView.backgroundColor = UIColor(named:         "SearchBar")?.withAlphaComponent(0.5)
          selectedBackgroundView = selectedView
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
