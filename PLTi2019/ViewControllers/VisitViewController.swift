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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // go around techlab
        visitMode = true
        setupView()
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

    }
    
//    func changeView() {
//        let stboard = UIStoryboard.init(name: "Main", bundle: nil)
//        var viewCtr = String()
//        
//        if checkViewByBeacon == "book" {
//            viewCtr = "bookshelfVC"
//            buttonPrinter.isHidden = true
//            buttonBook.isHidden = false
//        } else if checkViewByBeacon == "3dTutorial" {
//            viewCtr = "printer3dVC"
//            buttonPrinter.isHidden = false
//            buttonBook.isHidden = true
//        }
//        
//        if viewCtr.isEmpty {
//            return
//        } else {
//            let viewController = stboard.instantiateViewController(withIdentifier: viewCtr)
//            self.navigationController?.present(viewController, animated: false )
//        }
//    }
    
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
            let closestBeacon = knownBeacons[0] as CLBeacon
            let beaconMajor = Int(truncating: closestBeacon.major)
            self.mainTextView.textAlignment = NSTextAlignment.left
            self.finishTourBtn.isHidden = true
            
            switch beaconMajor {
            case 1:
                checkViewByBeacon = "gate"
                mainTextView.text = "Welcome to Tribal Tribal Media House Technology Lab. Tribal Media House is a marketing venture whose mission is to 'Create the future of marketing'. This DNA has been inherited. TMH Tech. Lab has been providing not only domestic-class, but also world-class Technology x Marketing solution. \n   Do you realize alphabet and special characters in ours logo? Yes, Marketing x Technnology!"
                mainImgView.image = UIImage(named: "logoTMH")
                buttonPrinter.isHidden = true
                buttonBook.isHidden = true
            case 2:
                checkViewByBeacon = "mission"
                mainTextView.text = "The world is awesome, so many things to discover. Ignite your passion and feel it. \n   There are some behaviour rules you should keep in mind. \n   Finally, be crazy! 😜. Crazy people are more likely to be successful. Why? To think out of box, too foolish to be scared, to have high energy and dare to break the rules."

                self.mainImgView.image = UIImage(named: "mission")
                buttonPrinter.isHidden = true
                buttonBook.isHidden = true
            case 3:
                mainTextView.text = "Here is 3d printer. Thanks to Jo president, we can play with it to relax and encourage creativity also. If you need tutorial, touch button below."
                mainImgView.image = UIImage(named: "component3dPrinter")
                checkViewByBeacon = "3dTutorial"
                buttonPrinter.isHidden = false
                buttonBook.isHidden = true
            default:
                checkViewByBeacon = "book"
                mainTextView.text = "This is open space where held morning meeting, fruit time or TechLab news and some special events like Christmas or women day. We also have lunch here or relax with shuttlecock. \n   Beside you there is ours bookshelf with various categories of books. Touch to button below to visit ours library and borrow book."
                mainImgView.image = UIImage(named: "bookshelf")
                buttonPrinter.isHidden = true
                buttonBook.isHidden = false
            }
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
