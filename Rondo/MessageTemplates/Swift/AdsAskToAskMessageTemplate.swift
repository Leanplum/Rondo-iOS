//
//  AdsAskToAskMessageTemplate.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 18.09.20.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import Foundation
import Leanplum
import AppTrackingTransparency
import AdSupport

class AdsAskToAskMessageTemplate: LPMessageTemplateProtocol {
    var context: ActionContext
    
    init(context:ActionContext) {
        self.context = context
    }
    
    static func defineAction() {
        let name = "Ads Pre-Permission Swift"
        let defaultMessage = """
        If you would like to get ads tailored to your preferences,
        you can enable this app to provide personalized ads on this app
        and on partner apps.\nTap OK to enable personalized ads.
        """
        
        let bundleDisplayName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String
        let appName = bundleDisplayName ?? Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        
        let defaultButtonTextColor = UIColor.init(red: 0, green: 0.478431, blue: 1, alpha: 1)
        let LIGHT_GRAY = CGFloat(246.0/255.0)
        
        let width = NSNumber(300)
        let height = NSNumber(250)
        
        Leanplum.defineAction(name: name, kind: .message,
                              args: [
                                ActionArg(name: LPMT_ARG_TITLE_TEXT, string: appName),
                                ActionArg(name: LPMT_ARG_TITLE_COLOR, color: UIColor.black),
                                ActionArg(name: LPMT_ARG_MESSAGE_TEXT, string: defaultMessage),
                                ActionArg(name: LPMT_ARG_MESSAGE_COLOR, color: UIColor.black),
                                ActionArg(name: LPMT_ARG_BACKGROUND_IMAGE, file: nil),
                                ActionArg(name: LPMT_ARG_BACKGROUND_COLOR, color: UIColor.init(white: LIGHT_GRAY, alpha: 1.0)),
                                ActionArg(name: LPMT_ARG_ACCEPT_BUTTON_TEXT, string: LPMT_DEFAULT_OK_BUTTON_TEXT),
                                ActionArg(name: LPMT_ARG_ACCEPT_BUTTON_BACKGROUND_COLOR, color: UIColor.init(white: LIGHT_GRAY, alpha: 1.0)),
                                ActionArg(name: LPMT_ARG_ACCEPT_BUTTON_TEXT_COLOR, color: defaultButtonTextColor),
                                ActionArg(name: LPMT_ARG_CANCEL_ACTION, action: nil),
                                ActionArg(name: LPMT_ARG_CANCEL_BUTTON_BACKGROUND_COLOR, color: UIColor.init(white: LIGHT_GRAY, alpha: 1.0)),
                                ActionArg(name:LPMT_ARG_CANCEL_BUTTON_TEXT, string:LPMT_DEFAULT_LATER_BUTTON_TEXT),
                                ActionArg(name:LPMT_ARG_CANCEL_BUTTON_TEXT_COLOR, color:UIColor.gray),
                                ActionArg(name:LPMT_ARG_LAYOUT_WIDTH, number:width),
                                ActionArg(name:LPMT_ARG_LAYOUT_HEIGHT, number:height)
                              ], completion: { context in
                                if (context.hasMissingFiles()) {
                                    return false;
                                }
                                
                                let template = AdsAskToAskMessageTemplate(context: context)
                                template.context = context
                                if #available(iOS 14, *),
                                   ATTrackingManager.trackingAuthorizationStatus == ATTrackingManager.AuthorizationStatus.notDetermined {
                                    template.showPrePermissionMessage()
                                    return true
                                }
                                return false
                              })
    }
    
    func viewControllerWithContext(context:ActionContext) -> LPPopupViewController? {
        guard let viewController = LPPopupViewController.instantiateFromStoryboard() else {
            return nil
        }
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.context = context;
        viewController.shouldShowCancelButton = true;
        let strongSelf = self;
        viewController.acceptCompletionBlock = {
            let weakSelf = strongSelf
            weakSelf.showNativeAdsPrompt()
        }
        
        return viewController;
    }
    
    func showNativeAdsPrompt() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch (status) {
                case ATTrackingManager.AuthorizationStatus.authorized:
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    NSLog("Authorized. Advertising ID is: %@. Use setDeviceId to set idfa now.", idfa);
                    Leanplum.setDeviceId(idfa)
                    break;
                case ATTrackingManager.AuthorizationStatus.notDetermined:
                    NSLog("NotDetermined");
                    break;
                    
                case ATTrackingManager.AuthorizationStatus.restricted:
                    NSLog("Restricted");
                    break;
                    
                case ATTrackingManager.AuthorizationStatus.denied:
                    NSLog("Denied");
                    break;
                    
                default:
                    NSLog("Unknown");
                    break;
                }
            })
        }
    }
    
    func showPrePermissionMessage() {
        guard let viewController = self.viewControllerWithContext(context: self.context) else { return }
        LPMessageTemplateUtilities.presentOverVisible(viewController)
    }
}