//
//  ViewController.swift
//  ARStepOne
//
//  Created by yesway on 2017/2/28.
//  Copyright © 2017年 yesway. All rights reserved.
//

import UIKit
import AVFoundation
import SceneKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    var cameraSession: AVCaptureSession?
    var cameraLayer: AVCaptureVideoPreviewLayer?
    var target: YYARItem!
    
    //1
    var locationManager = CLLocationManager()
    var heading: Double = 0
    var userLocation = CLLocation()
    //2
    let scene = SCNScene()
    let cameraNode = SCNNode()
    let targetNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadCamera()
        self.cameraSession?.startRunning()
        
        //1
        self.locationManager.delegate = self
        //2
        self.locationManager.startUpdatingHeading()
        
        //3
        sceneView.scene = scene
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)
        setupTarget()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadCamera() {
        //1
        let captureSessionResult = createCaptureSession()
        
        //2
        guard captureSessionResult.error == nil, let session = captureSessionResult.session else {
            print("Error creating capture session.")
            return
        }
        
        //3
        self.cameraSession = session
        
        //4
        if let cameraLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession) {
            cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            cameraLayer.frame = self.view.bounds
            //5
            self.view.layer.insertSublayer(cameraLayer, at: 0)
            self.cameraLayer = cameraLayer
        }
    }
    
    func createCaptureSession() -> (session: AVCaptureSession?, error: NSError?)
    {
        var captureSession: AVCaptureSession?
        var error: NSError?
        
        let backVideoDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        
        if backVideoDevice != nil
        {
            var videoInput: AVCaptureInput!
            do {
                videoInput = try AVCaptureDeviceInput(device: backVideoDevice)
            } catch let error1 as NSError {
                error = error1
                videoInput = nil
            }
            
            if error == nil
            {
                captureSession = AVCaptureSession()
                
                if captureSession!.canAddInput(videoInput)
                {
                    captureSession!.addInput(videoInput)
                }
                else
                {
                    error = NSError(domain: "", code: 0, userInfo: ["description": "Error adding video input."])
                }
            }
            else
            {
                error = NSError(domain: "", code: 1, userInfo: ["description": "Error creating capture device input."])
            }
        }
        else
        {
            error = NSError(domain: "", code: 2, userInfo: ["description": "Back video device not found."])
        }
        
        return (captureSession, error)
    }
    
    func repositionTarget()
    {
        //1
        let heading = getHeadingForDirectionFromCoordinate(from: userLocation, to: target.location)
        
        //2
        let delta = heading - self.heading
        
        if delta < -15.0 {
            leftLabel.isHidden = false
            rightLabel.isHidden = true
        } else if delta > 15 {
            leftLabel.isHidden = true
            rightLabel.isHidden = false
        } else {
            leftLabel.isHidden = true
            rightLabel.isHidden = true
        }
        
        
        
        let distance = userLocation.distance(from: target.location) * 20
        print(distance)
        if let node = target.itemNode {
            //5
            if node.parent == nil {
                node.position = SCNVector3(x: Float(delta), y: 0, z: Float(-distance))
                scene.rootNode.addChildNode(node)
            } else {
                //6
                node.removeAllActions()
                node.runAction(SCNAction.move(to: SCNVector3(x: Float(delta), y: 0, z: Float(-distance)), duration: 0.2))
            }
        }
        
    }
    
    func getHeadingForDirectionFromCoordinate(from: CLLocation, to: CLLocation) -> Double {
        //1
        let fLat = degreesToRadians(from.coordinate.latitude)
        let fLng = degreesToRadians(from.coordinate.longitude)
        let tLat = degreesToRadians(to.coordinate.latitude)
        let tLng = degreesToRadians(to.coordinate.longitude)
        
        //2
        let degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))
        
        //3
        if degree >= 0 {
            return degree
        } else {
            return degree + 360
        }
    }
    
    
    func radiansToDegrees(_ radians: Double) -> Double {
        return (radians) * (180.0 / M_PI)
    }
    
    func degreesToRadians(_ degrees: Double) -> Double {
        return (degrees) * (M_PI / 180.0)
    }
    
    func setupTarget() {
        //1
        let scene = SCNScene(named: "art.scnassets/\(target.itemDescription).dae")
        //2
        let enemy = scene?.rootNode.childNode(withName: target.itemDescription, recursively: true)
        //3
        if target.itemDescription == "dragon" {
            enemy?.position = SCNVector3(x: 0, y: -15, z: 0)
        } else {
            enemy?.position = SCNVector3(x: 0, y: 0, z: 0)
        }
        
        //4
        let node = SCNNode()
        node.addChildNode(enemy!)
        node.name = "enemy"
        self.target.itemNode = node
    }

}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //1
        self.heading = fmod(newHeading.trueHeading, 360.0)
        repositionTarget()
    }
}

