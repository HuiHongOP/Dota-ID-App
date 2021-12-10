//
//  SubImageView.swift
//  DotaCheck
//
//  Created by Hui Hong Zheng on 11/28/21.
//

import UIKit

/*
 a subclass UItableViewCell that would be used for tableview on the SecondViewController
 
 */
// MARK: - Subclass UITableView Cell
class SubImageView: UITableViewCell {
    @IBOutlet var dota_avator: UIImageView!
    static let identifier = "ImageTableCell"
    
    //helps to configure the passed URL string into a image to display for UIImageView
    public func configure(urlString: String){
        guard let url = URL(string: urlString)else{
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url){ [weak self] (data,_, _) in
            if let data = data{
                DispatchQueue.main.async {
                    self?.dota_avator.image = UIImage(data: data)
                }
            }
        }
        dataTask.resume()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
