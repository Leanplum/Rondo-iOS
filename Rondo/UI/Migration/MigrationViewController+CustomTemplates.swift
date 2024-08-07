//
//  MigrationViewController+CustomTemplates.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 7.08.24.
//  Copyright © 2024 Leanplum. All rights reserved.
//

import Foundation
import Eureka
import CleverTapSDK

extension MigrationViewController {
    func buildCustomTemplates(_ instance: CleverTap) {
        
        let section = Section("Custom Templates")
        
        section <<< ButtonRow() {
            $0.title = "Custom Templates"
            $0.tag = "custom-templates"
            $0.cellStyle = .value1
            $0.value = "View"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                return CustomTemplatesViewController(instance)
            }), onDismiss: nil)
            $0.displayValueFor = {
                return $0
            }
        }
        
        form +++ section
    }
}
