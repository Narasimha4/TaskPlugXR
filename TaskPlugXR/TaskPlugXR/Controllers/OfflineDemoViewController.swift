//
//  OfflineDemoViewController.swift
//  TaskPlugXR
//
//  Created by N, Narasimhulu on 25/12/20.
//  Copyright © 2020 Narasimha. All rights reserved.
//


import UIKit

class OfflineDemoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Lazy initialization for view model
    lazy var viewModel: ViewModel = {
        return ViewModel()
    }()
    
    // Progress indicator
    lazy var loadingIndicator: UIActivityIndicatorView = {
        var indicator: UIActivityIndicatorView!
        // check for iOS 13
        if  #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .large)
        } else { // Lower versions
            indicator = UIActivityIndicatorView(style: .gray)
        }
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        
        // Constraints programmatically
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        return indicator
    }()
    
    var dataModel: DataModel?
    var folders: [Folders]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callViewModelForUIUpdate()
    }
    
    //MARK: Method to call view model for update UI
    func callViewModelForUIUpdate() {
        loadingIndicator.startAnimating()
        
        if DataBaseHelper.shareInstance.fetchFromDB().count == 0 {
            viewModel.bindVMToVC = { (data, error) in
                if let error = error  {
                    self.loadingIndicator.stopAnimating()
                    print(error)
                    return
                }
                self.dataModel = data
                self.loadingIndicator.stopAnimating()
                // Reloading the tableview/list once data updated
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                if let dataObjects = self.dataModel?.data {
                    for (index, item) in dataObjects.enumerated() {
                        DataBaseHelper.shareInstance.saveDataInDB(obj: item, displayOrder: Int16(index))
                    }
                }
            }
        } else {
            folders = DataBaseHelper.shareInstance.fetchFromDB()
            self.loadingIndicator.stopAnimating()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Tableview delegtes and data source
extension OfflineDemoViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Return number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if folders?.count ?? 0 > 0 {
            return folders?.count ?? 0
        } else {
            if let count = dataModel?.data?.count {
                return count
            }
        }
        return 0
    }
    
    //MARK: Height of the row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    //MARK: Data Source of tableview / List
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // optional binding to load
        if let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableViewCell.self)", for: indexPath) as? TableViewCell {
            
            if folders?.count ?? 0 > 0 {
                cell.offlineDataConfigurable(data: (folders?[indexPath.row])!)
            } else {
                if let data = dataModel?.data?[indexPath.row] {
                    cell.onlineDataConfigurable(obj: data)
                    return cell
                }
            }
        }
        
        // return empty cell 
        return UITableViewCell()
    }
}





