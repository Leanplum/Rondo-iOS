//
//  AddAppViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 07/04/2020.
//  Copyright © 2023 Leanplum. All rights reserved.
//

import UIKit
import Eureka

class AddAppViewController: FormViewController {

    let context = UIApplication.shared.appDelegate.context
    var appsViewController: AppsViewController?

    private enum Tags: String {
        case name
        case accountId
        case accountToken
        case region
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add new App"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddAppViewController.done))

        TextRow.defaultCellUpdate = { cell, row in
            if row.section?.form === self.form {
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
        }

        buildInfo()
    }

    func buildInfo() {
        let section = Section("Info")

        var rules = RuleSet<String>()
        rules.add(rule: RuleRequired())

        section <<< TextRow() {
            $0.tag = Tags.name.rawValue
            $0.title = "App name"
            $0.add(ruleSet: rules)
            $0.validationOptions = .validatesOnChangeAfterBlurred
        }

        section <<< TextRow() {
            $0.tag = Tags.accountId.rawValue
            $0.title = "Account Id"
            $0.add(ruleSet: rules)
            $0.validationOptions = .validatesOnChangeAfterBlurred
        }

        section <<< TextRow() {
            $0.tag = Tags.accountToken.rawValue
            $0.title = "Account Token"
            $0.add(ruleSet: rules)
            $0.validationOptions = .validatesOnChangeAfterBlurred
        }

        section <<< TextRow() {
            $0.tag = Tags.region.rawValue
            $0.title = "Region"
            $0.add(ruleSet: rules)
            $0.validationOptions = .validatesOnChangeAfterBlurred
        }

        form +++ section
    }

    @objc func done() {
        let errors = form.validate()
        if errors.count == form.allSections.first?.allRows.count {
            self.dismiss(animated: true) {
                if let viewController = self.appsViewController {
                    viewController.apps = self.context.apps
                }
            }
        }
        if errors.count == 0 {
            let app = LeanplumApp(name: formValue(tag: .name),
                                  accountId: formValue(tag: .accountId),
                                  accountToken: formValue(tag: .accountToken),
                                  region: formValue(tag: .region))
            context.apps.append(app)
            self.dismiss(animated: true)
        }
    }

    private func formValue(tag: Tags) -> String {
        let row = form.rowBy(tag: tag.rawValue) as? TextRow
        return row?.value ?? ""
    }
}

extension AddAppViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        if let presentationController = navigationController?.presentationController {
            presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
        }
    }
}
