//
//  HomeViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/12/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var homeCV: UICollectionView!
    
    var menuArr = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        background.image = UIImage(named: "menu")
        homeCV.dataSource = self
        homeCV.delegate = self
        
        menuArr.append([MenuTitle.visit.rawValue, "iconVisit"])
        menuArr.append([MenuTitle.book.rawValue, "iconBook"])
        menuArr.append([MenuTitle.printer.rawValue, "iconPrinter"])
        
        self.navigationController?.navigationBar.isHidden = true
    }
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
