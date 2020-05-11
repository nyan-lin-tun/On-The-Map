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
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    

    @IBAction func loginAction(_ sender: UIButton) {
        if self.emailTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty {
            self.displatAlert(title: "Error", message: "Please enter email and password to login.")
        }else {
            OnTheMapNetwork.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "" , completeion: self.handleLoginResponse(success:errorMessage:))
        }
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        if let url = URL(string: OnTheMapClient.Endpoints.signUp.stringValue) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func handleLoginResponse(success: Bool, errorMessage: String) {
        DispatchQueue.main.async {
            if success {
                self.performSegue(withIdentifier: "loginComplete", sender: nil)
            }else {
                self.displatAlert(title: "Error", message: errorMessage)
            }
        }   
    }
    
    
}
