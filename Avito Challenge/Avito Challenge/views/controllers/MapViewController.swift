//
//  ViewController.swift
//  Avito Challenge
//
//  Created by Safoine Moncef Amine on 27/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var isNearButton: UIButton!
    
    //MARK: - locale variables
    let regionRadius: CLLocationDistance = 500000
    let issNearRegionRadius: CLLocationDistance = 10000
    let annotation = MKPointAnnotation()
    private var locationManager = CLLocationManager()
    var issLocation: CLLocation {
        return CLLocation(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)
    }
    var latitude : String = ""
    var longitude : String = ""
    
    //MARK : - VC life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(MapViewController.updateIssLocation), userInfo: nil, repeats: true)
    }
    //MARK: - Configurations
    func configure(){
        self.isNearButton.layer.cornerRadius = 15
        self.isNearButton.layer.borderColor = UIColor.black.cgColor
        configureCoreLocation()
    }
    func configureCoreLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Traitement Methods
    func checkIfIssIsNear() {
        if (CLLocationManager.locationServicesEnabled() && locationManager.location != nil) {
            if locationManager.location!.distance(from: issLocation) > issNearRegionRadius {
                DispatchQueue.main.async {
                    self.isNearButton.backgroundColor = UIColor.red
                }
            }else {
                DispatchQueue.main.async {
                    self.isNearButton.backgroundColor = UIColor.green
                }
            }
        }
    }
    
    @objc private func updateIssLocation(){
        ISSApi.shared.getCurrentISSLocation { (json) -> Void in
            (self.latitude,self.longitude) = Parser.parseIssLocationCoordonate(json: json)
            DispatchQueue.main.async {
                self.annotation.coordinate = self.issLocation.coordinate
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotation(self.annotation)
            }
            self.checkIfIssIsNear()
        }
    }
    
    
    //MARK: - Actions
    @IBAction func centerMapOnISS(_ sender: Any) {
        let coordinateRegion = MKCoordinateRegion(center:issLocation.coordinate,latitudinalMeters:regionRadius,longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func showIssPassengers(_ sender: Any) {
        performSegue(withIdentifier: "showPassengers", sender: self)
    }
    
    
    @IBAction func nextPassTimes(_ sender: Any) {
        performSegue(withIdentifier: "showNextPassTimes", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNextPassTimes" {
            let vc = segue.destination as! NextPassTimesViewController
            vc.lan = locationManager.location?.coordinate.latitude
            vc.lon = locationManager.location?.coordinate.longitude
        }
    }
    
}

extension MapViewController : CLLocationManagerDelegate {
    
}
