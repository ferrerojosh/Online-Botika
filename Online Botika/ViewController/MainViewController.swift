//
//  ViewController.swift
//  Online Botika
//
//  Created by dan solano on 19/03/2018.
//  Copyright © 2018 ferrerojosh. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var resultsController: UITableViewController!
    var searchController: UISearchController!
    var locationManager: CLLocationManager!
    var locationLoaded = false
    
    let radius = 10000
    var response: NearbyPlacesResponse?
    var places: [Place] = [Place]()
    var selectedPlace: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsController = UITableViewController(style: .plain)
        resultsController.tableView.register(UINib(nibName: "PharmacyTableViewCell", bundle: nil), forCellReuseIdentifier: "PharmacyCell")
        
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        resultsController.tableView.separatorInset = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        // Configure search bar
        let searchBar = searchController.searchBar
        
        searchBar.barStyle = .black
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .white
        
        // Configure search bar text
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search Medicine", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        // Attach search bar to navigation controller title view
        self.navigationItem.titleView = searchBar
        
        // Modify navigation controller color
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor(hex: 0x910000)
            navigationBar.tintColor = UIColor.white
        }
        
        // Modify view
        // Set as main view
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        probeLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.resultsController.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pharmacies"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == resultsController.tableView {
            self.selectedPlace = places[indexPath.row]
            self.performSegue(withIdentifier: "PharmacyDetailSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PharmacyCell", for: indexPath) as! PharmacyTableViewCell
    
        let place = places[indexPath.row]
        
        cell.textPharmacy.text = place.name
        cell.textAddress.text = place.vicinity
        cell.setPrice(price: 20.23)
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let controller = segue.destination as! PharmacyDetailViewController
        controller.place = selectedPlace
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension MainViewController: CLLocationManagerDelegate {
    
    func probeLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func didReceiveResponse(response: NearbyPlacesResponse?) -> Void {
        self.response = response
        
        if response?.status == "OK" {
            if let p = response?.places {
                places.append(contentsOf: p)
            }
            
            resultsController.tableView.reloadData()
        } else {
            let alert = UIAlertController.init(title: "Error", message: "Unable to fetch nearby pharmacies", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction.init(title: "Retry", style: .default, handler: { (action) in
                self.probeLocation()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.first != nil else {
            return
        }
        guard locationLoaded == false else {
            return
        }
        NearbyPlacesController.nearbyPlaces(by: "pharmacy", coordinates: (locations.first?.coordinate)!, radius: radius, token: self.response?.nextPageToken, completion: didReceiveResponse)
        
        locationLoaded = true
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: (hex & 0xFF))
    }
    
}

