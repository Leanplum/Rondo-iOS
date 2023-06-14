//
//  AppContext.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2023 Leanplum. All rights reserved.
//

import Foundation
import CleverTapSDK

class AppContext {

    var apps: [LeanplumApp] = UserDefaults.standard.apps {
        didSet {
            if apps != oldValue {
                UserDefaults.standard.apps = apps
            }
        }
    }

    var app: LeanplumApp? = UserDefaults.standard.app {
        didSet {
            if app != oldValue {
                UserDefaults.standard.app = app
            }
        }
    }
    
    var logLevel: CleverTapLogLevel = UserDefaults.standard.logLevel {
        didSet {
            if logLevel != oldValue {
                UserDefaults.standard.logLevel = logLevel
                LeanplumCT.setLogLevel(logLevel)
            }
        }
    }
    
    var useApiConfig: Bool = UserDefaults.standard.useApiConfig {
        didSet {
            if useApiConfig != oldValue {
                UserDefaults.standard.useApiConfig = useApiConfig
            }
        }
    }

    init() {
        // defer to force didSet
        defer {
            if apps.isEmpty {
                apps = [
                    LeanplumApp(name: "TEST-Zagorchev",
                                accountId: "-",
                                accountToken: "-",
                                region: "-")
                ]
            }

            if app == nil {
                app = apps.first
            }
        }
    }

    func start(with app: LeanplumApp?) -> CleverTap? {
        guard let app = app else {
            return nil
        }

        self.app = app
        let startAttr = ["startAttributeInt": 1,
                         "startAttributeString": "stringValueFromStart"] as [String : Any]
        CleverTap.setCredentialsWithAccountID(app.accountId, token: app.accountToken, region: app.region)
        // Use autoIntegrate
        let instance = CleverTap.autoIntegrate() // Will set the defaultInstace
        guard let instance = instance else { return nil }
        LeanplumCT.instance = instance
        LeanplumCT.setLogLevel(logLevel)
        LeanplumCT.setUserAttributes(startAttr)
        return instance
    }
}
