//
//  MemberTableViewController.swift
//  CGAapps
//
//  Created by user on 17/5/2017.
//  Copyright © 2017年 AppCoda. All rights reserved.
//

import UIKit


class MemberTableViewController: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var memberTable: UITableView!
    
    var xMembers:[Members]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Members")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        

        let sTitle = NSLocalizedString("Welcome", comment:"")
        self.title = sTitle
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //memberTable.delegate = self
        //memberTable.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.printLang()
        
        xMembers = DBManager.shared.loadRec()
        for mm in xMembers! {
            
            print(mm.loginID, mm.deviceOwner, mm.nickname, mm.picture_url, mm.title, mm.urlname)
            
            
        }
        

        memberTable.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
           return (xMembers != nil) ? xMembers.count : 0
        // return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> memberTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! memberTableViewCell
      
        let currentMovie = xMembers[indexPath.row]
        
        cell.postTitleLabel?.text = currentMovie.nickname
        cell.authorLabel?.text = currentMovie.urlname
        cell.postImageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: URL(string: currentMovie.picture_url)!, completionHandler: { (imageData, response, error) in
            if let data = imageData {
                DispatchQueue.main.async {
                    cell.postImageView?.image = UIImage(data: data)
                    cell.layoutSubviews()
                }
            }
        }).resume()
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 243.0
    }
    
    func printLang(){
        
        print("new lang 1:", self.currentAppleLanguage())
        UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        print("new lang 2:", self.currentAppleLanguage())
    
    }
    func currentAppleLanguage() -> String{
        let APPLE_LANGUAGE_KEY = "AppleLanguages"
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        let endIndex = current.startIndex
        let currentWithoutLocale = current.substring(to: current.index(endIndex, offsetBy: 2))
        return currentWithoutLocale
    }
 
}
