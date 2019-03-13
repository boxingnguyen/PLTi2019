//
//  VisitViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/19/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import Pulsator

class VisitViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let uuid = UUID(uuidString: "7d33f025-b79b-4756-998f-4c8b7aea33ca")!
    let identifier = "TMH.beacon"
    let viewIdentifier = [0: "", 1: "", 2: "bookshelfVC", 3: "printer3dVC"]
    
    @IBOutlet weak var buttonBook: UIButton!
    @IBOutlet weak var buttonPrinter: UIButton!
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var finishTourBtn: UIButton!
    @IBOutlet weak var animation: UIView!
    
    var arrImg = [String]()
    var timerImg : Timer?
    var i = Int()
    let pulsator = Pulsator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainImgView.contentMode = UIView.ContentMode.scaleAspectFit
        // go around techlab
        visitMode = true
        setupView()
        animation.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DetectBeacon()
    }
    
    func setupView() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Let's go around!"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "home"), style: .plain, target: self, action: #selector(turnBack(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.gray
        self.mainTextView.sizeToFit()
        
        buttonBook.isHidden = true
        buttonPrinter.isHidden = true

        mainTextView.text = "Stand at the entrance to start..."
        mainTextView.textAlignment = NSTextAlignment.center
        finishTourBtn.isHidden = true
        
        // animation
        pulsator.position = CGPoint(x: animation.bounds.width / 2, y: animation.bounds.width / 2)
        animation.layer.addSublayer(pulsator)

        pulsator.start()
        pulsator.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1).cgColor
        pulsator.numPulse = 4
        pulsator.radius = 140.0
        pulsator.animationDuration = 5.0
    }
    
    
    func DetectBeacon() {
        locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        rangeBeacons()
    }
    
    func rangeBeacons() {
        let region = CLBeaconRegion(proximityUUID: uuid, identifier: identifier)
        locationManager.startRangingBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            // User has authorized the appplication - range those beacons!
            rangeBeacons()
        }  else {
            print("user didn't authorize")
        }
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter { $0.proximity != CLProximity.unknown }
        
        // detect at least 1 beacon
        if (knownBeacons.count > 0) {
            animation.isHidden = false
            
            let closestBeacon = knownBeacons[0] as CLBeacon
            let beaconMajor = Int(truncating: closestBeacon.major)
            
            print(closestBeacon.accuracy)
            let distance = closestBeacon.accuracy
            
            if distance < 7 {
                pulsator.numPulse = 4
                pulsator.radius = 140.0
                pulsator.animationDuration = 5.0
            } else  {
                pulsator.numPulse = 2
                pulsator.radius = 170.0
                pulsator.animationDuration = 7.0
            }
            
            switch closestBeacon.proximity{
            case .near:
                self.animation.isHidden = true
                self.finishTourBtn.isHidden = true
                self.mainTextView.textAlignment = NSTextAlignment.left
                
                switch beaconMajor {
                // gate
                case 1:
                    checkViewByBeacon = "gate"
                    mainTextView.text = "Welcome to Tribal Tribal Media House Technology Lab. Tribal Media House is a marketing venture whose mission is to 'Create the future of marketing'. This DNA has been inherited. TMH Tech. Lab has been providing not only domestic-class, but also world-class Technology x Marketing solution. \n   Do you realize alphabet and special characters in ours logo? Yes, Marketing x Technnology! \n   Your rightside is where put shoes and display ours beautiful moments."
                    
                    self.arrImg = ["41", "38", "39", "40"]
                    startTimerImg()
                    
                    buttonPrinter.isHidden = true
                    buttonBook.isHidden = true
                // mission
                case 2:
                    checkViewByBeacon = "mission"
                    mainTextView.text = "The world is awesome, so many things to discover. Ignite your passion and feel it.\n Be crazy! 😜. Crazy people are more likely to be successful. Why? To think out of box, too foolish to be scared, to have high energy and dare to break the rules. \n   Finally, there are some behaviour rules, keep in mind nhé!"
                    
                    self.arrImg = ["03", "02", "01", "04"]
                    
                    startTimerImg()
                    
                    buttonPrinter.isHidden = true
                    buttonBook.isHidden = true
                // 3d printer
                case 3:
                    mainTextView.text = "Here is 3d printer. Thanks to Jo president, we can play with it to relax and encourage creativity also. If you need tutorial, touch button below."
                    
                    self.arrImg = ["42", "43", "37", "23"]
                    startTimerImg()
                    
                    buttonPrinter.isHidden = false
                    buttonBook.isHidden = true
                // open space
                default:
                    checkViewByBeacon = "book"
                    mainTextView.text = "This is open space where held morning meeting, fruit time or TechLab news and some special events like Christmas or women day. We also have lunch here or relax with shuttlecock. \n   Beside you there is ours bookshelf with various categories of books. Touch to button below to visit ours library and borrow book."
                    
                    self.arrImg = ["26", "33", "34", "44"]
                    startTimerImg()
                    
                    buttonPrinter.isHidden = true
                    buttonBook.isHidden = false
                }
            default:
                // show animation
                self.mainImgView.image = nil
                self.mainTextView.text = ""
                
                return
            }
        } else {
            self.i = 0
            stopTimerImg()
        }

    }
    
    func startTimerImg() {
        if timerImg == nil {
            Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.imageChange), userInfo: nil, repeats: false)
        }
    }
    
    func stopTimerImg() {
        if timerImg != nil {
            timerImg!.invalidate()
            timerImg = nil
        }
    }
    
    @objc func imageChange() {
        let url = URL(string: "http://192.168.0.12/api/app/webroot/img/\(arrImg[self.i]).JPG")
        
        if url != nil {
            let data = try? Data(contentsOf: url!)
            self.mainImgView.image = UIImage(data: data!)
            
            if i == 3 {
                
            }
        }
        
//        self.mainImgView.image = UIImage(named: arrImg[i])
        
        if i < arrImg.count - 1 {
            print(i)
            i += 1
        } else {
            i = 0
        }
    }
    
    @objc func turnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToBook(_ sender: Any) {
        let stboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = stboard.instantiateViewController(withIdentifier: "bookshelfVC")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func goToPrinter(_ sender: Any) {
        let stboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = stboard.instantiateViewController(withIdentifier: "printer3dVC")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func finishTour(_ sender: Any) {
        visitMode = false
        let stboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeVC = stboard.instantiateViewController(withIdentifier: "homeVC")
        self.navigationController?.pushViewController(homeVC, animated: false)
    }
}
