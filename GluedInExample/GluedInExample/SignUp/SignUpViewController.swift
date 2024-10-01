//
//  SignUpViewController.swift
//  GluedInExample
//
//  Created by Ashish Verma on 10/09/24.
//

import UIKit
import GluedInCoreSDK
import GluedInSDK

protocol SignUpViewControllerDelgate: AnyObject {
    func didUserSignUp(emailId: String, password: String, fullName: String)
}

class SignUpViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    weak var delegate: SignUpViewControllerDelgate?
    
    deinit {
        Debug.Log(message: "Deinit \(#fileID)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign Up"
        
        // Do any additional setup after loading the view.
        buttonSignUp.layer.cornerRadius = 4.0
        buttonSignUp.layer.masksToBounds = true
        
        textFieldFullName.delegate = self
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
                
        let backButton = UIBarButtonItem(
            image: UIImage.icBack,
            style: .plain, target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        // Handle the back button tap action here (e.g., pop the view controller)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTappedSignUp(_ sender: UIButton) {
        if let emailId = textFieldEmail.text,
           let password = textFieldPassword.text,
           let fullName = textFieldFullName.text,
           validateFields(email: emailId, password: password, fullName: fullName) {
            delegate?.didUserSignUp(emailId: emailId, password: password, fullName: fullName)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func validateFields(email: String?, password: String?, fullName: String?) -> Bool {
        // Check if any of the fields are empty
        if email?.isEmpty ?? true {
            showAlert(title: "Validation Error", message: "Email ID cannot be empty.")
            return false
        }
        
        if password?.isEmpty ?? true {
            showAlert(title: "Validation Error", message: "Password cannot be empty.")
            return false
        }
        
        if fullName?.isEmpty ?? true {
            showAlert(title: "Validation Error", message: "Full Name cannot be empty.")
            return false
        }
        
        // Check if the email format is valid
        if !isValidEmail(email!) {
            showAlert(title: "Validation Error", message: "Please enter a valid Email ID.")
            return false
        }
        
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
