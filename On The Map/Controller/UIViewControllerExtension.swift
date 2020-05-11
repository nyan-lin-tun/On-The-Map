//
//  UIViewControllerExtension.swift
//  On The Map
//
//  Created by Nyan Lin Tun on 11/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import UIKit

extension UIViewController {
    func displatAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        OnTheMapNetwork.logout { (success, message) in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                }else {
                    self.displatAlert(title: "Error", message: message)
                }
            }
        }
    }
    
    @IBAction func addLocation(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "toFindLocation", sender: nil)
    }
    
}

