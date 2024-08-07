//
//  TemplatePresenter.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 7.08.24.
//  Copyright © 2024 Leanplum. All rights reserved.
//

import Foundation
import CleverTapSDK
import SwiftUI

class TemplatePresenter: CTTemplatePresenter {
    
    var window: UIWindow? = nil
    var controller: UIViewController? = nil
    
    var isFunction = false
    
    init(isFunction: Bool = false) {
        self.isFunction = isFunction
    }
    
    var foregroundWindow: UIWindow? {
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
    
    public func onPresent(context: CTTemplateContext) {
        if let window = foregroundWindow {
            let triggerAction = self.isFunction ? nil : { action in
                context.triggerAction(name: action)
            }
            let openFileAction = { argName in
                return context.file(name: argName)
            }
            let messageView = CustomTemplateView(isPresented: .constant(true), title: "Custom In-app: \(context.name())", message: buildInAppDescription(context: context), confirmAction: {
                context.presented()
            }, cancelAction: {
                self.close(context: context)
            }, triggerAction: triggerAction,
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
        }
    }
    
    public func onCloseClicked(context: CTTemplateContext) {
        self.close(context: context)
    }
    
    public func close(context: CTTemplateContext) {
        self.window?.removeFromSuperview()
        self.window = nil
        self.controller = nil
        context.dismissed()
    }
    
    func buildInAppDescription(context: CTTemplateContext) -> String {
        let template = TemplateProducer.templates[context.name()]
        
        let beautify: (String) -> (String) = { input in
            return Util.removeTextBetweenAngles(from: input)?
                .trimmingCharacters(in: [" "]) ?? "Error"
        }
        
        return """
        Context: \(context.name()): {\n\(beautify(context.debugDescription))\n}\n\n\
        Template: {\n\(template != nil ? beautify(template!.debugDescription) : "Template Not Found")\n}
        """
    }
}
