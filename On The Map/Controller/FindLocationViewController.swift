//
//  FindViewController.swift
//  On The Map
//
//  Created by Nyan Lin Tun on 11/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import UIKit
import CoreLocation

class FindLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Location"
        self.setUpTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.isHidden = true
    }

    @IBAction func findButton(_ sender: Any) {
        self.activityIndicator.isHidden = false
        self.urlTextField.resignFirstResponder()
        if self.locationTextField.text?.isEmpty ?? true || self.urlTextField.text?.isEmpty ?? true{
            self.displatAlert(title: "Warning", message: "Please, enter location and URL.")
        }else {
            //Location and URL are not empty
            self.findLocation()
        }

    }
    
    private func findLocation() {
        CLGeocoder().geocodeAddressString(self.locationTextField.text ?? "") { (placemarks, error) in
            if placemarks?.isEmpty ?? true {
                self.displatAlert(title: "Error", message: "cannot find location.")
            }else {
                guard let userLocation = placemarks?.first?.location else {
                    self.activityIndicator.isHidden = true
                    self.displatAlert(title: "Error", message: "Cannot find location.")
                    return
                }
                
                let location = StudentLocationRequest(uniqueKey: "1234", firstName: OnTheMapClient.UserInfo.firstName, lastName: OnTheMapClient.UserInfo.lastName, mapString: self.locationTextField.text ?? "", mediaURL: self.urlTextField.text ?? "", latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                self.performSegue(withIdentifier: "toAddLocation", sender: location)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddLocation" {
            if let addLocationVC = segue.destination as? AddLocationViewController {
                addLocationVC.location = sender as? StudentLocationRequest
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension FindLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.locationTextField {
            self.locationTextField.resignFirstResponder()
        }else {
            self.urlTextField.resignFirstResponder()
        }
        return true
    }
    
    private func setUpTextField() {
        self.locationTextField.delegate = self
        self.urlTextField.delegate = self
        self.locationTextField.autocorrectionType = .no
        self.urlTextField.autocorrectionType = .no
    }
}
