//
//  ViewController.swift
//  MobileController
//
//  Created by --- on 7/11/19.
//  Copyright © 2019 Vault Dweller. All rights reserved.
//

import UIKit
import Foundation
import CoreMotion

class ViewController: UIViewController {
 
    @IBOutlet weak var MyImageView: UIImageView!
    
    let motion=CMMotionManager()
    var timer:Timer!
    var x:Int!
    var y:Int!
    var z:Int!
    
    let headers = [
        "cache-control": "no-cache",
        "Postman-Token": "536f11f3-870c-4e22-87bb-6993926241ad"
    ]
    
    
    
    override func viewDidLoad() {
        let wheel = #imageLiteral(resourceName: "Image")
        MyImageView.image=wheel
        super.viewDidLoad()
        startMagnetometer()
        // Do any additional setup after loading the view.
    }
    
    var count:Int!=0
    var offset:Int!=0
    var bSwitch:Int!=0
    
    func startMagnetometer() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isMagnetometerAvailable{
            self.motion.magnetometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startMagnetometerUpdates()
            
            // Configure a timer to fetch the data.
            self.timer = Timer(fire: Date(), interval: (1.0/10.0),
                               repeats: true, block: { (timer) in
                                // Get the accelerometer data.
                                if let data = self.motion.magnetometerData {
                                    if(self.count==10 && self.bSwitch != 1)
                                    {
                                        self.offset=self.y
                                        self.bSwitch=1
                                    }
                                    self.count=(self.count+1)%100
                                    if(self.count != 1)
                                    {
                                        self.x = Int(data.magneticField.x)
                                        self.y = Int(data.magneticField.y)
                                        self.z = Int(data.magneticField.z)
                                        
                                       print( "x: ",self.x,"  y: ",self.y," z: ",self.z,"offset: ",self.offset)
                                        let request = NSMutableURLRequest(url: NSURL(string: "http://139.155.96.86:443/?a="+String(self.y-self.offset)+"&hs=False")! as URL,
                                                                          cachePolicy: .useProtocolCachePolicy,
                                                                          timeoutInterval: 10.0)
                                        request.httpMethod = "PUT"
                                        request.allHTTPHeaderFields = self.headers
                                        
                                        let session = URLSession.shared
                                        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                                            if (error != nil) {
                                                //print(error)
                                            } else {
                                                let httpResponse = response as? HTTPURLResponse
                                                //print(httpResponse)
                                            }
                                        })
                                        
                                        dataTask.resume()
                                    }
                                    
                                  
                                    
                                    // Use the accelerometer data in your app.
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: .default)
        }
    }



}

