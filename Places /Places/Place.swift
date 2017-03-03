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

import Foundation
import CoreLocation

class Place: ARAnnotation {
  let reference: String
  let placeName: String
  let address: String
  var phoneNumber: String?
  var website: String?
  var iconUrl: URL?
  
  var infoText: String {
    get {
      var info = "Address: \(address)"
      
      if phoneNumber != nil {
        info += "\nPhone: \(phoneNumber!)"
      }
      
      if website != nil {
        info += "\nweb: \(website!)"
      }
      return info
    }
  }
  
  init(dict: Dictionary<String, Any>) throws {
    guard let geometry = dict["geometry"] as? Dictionary<String, Any>, let location = geometry["location"] as? Dictionary<String, Any>, let lat = location["lat"] as? Double, let lng = location["lng"] as? Double else {
      throw SerializationError.missing("location")
    }
    
    guard let name = dict["name"] as? String else {
      throw SerializationError.missing("name")
    }
    
    
    guard let reference = dict["reference"] as? String else {
      throw SerializationError.missing("reference")
    }
    
    guard let vicinity = dict["vicinity"] as? String else {
      throw SerializationError.missing("vicinity")
    }
    
    guard let urlString = dict["icon"] as? String, let url = URL(string: urlString) else {
      throw SerializationError.missing("IconUrl")
    }
    
    placeName = name
    self.reference = reference
    self.address = vicinity
    self.iconUrl = url
    super.init()
    self.location = CLLocation(latitude: lat, longitude: lng)
  }
  
  override var description: String {
    return placeName
  }
}
