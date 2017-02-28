//
//  YYMapAnnotation.swift
//  ARStepOne
//
//  Created by yesway on 2017/2/28.
//  Copyright © 2017年 yesway. All rights reserved.
//

import MapKit

class YYMapAnnotation: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let title: String?
    let item: YYARItem
    
    init(location: CLLocationCoordinate2D, item: YYARItem) {
        
        self.coordinate = location
        self.title = item.itemDescription
        self.item = item
        super.init()
    }
    
}
