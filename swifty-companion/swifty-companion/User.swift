//
//  User.swift
//  swifty-companion
//
//  Created by Aymeric TOULOUSE on 1/23/18.
//  Copyright © 2018 Aymeric TOULOUSE. All rights reserved.
//

import Foundation

struct User {
    let login : String
    let email : String
    let mobile : Int
    let niveau : Double
    let emplacement : String
    let wallet : Int
    let correction : Int

    var description: String {
        return "\(login) \(email) \(String(mobile)) \(String(niveau)) \(String(emplacement)) \(String(wallet)) \(String(correction))"
    }
}
