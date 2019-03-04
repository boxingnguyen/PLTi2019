//
//  BookshelfViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/14/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class BookshelfViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var itemButtonLogin: UIBarButtonItem!
    
    @IBOutlet var borrowBookView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var bookCV: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // MARK: Property
    private let reuseIdentifier = "bookCell"
    var duration = Duration()
    var selectedBook = Book(id: "", name: "", author: "", image: "", catergory: .all, isBorrow: false, user_borrow_id: "")
    var booksArray = [Book]()
    var currentBooks = [Book]() // update book
    var chooseBooks = [Book]() //choose book
    var effect: UIVisualEffect!
    var selectedScopeIndex = 2
    var selectBookIndex: Int = 0 // get row selected for update array
    
    var indexPath: IndexPath?
    
    var itemCount: Int = 0
    
    var getEmailToCheck: String = ""
    var user_id: String = ""
    
    // MARK: System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicatorView.startAnimating()
        
        setupCollectionView()
        setupNavBar()
        setupBook()
        var maxDate = Date()
        maxDate.changeDays(by: 15)
        datePicker.maximumDate = maxDate
        
        var minDate = Date()
        minDate.changeDays(by: 1)
        datePicker.minimumDate = minDate
        
        datePicker.backgroundColor = .white
        datePicker.setValue(UIColor.red, forKey:"textColor")
        datePicker.tintColor = .white
        self.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc func turnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // check login
        let userDefault = UserDefaults.standard
        getEmailToCheck = userDefault.string(forKey: "email") ?? ""
        user_id = userDefault.string(forKey: "id") ?? ""
        
        self.tabBarController?.tabBar.isHidden = false
        
        if getEmailToCheck != "" {
            // show itembuttom Login
            itemButtonLogin.image = UIImage(named: "signOut")
        } else {
            // show itembuttom Logout
            itemButtonLogin.image = UIImage(named: "signIn")
        }
    }
    
    // MARK : Function
    func setupCollectionView() {
        let width = (view.frame.size.width - 30) / 2
        let layout = bookCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 240)
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        borrowBookView.layer.cornerRadius = 5
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        
        searchBar.delegate = self
        searchBar.placeholder = "book's name"
        searchBar.sizeToFit()
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Comics", "Fiction", "All", "Self-help", "Borrowed"]
        searchBar.selectedScopeButtonIndex = selectedScopeIndex
        self.navigationItem.title = "TMH TechLab Library"
        
        if visitMode {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(turnBack(_:)))
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.gray
        }
    }
    
    func setupBook() {
        ApiService.shared.apiListBooks(book_id: "", user_login: "", borrowDate: "", returnBook: "", success: { (books) in
            
            self.indicatorView.stopAnimating()
            
            self.indicatorView.isHidden = true
            guard books.count > 0 else {
                return
            }
            self.booksArray = books // (tap mượn, không mượn)
            
            self.currentBooks = books.filter({ (book) -> Bool in
                book.isBorrow == false  // không mượn sách
            })
            
            self.chooseBooks = books.filter({ (book) -> Bool in
                book.isBorrow == true  // mượn sách
            })
            
            self.itemCount = self.currentBooks.count
            
            self.bookCV.reloadData()
        }) { (err) in
            print("Error \(err.localizedDescription)")
        }
    }
    
    //MARK: SearchBar
    // after searchBar's text changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmedBook = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedBook.isEmpty else {
            self.filterBookByScope(selectedScope: self.selectedScopeIndex)
            return
        }
        
        self.filterBookByScope(selectedScope: self.selectedScopeIndex)
        self.currentBooks = self.booksArray.filter({ (Book) -> Bool in
            return Book.name.lowercased().contains(trimmedBook.lowercased())
        })
        
        self.itemCount = self.currentBooks.count
        self.bookCV.reloadData()
    }
    
    func filterBookByScope(selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentBooks = booksArray.filter({ (book) -> Bool in
                book.catergory == BookType.comics && book.isBorrow == false
                
            })
        case 1:
            currentBooks = booksArray.filter({ (book) -> Bool in
                book.catergory == BookType.fiction && book.isBorrow == false
            })
        case 2:
            currentBooks = booksArray.filter({ (book) -> Bool in
                book.isBorrow == false
            })
        case 3:
            currentBooks = booksArray.filter({ (book) -> Bool in
                book.catergory == BookType.selfHelf && book.isBorrow == false
            })
        case 4:
            currentBooks = chooseBooks
        default:
            break
        }
        
        self.itemCount = self.currentBooks.count
        self.bookCV.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.searchBar.text = ""
        self.selectedScopeIndex = selectedScope
        self.filterBookByScope(selectedScope: selectedScope)
    }
    
    // MARK: Button
    @IBAction func itemButtonLogin(_ sender: Any) {
        guard getEmailToCheck != "" else {
            // go to Login
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            return
        }
        // logout
        itemButtonLogin.image = UIImage(named: "signOut")
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: "user")
        userDefault.removeObject(forKey: "email")
        userDefault.removeObject(forKey: "id")
        
        getEmailToCheck = ""
    }
    
    @IBAction func dimissPopUp(_ sender: Any) {
        animateOut()
    }
 
    @IBAction func borrowBook(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy HH:mm"
        // send infor of selected book and duration to api
        var dateBook = "\(Date())"
        let calendar = Calendar.current
        var component = DateComponents()
        let components = calendar.dateComponents([.day,.month,.year, .hour, .minute], from: self.datePicker.date)
        if let day = components.day, let month = components.month, let year = components.year, let hour = components.hour, let minute = components.minute {
            component.day = day
            component.month = month
            component.year = year
            component.hour = hour
            component.minute = minute
            
            let componentToDate = calendar.date(from: component)!
            dateBook = dateFormatter.string(from: componentToDate)
        }
        
        // check return book
        if getEmailToCheck != "", user_id != "", selectedBook.isBorrow == false {
            animateOut()
            // save date_borrow to db
            ApiService.shared.apiListBooks(book_id: selectedBook.id, user_login: user_id, borrowDate: "", returnBook: dateBook, success: { (listBookBorrow) in
                print("Update database")
            }) { (err) in
                print("Error \(err.localizedDescription)")
            }
            let alert = UIAlertController(title: "", message: "You have successfully borrowed books", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.currentBooks = self.booksArray.filter({ (book) -> Bool in
                    book.id != self.selectedBook.id && book.isBorrow == false
                })
                
                // update bookArray
                for (index, element) in self.booksArray.enumerated() {
                    if element.id == self.selectedBook.id {
                        self.booksArray[index].isBorrow = true
                    }
                }
                
                self.bookCV.performBatchUpdates({
                    if self.indexPath != nil {
                        self.bookCV.deleteItems(at: [self.indexPath!])
                        self.itemCount -= 1
                    } else {
                        self.currentBooks[self.selectBookIndex].isBorrow = true
                        self.bookCV.reloadData()
                    }
                }, completion: nil)
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            // hide popUp
            animateOut()
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            loginViewController.selectBook = selectedBook
            loginViewController.delegate = self
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    
    @IBAction func backHome(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: animate
    func animateIn() {
        self.view.addSubview(borrowBookView)
        borrowBookView.center = self.view.center
        
        borrowBookView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        borrowBookView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.borrowBookView.alpha = 1
            self.borrowBookView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.0, animations: {
            self.borrowBookView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.borrowBookView.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            self.borrowBookView.removeFromSuperview()
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year, let hour = components.hour, let minute = components.minute {
            duration.day = day
            duration.month = month
            duration.year = year
            duration.hour = hour
            duration.minute = minute
        }
    }
}

//MARK: Extention
extension BookshelfViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! BookshelfCollectionViewCell
        
        cell.bookName.text = currentBooks[indexPath.row].name
        cell.author.text = currentBooks[indexPath.row].author
        let url = URL(string: currentBooks[indexPath.row].image)
        if url != nil {
            let data = try? Data(contentsOf: url!)
            cell.bookImg.image = UIImage(data: data!)
        } else {
            cell.bookImg.image = UIImage(named: "bookDefault")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.backgroundColor = UIColor.darkGray
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy HH:mm"
        let dateBook = dateFormatter.string(from: Date())
        
        // check return book
        if getEmailToCheck != "", user_id == self.currentBooks[indexPath.row].user_borrow_id, self.currentBooks[indexPath.row].isBorrow == true {
            // hide popUp
            animateOut()
            // show alert
            let alertVC = UIAlertController(title: "", message: "Do you want to return book", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                // sent request update return_date
                // save date_borrow to db
                ApiService.shared.apiListBooks(book_id: self.currentBooks[indexPath.row].id, user_login: self.user_id, borrowDate: "", returnBook: dateBook, success: { (listBookBorrow) in
                }) { (err) in
                    print("Error \(err.localizedDescription)")
                }
                
                self.bookCV.performBatchUpdates({
                    self.booksArray[indexPath.row].isBorrow = false // update isBorrow bookArray, show tap All
                    self.currentBooks.remove(at: (indexPath.row))
                    self.chooseBooks.remove(at: indexPath.row)
                    self.itemCount -= 1
                    self.bookCV.deleteItems(at: [indexPath])
                }, completion: nil)
                self.bookCV.reloadData()
                
            })
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            
        } else if self.currentBooks[indexPath.row].isBorrow == true {
            // hide popUp
            animateOut()
            // show alert
            let alertVC = UIAlertController(title: "", message: "This book will be returned at \(self.currentBooks[indexPath.row].date_return)", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        } else {
            // show popUp
            self.animateIn()
            
            self.selectBookIndex = indexPath.row
            
            self.indexPath = indexPath
            if getEmailToCheck != "" {
                self.selectedBook = currentBooks[indexPath.row]
                chooseBooks.append(currentBooks[indexPath.row])
            } else {
                chooseBooks.removeAll()
            }
        }
    }
}

extension BookshelfViewController: selectBookDelegate {
    func chooseBookReload(_ result: Book) {
        if result.name != "" {
            chooseBooks.append(result)
        }
    }
}

