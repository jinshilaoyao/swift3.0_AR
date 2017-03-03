/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

import MapKit
import CoreLocation


class ViewController: UIViewController {

  
  @IBOutlet weak var mapView: MKMapView!
  
  fileprivate(set) var locationManager = CLLocationManager()
  
  fileprivate var startedLoadingPOIs = false
  fileprivate var places = [Place]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        perpareLocationManager()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func perpareLocationManager() {
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
  }
  
  @IBAction func showARController(_ sender: Any) {
  }
  
}
extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if locations.count > 0 {
      let location = locations.last!
      print("Accuracy--\(location.horizontalAccuracy)")
      
      if Int(location.horizontalAccuracy) < 100 {
        manager.stopUpdatingLocation()
        let span = MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.region = region
        
        loadPOI(location: location)
      }
    }
  }
  
  func loadPOI(location: CLLocation) {
    if !startedLoadingPOIs {
      startedLoadingPOIs = true
      
      let loader = PlacesLoader()
      loader.loadPOIS(location: location, radius: 500, handler: { (dict, error) in

        if error != nil {
          print(error ?? "unknow fail")
          return
        }
        
        guard let placeArray = dict?.object(forKey: "results") as? Array<Dictionary<String, Any>> else {return}
        
        for placeDit in placeArray {
          
          do {
            let place = try Place(dict: placeDit)
            self.places.append(place)
          } catch let error {
            print(error)
          }
          
          do {
            let annotation = try PlaceAnnotation(dict: placeDit)
            DispatchQueue.main.async {
              self.mapView.addAnnotation(annotation)
            }
          } catch let error {
            print(error)
          }
          
        }
      })
    }
  }
}

