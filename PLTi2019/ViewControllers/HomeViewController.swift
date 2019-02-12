//
//  HomeViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/12/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var bookCV: UICollectionView!
    private let reuseIdentifier = "bookCell"
    
    var arrayBooks:[[String]] = [["Nhà giả kim", "Paulo Coelho", "book1"], ["Ngẫu hứng Trần Tiến", "Trần Tiến", "book2"], ["Hoàng Lê thống chí", "Ngô gia văn phái", "book3"], ["Hoàng Lê thống chí", "Ngô gia văn phái", "book3"], ["Hoàng Lê thống chí", "Ngô gia văn phái", "book3"], ["Hoàng Lê thống chí", "Ngô gia văn phái", "book3"], ["Hoàng Lê thống chí", "Ngô gia văn phái", "book3"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        let width = (view.frame.size.width - 30) / 2
        let layout = bookCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 280)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! HomeCollectionViewCell

        cell.bookName.text = arrayBooks[indexPath.row][0]
        cell.author.text = arrayBooks[indexPath.row][1]
        cell.bookImg.image = UIImage(named: arrayBooks[indexPath.row][2])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        //Briefly fade the cell on selection
        UIView.animate(withDuration: 0.5,
                       animations: {
                        //Fade-out
                        cell?.alpha = 0.5
        })
//        { (completed) in
//            UIView.animate(withDuration: 0.5,
//                           animations: {
//                            //Fade-out
//                            cell?.alpha = 1
//            })
//        }

        let alert = UIAlertController(title: "Alert", message: "Do you want to ", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
}
