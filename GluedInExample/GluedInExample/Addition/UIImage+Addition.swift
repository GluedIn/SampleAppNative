//
//  UIImage+Addition.swift
//  GluedInExample
//
//  Created by Ashish Verma on 10/09/24.
//

import Foundation
import UIKit

extension UIImage {
    
    class var icBack: UIImage {
        return UIImage.localImage("icBackArrow")
    }
}

extension UIImage {
    private class EmptyClass {}
    
    static func localImage(_ name: String, template: Bool = false) -> UIImage {
        let bundle = Bundle(for: EmptyClass.self)
        var image = UIImage(named: name, in: bundle, compatibleWith: nil) ?? UIImage()
        if template {
            image = image.withRenderingMode(.alwaysTemplate)
        }
        return image
    }
    
}
