//
//  PDFView.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 7.08.24.
//  Copyright © 2024 Leanplum. All rights reserved.
//

import SwiftUI
import PDFKit

struct PDFView: UIViewRepresentable {
    let fileURL: URL
   
    func makeUIView(context: UIViewRepresentableContext<PDFView>) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.document = PDFDocument(url: fileURL)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFKit.PDFView, context: UIViewRepresentableContext<PDFView>) {
        uiView.document = PDFDocument(url: fileURL)
    }
}
