//
//  GlobalManager.swift
//  GluedInExample
//
//  Created by Ashish Verma on 11/09/24.
//

import Foundation

class GlobalManager {
    // Singleton instance
    static let shared = GlobalManager()
    
    // Key for UserDefaults
    private let loginStatusKey = "isUserLoggedIn"
    
    // Private initializer to enforce singleton pattern
    private init() {}
    
    // Function to set the login status and save it in UserDefaults
    func setUserLoggedIn(_ status: Bool) {
        UserDefaults.standard.set(status, forKey: loginStatusKey)
    }
    
    // Function to fetch the login status from UserDefaults
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: loginStatusKey)
    }
}
