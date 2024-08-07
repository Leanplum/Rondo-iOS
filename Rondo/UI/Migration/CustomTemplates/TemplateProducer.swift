//
//  TemplateProducer.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 7.08.24.
//  Copyright © 2024 Leanplum. All rights reserved.
//

import CleverTapSDK

@objc public class TemplateProducer: NSObject, CTTemplateProducer {
    
    static var templates: [String: CTCustomTemplate] {
        let templateAllFileTypesBuilder = CTInAppTemplateBuilder()
        templateAllFileTypesBuilder.setName("template-all file types")
        templateAllFileTypesBuilder.addArgument("bool", boolean: false)
        templateAllFileTypesBuilder.addArgument("string", string: "Default")
        templateAllFileTypesBuilder.addArgument("int", number: 1)
        templateAllFileTypesBuilder.addArgument("double", number: 3.122)
        templateAllFileTypesBuilder.addActionArgument("action")
        templateAllFileTypesBuilder.addArgument("map", dictionary: [
            "int": 0,
            "string": "Default"
        ])
        templateAllFileTypesBuilder.addFileArgument("file-pdf")
        templateAllFileTypesBuilder.addFileArgument("file-jpeg")
        templateAllFileTypesBuilder.addFileArgument("file-png")
        templateAllFileTypesBuilder.addFileArgument("file-mp3")
        templateAllFileTypesBuilder.addFileArgument("file-mp4")
        templateAllFileTypesBuilder.addFileArgument("file-html")
        templateAllFileTypesBuilder.addFileArgument("file-json")
        templateAllFileTypesBuilder.addFileArgument("file-txt")
        templateAllFileTypesBuilder.setPresenter(TemplatePresenter())
        let templateAllFileTypes = templateAllFileTypesBuilder.build()
        
        let templateCBuilder = CTInAppTemplateBuilder()
        templateCBuilder.setName("template-c")
        templateCBuilder.addArgument("bool", boolean: false)
        templateCBuilder.addArgument("string", string: "Default")
        templateCBuilder.addActionArgument("action")
        templateCBuilder.addArgument("map", dictionary: [
            "int": 0,
            "string": "Default"
        ])
        templateCBuilder.setPresenter(TemplatePresenter())
        let templateC = templateCBuilder.build()

        let functionLalitBuilder = CTAppFunctionBuilder(isVisual: true)
        functionLalitBuilder.setName("function-lalit")
        functionLalitBuilder.addArgument("height", string: "999")
        functionLalitBuilder.addArgument("a", boolean: true)
        functionLalitBuilder.addArgument("newvar3", number: 5.14)
        functionLalitBuilder.setPresenter(TemplatePresenter(isFunction: true))
        let functionLalit = functionLalitBuilder.build()
        
        let functionLina1Builder = CTAppFunctionBuilder(isVisual: false)
        functionLina1Builder.setName("function-lina1")
        functionLina1Builder.addArgument("Monday", string: "string")
        functionLina1Builder.addArgument("email", boolean: false)
        functionLina1Builder.addArgument("phone", boolean: true)
        functionLina1Builder.addFileArgument("Friday")
        functionLina1Builder.setPresenter(TemplatePresenter(isFunction: true))
        let functionLina1 = functionLina1Builder.build()
        
        let templateLinaBuilder = CTInAppTemplateBuilder()
        templateLinaBuilder.setName("template-lina")
        templateLinaBuilder.addArgument("var1", boolean: false)
        templateLinaBuilder.addArgument("var2", string: "Default")
        templateLinaBuilder.addArgument("folder1.var3", number: 0.0)
        templateLinaBuilder.addFileArgument("folder1.var4")
        templateLinaBuilder.addArgument("map", dictionary: [
            "int": 0,
            "string": "Default"
        ])
        templateLinaBuilder.setPresenter(TemplatePresenter())
        let templateLina = templateLinaBuilder.build()
        
        return [templateAllFileTypes.name: templateAllFileTypes,
                templateC.name: templateC,
                functionLalit.name: functionLalit,
                functionLina1.name: functionLina1,
                templateLina.name: templateLina]
    }
    
    public func defineTemplates(_ instanceConfig: CleverTapInstanceConfig) -> Set<CTCustomTemplate> {
        return Set(TemplateProducer.templates.values)
    }
}
