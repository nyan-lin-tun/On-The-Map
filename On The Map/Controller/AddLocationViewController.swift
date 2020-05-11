//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Nyan Lin Tun on 11/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    
    @IBOutlet weak var mapsView: MKMapView!
    var location: StudentLocationRequest?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapsView.delegate = self
        self.title = "Add Location"
        self.setStudentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.isHidden = true
    }
    
    
    private func studentLocationBody() -> Data {
        let body = try! JSONEncoder().encode(location)
        return body
    }
    
    private func postStudentLocation() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        OnTheMapNetwork.postStudentLocation(body: self.studentLocationBody(), completion: self.handlePostStudentLocationResponse(success:message:))
    }
    
    private func handlePostStudentLocationResponse(success: Bool, message: String) {
        self.activityIndicator.isHidden = true
        DispatchQueue.main.async {
            if success {
                self.dismiss(animated: true, completion: nil)
            }else {
                self.displatAlert(title: message, message: "Please try again later")
            }
        }
        
    }

    @IBAction func postLocationAction(_ sender: UIButton) {
        self.postStudentLocation()
    }
    
    private func setStudentLocations() {
        guard let location = location else { return }
        let latitude = CLLocationDegrees(location.latitude)
        let longitude = CLLocationDegrees(location.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        annotation.subtitle = location.mediaURL
        mapsView.addAnnotation(annotation)
        let studentLocation = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapsView.setRegion(studentLocation, animated: true)
    }
}

extension AddLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }else {
                self.displatAlert(title: "Error", message: "URL is not valid")
            }
        }
    }
}
