//
//  CaptainOnOrderModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 02/06/2024.
//

import Foundation

struct CaptainOnOrderModel: Codable {
    let status: Int
    let message: String
    let data: Order?
}
