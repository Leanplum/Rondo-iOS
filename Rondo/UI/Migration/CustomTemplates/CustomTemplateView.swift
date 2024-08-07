//
//  CustomTemplateView.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 7.08.24.
//  Copyright © 2024 Leanplum. All rights reserved.
//

import SwiftUI

extension View {
    func roundedBorder() -> some View {
        return self.overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary, lineWidth: 1)
        ).textFieldStyle(.roundedBorder)
    }
    
    func buttonStyle() -> some View {
        return self.padding()
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct CustomTemplateView: View {
    @Binding var isPresented: Bool
    
    @State var actionName: String = "action"
    @State var fileArg: String = "file"
    @State private var showFile = false
    @State private var fileURL: URL?
    
    var title: String
    var message: String
    var confirmAction: () -> Void
    var cancelAction: () -> Void
    var triggerAction: ((String) -> Void)?
    var openFileAction: ((String) -> String?)?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
            
            ScrollView {
                VStack {
                    Text(message)
                        .font(.body)
                }.frame(maxHeight: .infinity)
            }
            
            if let triggerAction = self.triggerAction {
                TextField(
                    "Action name",
                    text: $actionName
                )
                .roundedBorder()
                .foregroundColor(.primary)
                
                Button(action: {
                    triggerAction(actionName)
                }) {
                    Text("Trigger action")
                        .buttonStyle()
                }
            }
            
            TextField(
                "File Arg name",
                text: $fileArg
            )
            .roundedBorder()
            .foregroundColor(.primary)
            
            Button(action: {
                if let openFile = openFileAction {
                    if let url = openFile(fileArg) {
                        fileURL = URL(fileURLWithPath: url)
                        showFile = true
                    }
                }
            }) {
                Text("Open file")
                    .buttonStyle()
            }.sheet(isPresented: $showFile) {
                if let fileURL = fileURL {
                    FileTypePreview(fileURL: fileURL)
                }
            }
            
            HStack {
                Button(action: {
                    self.cancelAction()
                    self.isPresented = false
                }) {
                    Text("Cancel")
                        .buttonStyle()
                }
                
                Button(action: {
                    self.confirmAction()
                }) {
                    Text("Confirm")
                        .buttonStyle()
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 20)
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.2))
    }
}

struct ContentView: View {
    @State private var showConfirmMessage = false
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    self.showConfirmMessage = true
                }) {
                    Text("Show Confirm Message")
                        .buttonStyle()
                }
            }
            
            if showConfirmMessage {
                CustomTemplateView(
                    isPresented: $showConfirmMessage,
                    title: "Confirm Action",
                    message: "Are you sure you want to proceed?",
                    confirmAction: {
                        print("User confirmed")
                    },
                    cancelAction: {
                        print("User cancelled")
                    }, triggerAction: { action in
                        print("Trigger action: \(action)")
                    }
                )
                .transition(.opacity)
                .animation(.easeInOut, value: showConfirmMessage)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
