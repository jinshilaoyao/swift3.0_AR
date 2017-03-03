//
//  AnnotationView.swift
//  Places
//
//  Created by yesway on 2017/3/3.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import UIKit

protocol AnnotationViewDelegate {
  func didTouch(annotationView: AnnotationView)
}

class AnnotationView: ARAnnotationView {
  
  var titleLabel: UILabel?
  var distanceLabel: UILabel?
  var iconImage: UIImageView?
  var delegate: AnnotationViewDelegate?

  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    loadUI()
  }
  
  func loadUI() {
    
    titleLabel?.removeFromSuperview()
    distanceLabel?.removeFromSuperview()
    iconImage?.removeFromSuperview()
    
    let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
    icon.backgroundColor = UIColor.blue
    self.addSubview(icon)
    iconImage = icon
    
    let label = UILabel(frame: CGRect(x: self.frame.size.height + 10, y: 0, width: self.frame.size.width, height: 30))
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
    label.textColor = UIColor.white
    self.addSubview(label)
    self.titleLabel = label

    distanceLabel = UILabel(frame: CGRect(x: self.frame.size.height + 10, y: 30, width: self.frame.size.width, height: 20))
    distanceLabel?.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
    distanceLabel?.textColor = UIColor.green
    distanceLabel?.font = UIFont.systemFont(ofSize: 12)
    self.addSubview(distanceLabel!)
    
    if let annotation = annotation as? Place {
      titleLabel?.text = annotation.placeName
      distanceLabel?.text = String(format: "%.2f km", annotation.distanceFromUser / 1000)
      
      DispatchQueue.main.async {
        do {
          let imageData = try Data(contentsOf: annotation.iconUrl!)
          icon.image = UIImage(data: imageData)
        } catch {
          
        }
      }
      
    }
  }
  
  //1
  override func layoutSubviews() {
    super.layoutSubviews()
    titleLabel?.frame = CGRect(x: self.frame.size.height + 10, y: 0, width: self.frame.size.width, height: 30)
    distanceLabel?.frame = CGRect(x: self.frame.size.height + 10, y: 30, width: self.frame.size.width, height: 20)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    delegate?.didTouch(annotationView: self)
    
  }
}
