//
//  LeanplumCustomTemplates.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 14.08.24.
//  Copyright © 2024 Leanplum. All rights reserved.
//

import Leanplum
import SwiftUI

class LeanplumCustomTemplates {
    
    var window: UIWindow? = nil
    var controller: UIViewController? = nil
    
    var foregroundWindow: UIWindow? {
        Util.getForegroundWindow()
    }
    
    func defineActions() {
        Leanplum.defineAction(name: "function-lina1", kind: .action, args: [
            ActionArg(name: "Monday", string: "string"),
            ActionArg(name: "email", boolean: false),
            ActionArg(name: "phone", boolean: true),
            ActionArg(name: "Friday", file: nil)
        ], present: present(context:), dismiss: dismiss(context:))
        
        Leanplum.defineAction(name: "template-lina", kind: .message, args: [
            ActionArg(name: "var1", boolean: false),
            ActionArg(name: "var2", string: "Default"),
            ActionArg(name: "folder1.var3", number: 0.0),
            ActionArg(name: "folder1.var4", file: nil),
            ActionArg(name: "map", dictionary: [
                "int": 0,
                "string": "Default"
            ]),
            ActionArg(name: "Open action", action: "")
        ], present: present(context:), dismiss: dismiss(context:))
    }
    
    func present(context: ActionContext) -> Bool {
        if let window = foregroundWindow {
            let triggerAction = { action in
                context.runTrackedAction(name: action)
            }
            let openFileAction = { argName in
                return context.file(name: argName)
            }
            let message = context.args != nil ? argsString(context.args!) : "No args"
            let messageView = CustomTemplateView(isPresented: .constant(true),
                                                 title: "Leanplum Custom In-app: \(context.name)",
                                                 message: message,
                                                 confirmAction: nil,
                                                 cancelAction: {
                self.close(context: context)
            },
                                                 triggerAction: triggerAction,
                                                 openFileAction: openFileAction)
            
            let hostingController = UIHostingController(rootView: messageView)
            hostingController.view.backgroundColor = .clear
            
            window.alpha = 1;
            window.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            window.windowLevel = .alert
            window.rootViewController = hostingController
            window.isHidden = false
            
            self.controller = hostingController
            self.window = window
            
            return true
        }
        return false
    }
                              
    func dismiss(context: ActionContext) -> Bool {
        self.close(context: context)
        return true
    }
    
    public func close(context: ActionContext) {
        self.window?.removeFromSuperview()
        self.window = nil
        self.controller = nil
        context.actionDismissed()
    }
    
    func argsString(_ args: Dictionary<AnyHashable, Any>) -> String {
        let message = args.map {
            if let nested = $0.value as? Dictionary<AnyHashable, Any> {
                "\($0.key): [\(argsString(nested))]"
            } else {
                "\($0.key): \($0.value)"
            }
        }
        return message.joined(separator: ",\n")
    }
}
