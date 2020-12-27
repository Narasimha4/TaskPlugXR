//
//  DataBaseHelper.swift
//  TaskPlugXR
//
//  Created by N, Narasimhulu on 25/12/20.
//  Copyright © 2020 Narasimha. All rights reserved.
//

import UIKit
import CoreData

class DataBaseHelper {
    
    static let shareInstance = DataBaseHelper()
    let context =  AppDelegate.shared.persistentContainer.viewContext
    
    func saveDataInDB(obj: DataObj?, displayOrder: Int16) {
        let imageInstance = Folders(context: context)
        
        if let string = obj?.folder_icon {
            let urlString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let url = URL(string: urlString!) {
                getData(from: url) { data, response, error in
                    guard let data = data, error == nil else { return  }
                    if let imageData =  UIImage(data: data)?.pngData() {
                        imageInstance.folderIcon = imageData
                    }
                }
            }
        }
        imageInstance.folderName = obj?.folder_name
        imageInstance.displayOrder = displayOrder
        imageInstance.folderDescription = obj?.description
        imageInstance.updatedDate = Int32(obj!.updated_date!)
        
        do {
            try self.context.save()
            print("data is saved")
        } catch {
            print("ERROR", error.localizedDescription)
        }
    }
    
    
    func fetchFromDB() -> [Folders] {
        var fetchingImage = [Folders]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folders")
        let sortDescriptor = NSSortDescriptor(key: "displayOrder", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            fetchingImage = try context.fetch(fetchRequest) as! [Folders]
        } catch {
            print("Error while fetching the data")
        }
        return fetchingImage
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

