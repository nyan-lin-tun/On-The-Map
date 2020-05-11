//
//  MapViewController.swift
//  On The Map
//
//  Created by Nyan Lin Tun on 11/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapsView: MKMapView!
    
    private var annotations = [MKPointAnnotation]()
    private var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapsView.delegate = self
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.getStudentsLocation()
    }
    
    private func getStudentsLocation() {
        annotations.removeAll()
        OnTheMapNetwork.getStudentLocation(completeion: self.handleStudentLocationResponse(success:locations:message:))
    }
    
    private func handleStudentLocationResponse(success: Bool, locations: [StudentLocation]?, message: String) {
        
        if success {
            self.locations = locations!
            for location in self.locations {
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = location.firstName + " " + location.lastName
                annotation.subtitle = location.mediaURL
                annotations.append(annotation)
            }
            DispatchQueue.main.async {
                self.mapsView.addAnnotations(self.annotations)
            }
        }else {
            DispatchQueue.main.async {
                self.displatAlert(title: "Error", message: message)
            }
        }
        
        
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
