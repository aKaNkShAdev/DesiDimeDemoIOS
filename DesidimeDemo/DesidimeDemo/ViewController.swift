//
//  ViewController.swift
//  DesidimeDemo
//
//  Created by Akanksha Sharma on 03/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,NetworkManagerDelegate {
    
    //IBOutlets
    @IBOutlet weak var dealTable: UITableView!
    @IBOutlet weak var popularTable: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
    @IBOutlet weak var popularDealsBTn: UIButton!
    @IBOutlet weak var popularBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var topBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var popularTblWidth: NSLayoutConstraint!
    
    @IBOutlet weak var topDealsBtn: UIButton!
    
    var commonUtil : CommonUtil  = CommonUtil()
    var currentFetch = ""
    var networkManager : NetworkManager = NetworkManager()
    var topDeals : NSMutableArray = NSMutableArray()
    var popularDeals : NSMutableArray = NSMutableArray()
    var imageCache = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        commonUtil.showActivityIndicator(self.view)
        fetchTopDeals()
        mainViewWidth.constant = self.view.frame.width * 2
        popularTblWidth.constant = self.view.frame.width - 20
        popularBtnWidth.constant = self.view.frame.width / 2
        topBtnWidth.constant = self.view.frame.width / 2

        //fetchPopularDeals()
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
    }
    
    override func viewDidLayoutSubviews() {
        //popularTable.center = CGPointMake(popularTable.center.x + popularTable.frame.width, popularTable.center.y)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TABLEVIEW DELEGATE METHODS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell : DealCellTableViewCell = DealCellTableViewCell()
        var deal : Deal = Deal()

        if(tableView == dealTable){
            cell = tableView.dequeueReusableCellWithIdentifier("DealCell", forIndexPath: indexPath) as! DealCellTableViewCell
            deal = topDeals.objectAtIndex(indexPath.section) as! Deal

        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("PopularDealCell", forIndexPath: indexPath) as! DealCellTableViewCell
            deal = popularDeals.objectAtIndex(indexPath.section) as! Deal
        }
        
        cell.dealTitle.text = deal.title  as String
        //cell.dealDescription.text = String(htmlEncodedString: deal.deal_detail as String)
       // cell.dealDescription.text = deal.deal_detail as String
        cell.dealDescription.text = html2String(deal.deal_detail as String)
        cell.dealImage?.image = UIImage(named: "default_deal.png")
        
        // If this image is already cached, don't re-download
        var urlString = deal.image_thumb as String
        var imgURL = NSURL(string: urlString)
        
        if let img = imageCache[deal.image_thumb as String] {
            cell.dealImage?.image = img
        }
        else {
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            let request: NSURLRequest = NSURLRequest(URL: imgURL!)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        if var cellToUpdate  = tableView.cellForRowAtIndexPath(indexPath) as? DealCellTableViewCell {
                            cellToUpdate.dealImage?.image = image
                            //cellToUpdate.imageView?.frame = cell.dealImage.frame
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        return cell;

        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if(tableView == dealTable){
            return topDeals.count
        } else {
            return popularDeals.count
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 5
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 5
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            showPopularDeals(sender)
        }
        
        if (sender.direction == .Right) {
            showTopDeals(sender)
        }
    }
    
    
    @IBAction func showTopDeals(sender: AnyObject) {

        UIView.animateWithDuration(1 as NSTimeInterval, animations: {
            self.mainView.center = CGPointMake(self.view.frame.width, self.mainView.center.y)
            }, completion: {
                finished in
                self.topDealsBtn.backgroundColor = UIColor(red:58/255.0, green:102/255.0, blue:200/255.0, alpha:1)
                self.topDealsBtn.tintColor = UIColor.whiteColor()
                self.popularDealsBTn.backgroundColor = UIColor.whiteColor()
                self.popularDealsBTn.tintColor = UIColor.blackColor()
        })
    }
    
    
    @IBAction func showPopularDeals(sender: AnyObject) {

        UIView.animateWithDuration(1 as NSTimeInterval, animations: {
            self.mainView.center = CGPointMake(0, self.mainView.center.y)
            
            }, completion: {
                finished in
                self.topDealsBtn.backgroundColor = UIColor.whiteColor()
                self.topDealsBtn.tintColor = UIColor.blackColor()
                self.popularDealsBTn.backgroundColor = UIColor(red:58/255.0, green:102/255.0, blue:200/255.0, alpha:1)
                self.popularDealsBTn.tintColor = UIColor.whiteColor()
            
        })

    }

    func fetchTopDeals(){
        currentFetch = "top"
        var url : NSString = NSString(string: topDealsURL)
        var urlRequest : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url as String)!)
        urlRequest.setValue(accessTokenValue, forHTTPHeaderField:accessTokenKey)
        networkManager.fetchDataRequest(urlRequest, jsonName: "deals")
    }
    
    func fetchPopularDeals(){
        currentFetch = "popular"
        var url : NSString = NSString(string: popularDealsURL)
        var urlRequest : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url as String)!)
        urlRequest.setValue(accessTokenValue, forHTTPHeaderField:accessTokenKey)
        networkManager.fetchDataRequest(urlRequest, jsonName: "deals")
    }
    
    /**
    Called when the response is received.
    */
    func didReceiveResponse(responseDict : NSDictionary){
        //println(responseDict)
        if(currentFetch == "top"){
            println("top")
            topDeals = responseDict["deals"] as! NSMutableArray
            dealTable.reloadData()
            fetchPopularDeals()
        } else {
            println("popular")
            popularDeals = responseDict["deals"] as! NSMutableArray
            popularTable.reloadData()
            commonUtil.hideActivityIndicator(self.view)
        }
        
    }
    
    /**
    Called when the error is received.
    */
    func requestFailedWithError(error : NSError){
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "Request could not be completed due to network issues"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    /**
    Handles the response according to the response code
    */
    func didReceiveResponseCode(response : NSHTTPURLResponse){
        if(response.statusCode != 200){
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Request is not authorized"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    //Making the default layout as Potrait
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
}

