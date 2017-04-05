//
//  ImageTargetViewController.swift
//  ARStepThree
//
//  Created by yesway on 2017/3/6.
//  Copyright © 2017年 yesway. All rights reserved.
//

import UIKit

//SampleApplicationControl, SampleAppMenuDelegate> {
//    
//    Vuforia::DataSet*  dataSetCurrent;
//    Vuforia::DataSet*  dataSetTarmac;
//    Vuforia::DataSet*  dataSetStonesAndChips;
//    
//    BOOL switchToTarmac;
//    BOOL switchToStonesAndChips;
//    
//    // menu options
//    BOOL extendedTrackingEnabled;
//    BOOL continuousAutofocusEnabled;
//    BOOL flashEnabled;
//    BOOL frontCameraEnabled;
//}
//
//@property (nonatomic, strong) ImageTargetsEAGLView* eaglView;
//@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;
//@property (nonatomic, strong) SampleApplicationSession * vapp;
//
//@property (nonatomic, readwrite) BOOL showingMenu;

class ImageTargetViewController: UIViewController {
    
    var dataSetCurrent: DataSet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
