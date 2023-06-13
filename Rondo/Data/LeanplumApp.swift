//
//  LPApp.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2023 Leanplum. All rights reserved.
//

import Foundation
import CleverTapSDK

struct LeanplumApp: Equatable, Codable {
    let name: String
    let accountId: String
    let accountToken: String
    let region: String
}

extension LeanplumApp: CustomStringConvertible {

    var description: String {
        return name
    }
}

extension CleverTapLogLevel: CustomStringConvertible {
    public var description : String {
        switch self {
        case .off: return "Off"
        case .debug: return "Debug"
        case .info: return "Info"
        @unknown default:
            return "Unknown"
        }
    }
}
