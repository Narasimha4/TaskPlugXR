//
//  DataModel.swift
//  TaskPlugXR
//
//  Created by N, Narasimhulu on 25/12/20.
//  Copyright © 2020 Narasimha. All rights reserved.


import Foundation
struct DataModel : Codable {
	let status : Bool?
	let updated_date : Int?
	let message : String?
	let data : [DataObj]?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case updated_date = "updated_date"
		case message = "message"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
		updated_date = try values.decodeIfPresent(Int.self, forKey: .updated_date)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		data = try values.decodeIfPresent([DataObj].self, forKey: .data)
	}

}
