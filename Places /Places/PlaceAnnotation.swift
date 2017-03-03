//
//  PlaceAnnotation.swift
//  Places
//
//  Created by yesway on 2017/3/3.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import UIKit
import MapKit

enum SerializationError: Error {
  case missing(String)
}

class PlaceAnnotation: NSObject, MKAnnotation {
  
  var coordinate: CLLocationCoordinate2D
//
  let title: String?

  init(dict: Dictionary<String, Any>) throws {
    guard let geometry = dict["geometry"] as? Dictionary<String, Any>, let location = geometry["location"] as? Dictionary<String, Any>, let lat = location["lat"] as? Double, let lng = location["lng"] as? Double else {
      throw SerializationError.missing("location")
    }
    
    guard let name = dict["name"] as? String else {
      throw SerializationError.missing("name")
    }
    
    self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    self.title = name
    super.init()
  }
}
