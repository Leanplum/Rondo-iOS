//
//  HomeViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2023 Leanplum. All rights reserved.
//

import UIKit
import Eureka
import AppTrackingTransparency
import AdSupport
import CleverTapSDK

class HomeViewController: FormViewController {
    let context = UIApplication.shared.appDelegate.context
    let instance =  UIApplication.shared.appDelegate.cleverTapInstance

    var app: LeanplumApp? {
        didSet {
            if app != oldValue {
                build()
            }
        }
    }
    
    var logLevel: CleverTapLogLevel = UserDefaults.standard.logLevel {
        didSet {
            if logLevel != oldValue {
                context.logLevel = logLevel
                form.rowBy(tag: "logLevel")?.reload()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        app = context.app
        logLevel = context.logLevel
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        app = context.app
    }

    func build() {
        form.removeAll()

        buildApps()
        buildAppInfo()
        buildUserInfo()
    }

    func buildApps() {
        let section = Section("App")

        section <<< ButtonRow() {
            $0.title = "App"
            $0.tag = "app"
            $0.cellStyle = .value1
            $0.value = app?.name
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                return AppsViewController(style: .insetGrouped)
            }), onDismiss: nil)
            $0.displayValueFor = {
                return $0
            }
        }
        
        section <<< ActionSheetRow<CleverTapLogLevel> {
            $0.title = "Log level"
            $0.tag = "logLevel"
            $0.value = self.logLevel
            $0.options = [.off, .debug, .info]
            $0.selectorTitle = "Set log level"
        }.onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }.onChange { row in
            self.logLevel = row.value ?? .debug
        }.cellUpdate { (cell, row) in
            cell.accessoryType = .disclosureIndicator
        }

        form +++ section
    }

    func buildAppInfo() {
        let section = Section("Info")
        section.tag = "info"

        section <<< LabelRow {
            $0.title = "App name"
            $0.value = app?.name
        }
        section <<< LabelRow {
            $0.title = "App Id"
            $0.value = app?.accountId
        }
        section <<< LabelRow {
            $0.title = "Token"
            $0.value = app?.accountToken
        }
        section <<< LabelRow {
            $0.title = "Region"
            $0.value = app?.region
        }

        form +++ section
    }

    func buildUserInfo() {
        let section = Section("User info")

        section <<< LabelRow {
            $0.title = "User id"
            $0.value = instance?.profileGet("Identity") as? String
        }
        section <<< LabelRow {
            $0.title = "Device id"
            $0.value = instance?.profileGetID()
        }

        let index = form.firstIndex { $0.tag == "info" } ?? 1
        form.insert(section, at: index + 1)
    }
}
