//
//  CheckCodeModel.swift
//  Hamla
//
//  Created by Bassant on 05/04/2024.
//

import Foundation

struct CheckCodeModel: Codable {
    let status: Int
    let message: String
    let is_new: Bool?
    let data: CaptainData?
}
