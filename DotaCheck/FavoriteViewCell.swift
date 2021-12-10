//
//  FavoriteViewCell.swift
//  DotaCheck
//
//  Created by Hui Hong Zheng on 12/1/21.
//

import UIKit
/*
 a subclass of FavoriteTableController helps to manage the display
 for player account number and the name
 */
class FavoriteViewCell: UITableViewCell {
    @IBOutlet weak var player_ID: UILabel!
    @IBOutlet weak var dota_Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
