//
//  Collection3dViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/21/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit
import ImageViewer

extension UIImageView: DisplaceableView {}

struct DataItem {
    let imageView: UIImageView
    let galleryItem: GalleryItem
}

class Image3dPrinterViewController: UIViewController {
    let imageNames = ["img1","img2","img3","img4","img5", "img6"]
    var currentImage = 0
    
    @IBOutlet weak var collectionCV: UICollectionView!
    @IBOutlet weak var largeImg: UIImageView!
    @IBOutlet var largeImgView: UIView!
    
    var items: [DataItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        var galleryItem: GalleryItem!
        
//        largeImg.downloaded(from: "http://192.168.0.12/api/app/webroot/img/10.JPG")
        
        for i in 5...24 {
            var imgName = String(i)
            
            if i < 10 {
                imgName = "0" + imgName
            }
            
            let url = URL(string: "http://192.168.0.12/api/app/webroot/img/\(imgName).JPG")
            
            if url != nil {
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                
                galleryItem = GalleryItem.image { $0(image) }
                items.append(DataItem(imageView: largeImg, galleryItem: galleryItem))
            }
        }
            
       
    }
    
    func setupView() {
        collectionCV.dataSource = self
        collectionCV.delegate = self
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(turnBack(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
        
        let width = view.frame.size.width / 4
        let layout = collectionCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    @objc func turnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
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

//MARK: Extention collection view
extension Image3dPrinterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! Collection3dViewCell

//        cell.image3d.image = UIImage(named: self.imageNames[indexPath.row])
        
        var imgName = String(indexPath.row + 5)
        
        if indexPath.row < 5 {
            imgName = "0" + imgName
        }
        
        let url = URL(string: "http://192.168.0.12/api/app/webroot/img/\(imgName).JPG")

        if url != nil {
            let data = try? Data(contentsOf: url!)
            cell.image3d.image = UIImage(data: data!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showImage(index: indexPath.row)
        
    }
    
    func showImage(index: Int) {
        let displacedViewIndex: Int = index
        let frame = CGRect(x: 0, y: 0, width: 200, height: 24)
        let footerView = CounterView(frame: frame, currentIndex: displacedViewIndex, count: items.count)
        let galleryViewController = GalleryViewController(startIndex: displacedViewIndex, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: self, configuration: galleryConfiguration())

        galleryViewController.footerView = footerView
        
        galleryViewController.launchedCompletion = { print("LAUNCHED") }
        galleryViewController.closedCompletion = { print("CLOSED") }
        galleryViewController.swipedToDismissCompletion = { print("SWIPE-DISMISSED") }
        galleryViewController.landedPageAtIndexCompletion = { index in
            
        print("LANDED AT INDEX: \(index)")
            
//            headerView.count = self.items.count
//            headerView.currentIndex = index
            footerView.count = self.items.count
            footerView.currentIndex = index
        }
        
        self.presentImageGallery(galleryViewController)
    }
    
    func galleryConfiguration() -> GalleryConfiguration {
        return [
            
            // Remove two buttons 'Delete' & 'Show all'
            GalleryConfigurationItem.deleteButtonMode(ButtonMode.none),
            GalleryConfigurationItem.thumbnailsButtonMode(ButtonMode.builtIn),
            
            // Disable bluring background while ImageViewer dismiss
            GalleryConfigurationItem.overlayBlurOpacity(0),
            
            // Disable bounce
            GalleryConfigurationItem.displacementTransitionStyle(GalleryDisplacementStyle.normal),

            GalleryConfigurationItem.reverseDisplacementDuration(0.2),
            GalleryConfigurationItem.colorDismissDuration(0.2),
            
            // Disable bounce
            GalleryConfigurationItem.displacementTransitionStyle(GalleryDisplacementStyle.normal),
        ]
    }
}

extension Image3dPrinterViewController: GalleryDisplacedViewsDataSource {
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
//        print("items[index].imageView \(items[index].imageView)")
        return index < items.count ? items[index].imageView : nil
    }
}

extension Image3dPrinterViewController: GalleryItemsDataSource {
    
    func itemCount() -> Int {
        
        return items.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        
        return items[index].galleryItem
    }
}

extension Image3dPrinterViewController: GalleryItemsDelegate {
    
    func removeGalleryItem(at index: Int) {
        
        print("remove item at \(index)")
        
        let imageView = items[index].imageView
        imageView.removeFromSuperview()
        items.remove(at: index)
    }
}

// Some external custom UIImageView we want to show in the gallery
class FLSomeAnimatedImage: UIImageView {
}

// Extend ImageBaseController so we get all the functionality for free
class AnimatedViewController: ItemBaseController<FLSomeAnimatedImage> {
}
