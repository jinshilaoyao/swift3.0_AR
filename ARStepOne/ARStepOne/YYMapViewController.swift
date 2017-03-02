//
//  YYMapViewController.swift
//  ARStepOne
//
//  Created by yesway on 2017/2/28.
//  Copyright © 2017年 yesway. All rights reserved.
//

import UIKit
import MapKit
class YYMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var targets = [YYARItem]()
    
    let locatinoManager = CLLocationManager()
    
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.userTrackingMode = .followWithHeading
        mapView.delegate = self
//        setupTargetLocations()
        setupLocationManager()
    }
    
    //MARK: - setup
    func setupTargetLocations() {
        let wolf1 = YYARItem(itemDescription: "wolf1", location: CLLocation(latitude: 39.955593042207086, longitude: 116.3371299213584
), itemNode: nil)
        targets.append(wolf1)
        
//        let dragon = YYARItem(itemDescription: "dragon", location: CLLocation(latitude: 39.950293042207186, longitude: 116.3371299213684), itemNode: nil)
//        targets.append(dragon)
        
        for item in targets {
            let annation = YYMapAnnotation(location: item.location.coordinate, item: item)
            mapView.addAnnotation(annation)
        }
    }
    
    func setupLocationManager() {
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locatinoManager.requestWhenInUseAuthorization()
        }
        locatinoManager.startUpdatingLocation()
        locatinoManager.delegate = self
    }
    
    
    @IBAction func searchMonster() {
        
        targets.removeAll()
        
        let wolfLocation = CLLocation(latitude: self.userLocation!.coordinate.latitude, longitude: self.userLocation!.coordinate.longitude + 0.0004)
        
        let wolf = YYARItem(itemDescription: "wolf", location: wolfLocation, itemNode: nil)
        targets.append(wolf)
        
        for item in targets {
            let annation = YYMapAnnotation(location: item.location.coordinate, item: item)
            mapView.addAnnotation(annation)
        }
    }
    
}
extension YYMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        self.userLocation = location
    }
}

extension YYMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let coordinate = view.annotation!.coordinate
        
        if (view.annotation?.title)! == "My Location" {
            return
        }
        
        if let userCorrdinate = self.userLocation {
            print(userCorrdinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)))
            if userCorrdinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 50 {
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "ARViewController") as? ViewController
                
                let mapAnnotation = view.annotation as? YYMapAnnotation
                
                vc?.target = mapAnnotation?.item
                vc?.userLocation = mapView.userLocation.location!
                vc?.delegate = self
                self.present(vc!, animated: true, completion: nil)
            }
        }
    }
}

extension YYMapViewController: ARControllerDelegate {
    func viewController(controller: ViewController, tappedTarget: YYARItem) {
        
    }
}
