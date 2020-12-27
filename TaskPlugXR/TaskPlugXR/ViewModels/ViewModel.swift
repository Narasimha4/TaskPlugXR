//
//  ViewModel.swift
//  TaskPlugXR
//
//  Created by N, Narasimhulu on 25/12/20.
//  Copyright © 2020 Narasimha. All rights reserved.

import UIKit

class ViewModel: NSObject {
    
    // Create api service object
    lazy var apiService: APIService = {
        return APIService()
    }()
    
    // closure to bind view model to view controller
    var bindVMToVC: ((DataModel?, Error?) -> Void)?
        
    override init() {
        super.init()
        getDataFromAPI()
    }
    
    // MARK: - API call to get data
    func getDataFromAPI() {
        if DataBaseHelper.shareInstance.fetchFromDB().count == 0 {
            apiService.getSampleData(completion: { [weak self] (data, error)  in
                self?.bindVMToVC?(data, error)
            })
        }
    }
}


