//
//  LocationTableViewController.swift
//  On The Map
//
//  Created by Nyan Lin Tun on 11/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {

    private var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "On the Map"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if LocationModel.location.isEmpty {
            self.getStudentsLocation()
        }else {
            self.locations = LocationModel.location
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    private func getStudentsLocation() {
        OnTheMapNetwork.getStudentLocation(completeion: self.handleGetStudentLocation(success:message:))
    }
    
    private func handleGetStudentLocation(success: Bool, message: String) {
        self.locations = LocationModel.location
        DispatchQueue.main.async {
            if success {
                self.tableView.reloadData()
            }else {
                self.displatAlert(title: "Error", message: message)
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationCell = tableView.dequeueReusableCell(withIdentifier: "locationTableViewCell", for: indexPath) as! LocationTableViewCell
        let studentName = self.locations[indexPath.row].firstName + " " + self.locations[indexPath.row].lastName
        locationCell.studentName.text = studentName
        return locationCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.row
        let app = UIApplication.shared
        
        if let url = URL(string: locations[index].mediaURL) {
            app.open(url, options: [:], completionHandler: nil)
        }else {
            self.displatAlert(title: "Error", message: "URL is not valid.")
        }
    }
    
    @IBAction func refreshLocation(_ sender: UIBarButtonItem) {
        self.getStudentsLocation()
    }

}
