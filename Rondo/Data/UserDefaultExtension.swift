//
//  UserDefaultExtension.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 07/04/2020.
//  Copyright © 2023 Leanplum. All rights reserved.
//

import UIKit
import CleverTapSDK

extension UserDefaults {

    enum DefaultKey: String, CaseIterable {
        case apps
        case app
        case envs
        case env
        case useUNUserNotificationCenterDelegate
        case logLevel
        case useApiConfig
    }

    static func observerNotificationNameFor(key: DefaultKey) -> Notification.Name {
        return Notification.Name(rawValue: key.rawValue + "DidChange")
    }

    private subscript(key: DefaultKey) -> Any? {
        get { return object(forKey: key.rawValue) }
        set { set(newValue, forKey: key.rawValue) }
    }

    fileprivate func postObserverNotificationFor(key: DefaultKey) {
        NotificationCenter.default.post(name: UserDefaults.observerNotificationNameFor(key: key), object: self)
    }

    func clear() {
        DefaultKey.allCases.forEach { self[$0] = nil }
    }

    var apps: [LeanplumApp] {
        get {
            if let data = self[.apps] as? Data {
                return (try? JSONDecoder().decode([LeanplumApp].self, from: data)) ?? []
            }
            return []
        }
        set {
            let oldValue = apps
            self[.apps] = try? JSONEncoder().encode(newValue)
            if newValue != oldValue {
                postObserverNotificationFor(key: .apps)
            }
        }
    }

    var app: LeanplumApp? {
        get {
            if let data = self[.app] as? Data {
                return try? JSONDecoder().decode(LeanplumApp.self, from: data)
            }
            return nil
        }
        set {
            let oldValue = app
            self[.app] = try? JSONEncoder().encode(newValue)
            if newValue != oldValue {
                postObserverNotificationFor(key: .app)
            }
        }
    }
    
    var logLevel: CleverTapLogLevel {
        get {
            if let value = self[.logLevel] as? UInt,
               let level = CleverTapLogLevel.init(rawValue: Int32(value)) {
                return level
            }
            return .debug
        }
        set {
            let oldValue = logLevel
            self[.logLevel] = newValue.rawValue
            if newValue != oldValue {
                postObserverNotificationFor(key: .logLevel)
            }
        }
    }
    
    var useApiConfig: Bool {
        get {
            if let config = self[.useApiConfig] as? Bool {
                return config
            }
            return false
        }
        set {
            let oldValue = useApiConfig
            self[.useApiConfig] = newValue
            if newValue != oldValue {
                postObserverNotificationFor(key: .useApiConfig)
            }
        }
    }
}
