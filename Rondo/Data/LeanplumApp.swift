//
//  LPApp.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2019 Leanplum. All rights reserved.
//

import Foundation

struct LeanplumApp: Equatable, Codable {

    enum Environment: String, CaseIterable, Codable {
        case production
        case development
    }

    let name: String
    let appId: String
    let productionKey: String
    let developmentKey: String

    var environment: Environment = .development
}

extension LeanplumApp: CustomStringConvertible {

    var description: String {
        return name
    }
}
