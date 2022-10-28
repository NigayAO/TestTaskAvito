//
//  Employee.swift
//  TestTaskAvito
//
//  Created by Alik Nigay on 26.10.2022.
//

import Foundation

struct Avito: Decodable {
    let company: Company
}

struct Company: Decodable {
    let name: String
    let employees: [Employee]
}

struct Employee: Decodable {
    let name, phoneNumber: String
    let skills: [String]
}
