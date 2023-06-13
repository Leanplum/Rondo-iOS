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
                                accountId: "TEST-7Z8-W9R-876Z",
                                accountToken: "TEST-2c0-b1a",
                                region: "sk1-staging-25")
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
        let config = CleverTapInstanceConfig(accountId: app.accountId, accountToken: app.accountToken, accountRegion: app.region)
        let instance = CleverTap.instance(with: config)
        instance.notifyApplicationLaunched(withOptions: [:])
        LeanplumCT.instance = instance
        LeanplumCT.setLogLevel(logLevel)
        LeanplumCT.setUserAttributes(startAttr)
        return instance
    }
}
