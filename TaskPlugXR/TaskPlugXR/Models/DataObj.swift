//
//  DataObj.swift
//  TaskPlugXR
//
//  Created by N, Narasimhulu on 25/12/20.
//  Copyright © 2020 Narasimha. All rights reserved.

import Foundation
struct DataObj : Codable {
	let updated_date : Int?
	let assets_update : Int?
	let description : String?
	let folder_name : String?
	let is_activated : Bool?
	let dat_file : String?
	let folder_id : Int?
	let xml_file : String?
	let folder_icon : String?

	enum CodingKeys: String, CodingKey {

		case updated_date = "updated_date"
		case assets_update = "assets_update"
		case description = "description"
		case folder_name = "folder_name"
		case is_activated = "is_activated"
		case dat_file = "dat_file"
		case folder_id = "folder_id"
		case xml_file = "xml_file"
		case folder_icon = "folder_icon"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		updated_date = try values.decodeIfPresent(Int.self, forKey: .updated_date)
		assets_update = try values.decodeIfPresent(Int.self, forKey: .assets_update)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		folder_name = try values.decodeIfPresent(String.self, forKey: .folder_name)
		is_activated = try values.decodeIfPresent(Bool.self, forKey: .is_activated)
		dat_file = try values.decodeIfPresent(String.self, forKey: .dat_file)
		folder_id = try values.decodeIfPresent(Int.self, forKey: .folder_id)
		xml_file = try values.decodeIfPresent(String.self, forKey: .xml_file)
		folder_icon = try values.decodeIfPresent(String.self, forKey: .folder_icon)
	}

}
