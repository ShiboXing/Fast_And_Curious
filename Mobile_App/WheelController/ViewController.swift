//
//  ViewController.swift
//  PracticeApp
//
//  Created by --- on 2/17/19.
//  Copyright © 2019 Vault Dweller. All rights reserved.
//
import CoreMotion
import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK: Properties
    
    @IBOutlet weak var ZipcodeTextField: UITextField!
    @IBOutlet weak var ZipcodeLabel: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    
    var timer:Timer!
    let motion=CMMotionManager()
    var x:Double!
    var y:Double!
    var z:Double!
    var angle:Double!
    var speedUp:Bool!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //startAccelerometers()
        //startGyros()
        self.motion.startMagnetometerUpdates()
        startMagneto()
        //Requestput()
    
        
    }
    
    //MARK:  UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard.
        ZipcodeTextField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        ZipcodeLabel.text=ZipcodeTextField.text
    }
    //MARK: Actions
    @IBAction func setDefaultZipcodeLabel(_ sender: UIButton) {
        
        ZipcodeTextField.resignFirstResponder()
        ZipcodeLabel.text="15213"
        
    }
    
    
    //MARK: Actions
    @IBAction func selectHomeImage(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        ZipcodeTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        homeImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func startMagneto()
    {
        self.timer = Timer(fire: Date(), interval: (1.0/10.0),
                           repeats: true, block: { (timer) in

                            //var tmp=self.motion.magnetometerData?.magneticField.y;
                            //self.angle=Int(tmp!)
                            //print(self.motion.magnetometerData)
                            self.angle=self.motion.magnetometerData?.magneticField.y
                            if (!(self.angle==nil))
                            {
                            
                                //print("x: \(self.angle)  y:\(self.motion.magnetometerData?.magneticField.y)")
                                
                                print(self.angle)
                                self.Requestput(a: self.angle!, hs: false)
                            }
                            //self.angle=Int(tmp)
                           
        })
        // Add the timer to the current run loop.
        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
    }
    
    func Requestput(a:Double,hs:Bool){
        
        let headers = [
            "cache-control": "no-cache",
            "Postman-Token": "281cb5e2-314a-4276-b110-b3654bc51f61"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://ec2-13-59-35-233.us-east-2.compute.amazonaws.com:443/?a=\(self.angle)&hs=\(hs)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                //print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                //print(httpResponse)
                
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    
                    print(json)
                }
            }
        })
        
        dataTask.resume()
        /*
        let url = URL(string: "https://ec2-18-188-94-173.us-east-2.compute.amazonaws.com:443")!
        let session = URLSession.shared

        var request = URLRequest(url: url)
        let parameters = ["a": 13, "hs": false] as [String : Any]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()*/
        
        /*let url = NSURL(string: "https://ec2-18-188-94-173.us-east-2.compute.amazonaws.com") //Remember to put ATS exception if the URL is not https
        let request = NSMutableURLRequest(url: url! as URL)
        //request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional
        request.httpMethod = "PUT"
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        let data = "a=10&hs=True".data(using: String.Encoding.utf8)
        print("data: \(data) \n")
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if error != nil {
                
                //handle error
            }
            else {
                
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Parsed JSON: '\(jsonStr)'")
            }
        }
        dataTask.resume()*/
    }
    /*func startGyros() {
        if motion.isGyroAvailable {
            self.motion.gyroUpdateInterval = 1.0 / 60.0
            self.motion.startGyroUpdates()
            
            // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                               repeats: true, block: { (timer) in
                                // Get the gyro data.
                                if let data = self.motion.gyroData {
                                    self.x = data.rotationRate.x
                                    self.y = data.rotationRate.y
                                    self.z = data.rotationRate.z
                                    
                                    // Use the gyroscope data in your app.
                                }
                                //print("\(self.x) \(self.y) \(self.z)");
                                print("\(self.z)");
            })
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        }
    }*/
    /*
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the data.
            self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                               repeats: true, block: { (timer) in
                                // Get the accelerometer data.
                                if let data = self.motion.accelerometerData {
                                    self.x = data.acceleration.x
                                    self.y = data.acceleration.y
                                    self.z = data.acceleration.z+1
                                    
                                    // Use the accelerometer data in your app.
                                }
                                
                                //print("\(self.x) \(self.y) \(self.z)");
                                print("\(self.z)");
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        }
    }*/
    
    
}

