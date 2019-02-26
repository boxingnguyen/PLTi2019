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
    let major:CLBeaconMajorValue = 123
    let identifier = "TMH.beacon"
    let colors = [0: UIColor.purple, 1: UIColor.blue, 2: UIColor.green, 3:UIColor.orange]
    let viewIdentifier = [0: "", 1: "", 2: "bookshelfVC", 3: "printer3dVC"]
    
    @IBOutlet weak var buttonBook: UIButton!
    @IBOutlet weak var buttonPrinter: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // go around techlab
        visitMode = true
        
        setupView()
        DetectBeacon()
        buttonBook.isHidden = true
        buttonPrinter.isHidden = true
    }
    
    func setupView() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Let's go around!"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "home"), style: .plain, target: self, action: #selector(turnBack(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let stboard = UIStoryboard.init(name: "Main", bundle: nil)
        var viewCtr = String()
        
        if checkViewByBeacon == "book" {
            viewCtr = "bookshelfVC"
            buttonPrinter.isHidden = true
            buttonBook.isHidden = false
        } else if checkViewByBeacon == "3dTutorial" {
            viewCtr = "printer3dVC"
            buttonPrinter.isHidden = false
            buttonBook.isHidden = true
        }
        
        if viewCtr.isEmpty {
            return
        } else {
            let viewController = stboard.instantiateViewController(withIdentifier: viewCtr)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func DetectBeacon() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
        
        rangeBeacons()
    }
    
    func rangeBeacons() {
        let region = CLBeaconRegion(proximityUUID: uuid, major: major, identifier: identifier)
        locationManager.startRangingBeacons(in: region)

        //        run at background then notify
        //        locationManager.startMonitoring(for: region)
        
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
        
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            let beaconMinor = Int(truncating: closestBeacon.minor)
        
            switch beaconMinor {
            case 1:
                checkViewByBeacon = "gate"
            case 2:
                checkViewByBeacon = "book"
                
            case 3:
                checkViewByBeacon = "3dTutorial"
            default:
                checkViewByBeacon = "mission"
            }
        }
        
        guard let discoveredBeaconProximity = beacons.first?.proximity else { print("Couldn't find the beacon!"); return}
        let notification:String = {
            switch discoveredBeaconProximity {
            case .immediate: return "immediate"
            case .near: return "near"
            case .far: return "far"
            case .unknown: return "unknown"
            }
        }()

        print(notification)
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
    
}
