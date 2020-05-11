//
//  LoginViewController.swift
//  On The Map
//
//  Created by Nyan Lin Tun on 11/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.activityIndicator.isHidden = true
    }
    

    @IBAction func loginAction(_ sender: UIButton) {
        self.passwordTextField.resignFirstResponder()
        if self.emailTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty {
            self.displatAlert(title: "Error", message: "Please enter email and password to login.")
        }else {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            OnTheMapNetwork.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "" , completeion: self.handleLoginResponse(success:errorMessage:))
        }
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        if let url = URL(string: OnTheMapClient.Endpoints.signUp.stringValue) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func handleLoginResponse(success: Bool, errorMessage: String) {
        if success {
            OnTheMapNetwork.getUserInfo(completion: self.handleGetUserInfoResponse(success:errorMessage:))
        }else {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.displatAlert(title: "Error", message: errorMessage)
            }
        }
    }
    
    private func handleGetUserInfoResponse(success: Bool, errorMessage: String) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            if success {
                self.performSegue(withIdentifier: "loginComplete", sender: nil)
            }else {
                self.displatAlert(title: "Error", message: errorMessage)
            }
        }
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.emailTextField.resignFirstResponder()
        }else {
            self.passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    private func setUpTextField() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
}

