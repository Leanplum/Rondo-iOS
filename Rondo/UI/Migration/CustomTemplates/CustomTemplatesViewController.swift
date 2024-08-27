//
//  CustomTemplatesViewController.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 7.08.24.
//  Copyright © 2024 Leanplum. All rights reserved.
//

import Eureka
import CleverTapSDK

class CustomTemplatesViewController: FormViewController {
    private var instance: CleverTap
    
    init(_ instance: CleverTap) {
        self.instance = instance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildCustomTemplatesSyncSection()
        buildCustomTemplatesSection()
    }
    
    func buildCustomTemplatesSyncSection() {
        let section = Section("Sync Custom Templates")
        
        section <<< ButtonRow {
            $0.title = "Sync templates"
        }.onCellSelection { (cell, row) in
            self.instance.syncCustomTemplates(true)
        }
        
        form +++ section
    }
    
    func buildCustomTemplatesSection() {
        let section = Section("Custom Templates")
        
        section <<< TextAreaRow {
            $0.value = Array(TemplateProducer.templates.keys).joined(separator: ", ")
            $0.baseCell.isUserInteractionEnabled = false
        }
        
        form +++ section
        
        TemplateProducer.templates.forEach { (name: String, template: CTCustomTemplate) in
            let desc = Util.removeTextBetweenAngles(from: template.debugDescription)?
                .trimmingCharacters(in: [" "]) ?? template.debugDescription
            
            let section = Section(name)
            section <<< TextAreaRow {
                $0.value = desc
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 96)
                $0.baseCell.isUserInteractionEnabled = false
            }
            form +++ section
        }
    }
}
