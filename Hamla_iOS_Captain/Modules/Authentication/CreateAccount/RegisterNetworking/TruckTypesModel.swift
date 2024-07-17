//
//  TruckTypesModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 24/06/2024.
//

import Foundation

// MARK: - Response
struct TruckTypesModel: Codable {
    let status: Int
    let message: String
    let data: [TruckX]?
}

struct TruckX: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let icon: String?
}
