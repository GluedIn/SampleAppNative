//
//  BaseViewController.swift
//  VeastaHr
//
//  Created by Ashish Verma on 21/09/23.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color (you can change this to your preferred color)
        view.backgroundColor = .white
        
        // Override the user interface style
        overrideUserInterfaceStyle = .light // You can use .dark or .unspecified as needed
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        // Customize the navigation bar appearance here (e.g., title color, background color, etc.)
        
        // Set the title text color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.themeColor]
        
        // Set the background color of the navigation bar
        navigationController?.navigationBar.barTintColor = .white
        
        UINavigationBar.appearance().tintColor = UIColor.themeColor
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    
}
