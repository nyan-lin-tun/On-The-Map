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
        alertController.addAction(UIAlertAction(title: "Dismisss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
