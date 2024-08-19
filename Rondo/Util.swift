//
//  Util.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 19.07.22.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import Foundation

struct Util {
    static func getPrivateValue(subject: Any, label: String, _ isLazy: Bool = false, _ isOptional: Bool = false) -> Any? {
        let mirror = Mirror(reflecting: subject)
        let fullLabel = isLazy ? "$__lazy_storage_$_" + label : label
        let child = mirror.children.first { (_label: String?, value: Any) in
            _label == fullLabel
        }
        
        let value = child?.value
        
        if isOptional, let value = value {
            return Mirror(reflecting: value).children.first?.value
        }
        return value
    }
    
    static func jsonPrettyString<T>(_ model: T) -> String where T: Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try! encoder.encode(model)
        return String(data: data, encoding: .utf8)!
    }
    
    static func removeTextBetweenAngles(from input: String) -> String? {
        let pattern = "<[^>]*>"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: input.utf16.count)
            let modifiedString = regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: "")
            return modifiedString
        } catch {
            print("Invalid regex pattern")
            return nil
        }
    }
    
    static func getForegroundWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
        for scene in connectedScenes {
            if scene.activationState == .foregroundActive, let windowScene = scene as? UIWindowScene {
                let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene
                return window
            }
        }
        return nil
    }
}
