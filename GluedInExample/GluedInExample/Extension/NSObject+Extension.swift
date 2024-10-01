//
//  NSObject+Extension.swift
//  DailyCustomer
//
//  Created by Ashish Verma on 13/05/22.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
