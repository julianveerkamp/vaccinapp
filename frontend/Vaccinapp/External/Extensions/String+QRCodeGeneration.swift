//
//  String+MakeQR.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import UIKit
import CoreImage

public extension String {
    func generateQRCode() -> UIImage? {
        
        let context = CIContext()
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil}
        
        let data = self.data(using: String.Encoding.ascii)
        
        var qrImage = UIImage(systemName: "xmark.circle") ?? UIImage()
        
        filter.setValue(data, forKey: "inputMessage")
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            
            if let image = context.createCGImage(
                
                outputImage,
                
                from: outputImage.extent) {
                
                qrImage = UIImage(cgImage: image)
                
            }
            
        }
        
        return qrImage
    }
}
