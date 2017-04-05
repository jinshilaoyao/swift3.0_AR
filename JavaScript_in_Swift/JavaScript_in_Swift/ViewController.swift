//
//  ViewController.swift
//  JavaScript_in_Swift
//
//  Created by yesway on 2017/3/8.
//  Copyright © 2017年 yesway. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bgview: UIView!
    
    var block: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.block = { [unowned self] in
            self.bgview.alpha = 0.1
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        block!()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("deinit")
    }
}

