//
//  MessagesViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 18/03/2020.
//  Copyright © 2023 Leanplum. All rights reserved.
//

import UIKit
import Eureka
import CleverTapSDK

class MessagesViewController: FormViewController {
    enum MessageSegments: String, CaseIterable, CustomStringConvertible {
        case iam = "IAM"
        case push = "Push"
        
        var description: String {
            return rawValue
        }
        
        static var items: [String] {
            return MessageSegments.allCases.map({$0.rawValue})
        }
    }
    
    private let segmentedControl = UISegmentedControl(items: MessageSegments.items)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSegmentedControl()
        buildIAM()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LabelRow.defaultCellSetup = { cell, row in
            cell.selectionStyle = .default
            row.onCellSelection { (cell, row) in
                row.deselect(animated: true)
                if row.tag == "systemPush" {
                    self.requestSystemPushPermission()
                } else if row.tag == "provisionalPush" {
                    self.requestProvisionalPushPermission()
                } else {
                    LeanplumCT.track(row.tag!)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LabelRow.defaultCellSetup = nil
    }
    
    func addSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(MessagesViewController.didChangeSegment), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.sizeToFit()
        
        navigationItem.titleView = segmentedControl
    }
    
    @objc func didChangeSegment() {
        title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)

        guard let title = title, let segment = MessageSegments(rawValue: title) else {
            return
        }
        
        switch segment {
        case .iam:
            buildIAM()
        case .push:
            buildPush()
        }
    }
    
    func requestSystemPushPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
                Log.print("Error: \(error)")
            }
            
            // Enable or disable features based on the authorization.
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func requestProvisionalPushPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.provisional]) { granted, error in
            
            if let error = error {
                // Handle the error here.
                Log.print("Error: \(error)")
            }
            
            // Enable or disable features based on the authorization.
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}
