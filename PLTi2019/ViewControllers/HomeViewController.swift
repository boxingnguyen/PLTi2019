//
//  HomeViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/12/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var homeCV: UICollectionView!
    
    var menuArr = [[String]]()
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "FBD8D00D-C816-4F3C-9AA8-E162154943EC")! as UUID, identifier: "ibeacon")
    let colors = [456: UIColor.blue, 99: UIColor.green]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        DetectBeacon()
    }
    
    func setup() {
        background.image = UIImage(named: "menu")
        homeCV.dataSource = self
        homeCV.delegate = self
        
        menuArr.append([MenuTitle.visit.rawValue, "iconVisit"])
        menuArr.append([MenuTitle.book.rawValue, "iconBook"])
        menuArr.append([MenuTitle.printer.rawValue, "iconPrinter"])
        
        let width = view.frame.size.width
        let layout = homeCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 110)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func DetectBeacon() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startRangingBeacons(in: region)

    }
    
    func rangeBeacons() {
        let uuid = UUID(uuidString: "FBD8D00D-C816-4F3C-9AA8-E162154943EC")!
        let major:CLBeaconMajorValue = 123
        let minor:CLBeaconMinorValue = 456
        let identifier = "ibeacon"
        //        let region = CLBeaconRegion(proximityUUID: <#T##UUID#>, identifier: <#T##String#>)
        let region = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
        locationManager.startRangingBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // User has authorized the appplication - range those beacons!
            rangeBeacons()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let discoveredBeaconProximity = beacons.first?.proximity else { print("Couldn't find the beacon!"); return}
        let backgroundColor:UIColor = {
            switch discoveredBeaconProximity {
            case .immediate: return UIColor.green
            case .near: return UIColor.orange
            case .far: return UIColor.red
            case .unknown:return UIColor.black
            }
        }()
        
        view.backgroundColor = backgroundColor
    }
    
    //    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    //        let knownBeacons = beacons.filter { $0.proximity != CLProximity.unknown }
    //            if (knownBeacons.count > 0) {
    //                let closestBeacon = knownBeacons[0] as CLBeacon
    //                self.view.backgroundColor = self.colors[Int(truncating: closestBeacon.minor)]
    //            }
    //    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
        cell.menuTitle.text = menuArr[indexPath.row][0]
        cell.menuIcon.image = UIImage(named: menuArr[indexPath.row][1])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stboard = UIStoryboard.init(name: "Main", bundle: nil)
        let visitVC = stboard.instantiateViewController(withIdentifier: "visitVC")
        let bookshelfVC = stboard.instantiateViewController(withIdentifier: "bookshelfVC")
        let printer3dVC = stboard.instantiateViewController(withIdentifier: "printer3dVC")
        
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(visitVC, animated: true)
        case 1:
            self.navigationController?.pushViewController(bookshelfVC, animated: true)
        default:
            self.navigationController?.pushViewController(printer3dVC, animated: true)
        }
    }
}
