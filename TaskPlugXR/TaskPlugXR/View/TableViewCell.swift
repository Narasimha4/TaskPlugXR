//
//  TableViewCell.swift
//  TaskPlugXR
//
//  Created by N, Narasimhulu on 25/12/20.
//  Copyright © 2020 Narasimha. All rights reserved.

import UIKit
import CoreData

class TableViewCell: UITableViewCell {

    @IBOutlet weak var folderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
    }
    
    // MARK: - Configure the data in the cell
    func onlineDataConfigurable(obj: DataObj?) {
        
        if let string = obj?.folder_icon {
            let urlString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let url = URL(string: urlString!) {
                getData(from: url) { data, response, error in
                    guard let data = data, error == nil else { return  }
                    DispatchQueue.main.async() {
                        self.folderImageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
        nameLabel.text = obj?.folder_name
        descLabel.text = obj?.description
        updatedDateLabel.text = "Date: \(DateHelper.getTimeFromUnixTimeStamp(timeStamp: Int32((obj?.updated_date)!)))"
    }
    
    func offlineDataConfigurable(data: Folders?) {
        DispatchQueue.main.async() {
            if let data = data?.folderIcon {
                self.folderImageView.image = UIImage(data: data)
            }
        }
        
        nameLabel.text = data?.folderName
        descLabel.text = data?.folderDescription
        updatedDateLabel.text = "Date: \(DateHelper.getTimeFromUnixTimeStamp(timeStamp: data!.updatedDate))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}


