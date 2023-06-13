//
//  MigrationViewController.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 7.10.22.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import Foundation
import Eureka
import CleverTapSDK

class MigrationViewController: FormViewController {
    
    var var_string: CleverTapSDK.Var?
    var var_int: CleverTapSDK.Var?
    var var_number: CleverTapSDK.Var?
    var var_bool: CleverTapSDK.Var?
    var var_dict: CleverTapSDK.Var?
    var var_dot: CleverTapSDK.Var?
    var var_dot_dict: CleverTapSDK.Var?
    
    let instance = UIApplication.shared.appDelegate.cleverTapInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        build()
    }
    
    func build() {
        buildStatus()
        // CleverTap Variables
        if let instance = instance {
            buildVariables(instance)
            Log.print("CleverTap Instance is nil.")
        }
        buildAttributes()
        buildAdvance()
        buildTrack()
        buildTrackPurchase()
        buildTrafficSource()
    }
    
    var singleParam: [String: Any] {
        ["param1": "value1"]
    }
    
    var trackParams: [AnyHashable: Any] {
        let `nil`:String? = nil
        return [
            "int_param_\(Int.max)": Int.max,
            "long_param_\(Int64.max)": Int64.max,
            "float_param_\(Float.greatestFiniteMagnitude)": Float.greatestFiniteMagnitude,
            "double_param_\(Double.greatestFiniteMagnitude)": Double.greatestFiniteMagnitude,
            "string_param_str": "str",
            "bool_param_true": true,
            "date_param_now": Date(),
            "nil": `nil` as Any
        ]
    }
    
    var attributeParams: [AnyHashable: Any] {
        return [
            "list_param_a_1_b_2": ["a", 1, "b", 2],
            "list_param_empty": []
        ].merging(trackParams) { (current, _) in current }
    }
    
    func buildStatus() {
        let section = Section("Migration Manager")
        
        section <<< LabelRow {
            $0.title = "Account Id"
            $0.value = UIApplication.shared.appDelegate.context.app?.accountId
        }
        section <<< LabelRow {
            $0.title = "Account Token"
            $0.value = UIApplication.shared.appDelegate.context.app?.accountToken
        }
        section <<< LabelRow {
            $0.title = "Account Region"
            $0.value = UIApplication.shared.appDelegate.context.app?.region
        }

        let identityKeys = instance?.config.identityKeys as? [String] ?? []
        section <<< LabelRow {
            $0.title = "Identity Keys"
            $0.value = identityKeys.joined(separator: ", ")
        }
        
        form +++ section
    }
    
    func buildAttributes() {
        let section = Section("User Attributes")
        
        section <<< ButtonRow(){
            $0.title = "setUserAttributes(one-attribute)"
        }.onCellSelection({ cell, row in
            LeanplumCT.setUserAttributes(self.singleParam)
        })
        
        section <<< ButtonRow(){
            $0.title = "setUserAttributes(all-type-attributes)"
        }.onCellSelection({ [self] cell, row in
            LeanplumCT.setUserAttributes(attributeParams)
        })
        
        section <<< ButtonRow(){
            $0.title = "setUserAttributes(mixed-attributes)"
        }.onCellSelection({ cell, row in
            LeanplumCT.setUserAttributes(["name1": "ct value",
                                        "number": 4,
                                        "arr": ["c", 3, "d", 4, nil], // optionals
                                        "empty": nil])
        })
        
        section <<< ButtonRow(){
            $0.title = "Set DOB"
        }.onCellSelection({ cell, row in
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if let date = dateFormatter.date(from: "10-01-1999") {
                LeanplumCT.setUserAttributes(["DOB": date])
            }
        })
        
        form +++ section
    }
    
    func buildAdvance() {
        let section = Section("Advance")
        
        section <<< ButtonRow(){
            $0.title = "advance(null)"
        }.onCellSelection({ cell, row in
            LeanplumCT.advance(state: nil) // will be skipped in CT
        })
        
        section <<< ButtonRow(){
            $0.title = "advance(event)"
        }.onCellSelection({ cell, row in
            LeanplumCT.advance(state: row.title)
        })
        
        section <<< ButtonRow(){
            $0.title = "advance(event info)"
        }.onCellSelection({ cell, row in
            LeanplumCT.advance(state: row.title, info: "info")
        })
        
        section <<< ButtonRow(){
            $0.title = "advance(event info one-param)"
        }.onCellSelection({ [self] cell, row in
            LeanplumCT.advance(state: row.title, info: "info", params: singleParam)
        })
        
        section <<< ButtonRow(){
            $0.title = "advance(event info all-type-params)"
        }.onCellSelection({ [self] cell, row in
            LeanplumCT.advance(state: row.title, info: "info", params: trackParams as? [String: Any])
        })
        
        form +++ section
    }
    
    func buildTrack() {
        let section = Section("Track")
        
        section <<< ButtonRow(){
            $0.title = "track(event)"
        }.onCellSelection({ cell, row in
            LeanplumCT.track(row.title!)
        })
        
        section <<< ButtonRow(){
            $0.title = "track(event info)"
        }.onCellSelection({ cell, row in
            LeanplumCT.track(row.title!, info: "info")
        })
        
        section <<< ButtonRow(){
            $0.title = "track(event value info one-param)"
        }.onCellSelection({ [self] cell, row in
            LeanplumCT.track(row.title!, value: 5.0, info: "info", params: singleParam)
        })
        
        section <<< ButtonRow(){
            $0.title = "track(event all-type-params)"
        }.onCellSelection({ [self] cell, row in
            LeanplumCT.track(row.title!, params: trackParams as? [String: Any])
        })
        
        form +++ section
    }
    
    func buildTrackPurchase() {
        let section = Section("Track Purchase")
        
        section <<< ButtonRow(){
            $0.title = "trackPurchase(event 0 null null)"
        }.onCellSelection({ cell, row in
            LeanplumCT.track(event: row.title!, value: 0.0, currencyCode: nil, params: nil)
        })
        
        section <<< ButtonRow(){
            $0.title = "trackPurchase(event value currency one-param)"
        }.onCellSelection({ [self] cell, row in
            LeanplumCT.track(event: row.title!, value: 2.5, currencyCode: "BGN", params: singleParam)
        })
        
        section <<< ButtonRow(){
            $0.title = "trackPurchase(event value currency all-type-params)"
        }.onCellSelection({ [self] cell, row in
            LeanplumCT.track(event: row.title!, value: 2.5, currencyCode: "BGN", params: trackParams as? [String: Any])
        })
        
        form +++ section
    }
    
    func buildTrafficSource() {
        let section = Section("Set Traffic Source info")
        
        section <<< ButtonRow(){
            $0.title = "setTrafficSource"
        }.onCellSelection({ cell, row in
            LeanplumCT.setTrafficSource(info: [
                "publisherId": "pub-id",
                "publisherName": "pub-name",
                "publisherSubPublisher": "sub-publisher",
                "publisherSubSite": "sub-site",
                "publisherSubCampaign": "sub-campaign",
                "publisherSubAdGroup": "sub-ad-group",
                "publisherSubAd": "sub-ad"
            ])
        })
        
        form +++ section
    }
}
