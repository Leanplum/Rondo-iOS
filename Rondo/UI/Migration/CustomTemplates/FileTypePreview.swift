//
//  FileTypePreview.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 7.08.24.
//  Copyright © 2024 Leanplum. All rights reserved.
//

import SwiftUI

struct FileTypePreview: View {
    let fileURL: URL
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                if let imageData = try? Data(contentsOf: fileURL), let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if fileURL.pathExtension == "pdf" {
                    PDFView(fileURL: fileURL)
                } else {
                    WebView(url: fileURL)
                }
            }
            .navigationBarItems(trailing: doneButton)
            .onAppear {
                print("FileTypePreview: Opening File URL: \(fileURL)")
            }
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
                .font(.system(size: 17, weight: .medium))
        }
    }
}
