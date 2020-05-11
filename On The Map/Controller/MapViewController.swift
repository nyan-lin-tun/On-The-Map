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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "On the Map"
        self.mapsView.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        getStudentsLocationForMaps()
    }
    
    private func getStudentsLocationForMaps() {
        annotations.removeAll()
        OnTheMapNetwork.getStudentLocation(completeion: self.handleStudentLocationResponse(success:message:))
    }
    
    private func handleStudentLocationResponse(success: Bool, message: String) {
        
        if success {
            for location in LocationModel.location {
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
    
    @IBAction func refreshLocation(_ sender: UIBarButtonItem) {
        self.getStudentsLocationForMaps()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen) {
                app.open(url, options: [:], completionHandler: nil)
            }else {
                self.displatAlert(title: "Error", message: "URL is not valid")
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
