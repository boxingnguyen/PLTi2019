//
//  Collection3dViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/21/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class Collection3dViewController: UIViewController {
    let imageNames = ["img1","img2","img3","img4","img5", "img6"]
    var currentImage = 0
    
    @IBOutlet var largeImgView: UIView!
    @IBOutlet weak var collectionCV: UICollectionView!
    @IBOutlet weak var largeImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        gestureSwipe()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(turnBack(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
        
        collectionCV.dataSource = self
        collectionCV.delegate = self
        
        let width = view.frame.size.width / 4
        let layout = collectionCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
    }
    
    @objc func turnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    func getCollection() {
        // call api to get collection
    }
    
    func gestureSwipe() {
        let left = UISwipeGestureRecognizer(target : self, action : #selector(self.leftSwipe))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target : self, action : #selector(self.rightSwipe))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        
    }
    
    @objc func rightSwipe() {
        print("dep trai")
    }
    
    @objc func leftSwipe() {
        print("dep trai")
        
    }

    @IBAction func backHome(_ sender: Any) {
        let stboard = UIStoryboard.init(name: "Main", bundle: nil)
        let loginVC = stboard.instantiateViewController(withIdentifier: "homeVC")
        self.navigationController?.pushViewController(loginVC, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Collection3dViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell

        cell.image.image = UIImage(named: self.imageNames[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // show pop up
        showLargeImg(index: indexPath.row)
        
    }
    
    func showLargeImg(index: Int) {
        self.view.addSubview(largeImg)
        largeImgView.center = self.view.center
        largeImgView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        largeImgView.alpha = 0
        
        largeImg.image = UIImage(named: imageNames[index])
        
        UIView.animate(withDuration: 0.4) {
            self.largeImgView.alpha = 1
            self.largeImgView.transform = CGAffineTransform.identity
        }
        
    }
}

