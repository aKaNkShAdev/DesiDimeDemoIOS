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
    @IBOutlet var popularTableWidth: [NSLayoutConstraint]!
    @IBOutlet weak var mainView: UIView!
    
    var commonUtil : CommonUtil  = CommonUtil()
    var currentFetch = ""
    var networkManager : NetworkManager = NetworkManager()
    var topDeals : NSMutableArray = NSMutableArray()
    var popularDeals : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        //commonUtil.showActivityIndicator(self.view)
        fetchTopDeals()
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
        if(tableView == dealTable){
            var cell : DealCellTableViewCell = DealCellTableViewCell()
            
            cell = tableView.dequeueReusableCellWithIdentifier("DealCell", forIndexPath: indexPath) as! DealCellTableViewCell
            cell.dealTitle.text = "top deal"
            var deal : Deal = topDeals.objectAtIndex(indexPath.section) as! Deal
            cell.dealTitle.text = deal.title  as String
            cell.dealDescription.text = String(htmlEncodedString: deal.deal_detail as String)
            cell.dealImage?.image = commonUtil.getImageFromURL(deal.image_thumb as String)
            return cell;
        } else {
            var cell : DealCellTableViewCell = DealCellTableViewCell()
            
            cell = tableView.dequeueReusableCellWithIdentifier("PopularDealCell", forIndexPath: indexPath) as! DealCellTableViewCell
            cell.dealTitle.text = "popular"
            var deal : Deal = popularDeals.objectAtIndex(indexPath.section) as! Deal
            cell.dealTitle.text = deal.title  as String
            cell.dealDescription.text = String(htmlEncodedString: deal.deal_detail as String)
            cell.dealImage?.image = commonUtil.getImageFromURL(deal.image_thumb as String)
            return cell;
        }
        
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
            UIView.animateWithDuration(1 as NSTimeInterval, animations: {
                self.mainView.center = CGPointMake(0, self.mainView.center.y)
                
                }, completion: {
                    finished in
            })
        }
        
        if (sender.direction == .Right) {
            UIView.animateWithDuration(1 as NSTimeInterval, animations: {
                self.mainView.center = CGPointMake(self.view.frame.width, self.mainView.center.y)
                }, completion: {
                    finished in
            })
        }
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
        //commonUtil.hideActivityIndicator(self.view)
        if(currentFetch == "top"){
            println("top")
            topDeals = responseDict["deals"] as! NSMutableArray
            dealTable.reloadData()
            fetchPopularDeals()
        } else {
            println("popular")
            popularDeals = responseDict["deals"] as! NSMutableArray
            popularTable.reloadData()
        }
        
    }
    
    /**
    Called when the error is received.
    */
    func requestFailedWithError(error : NSError){
        
    }
    
    /**
    Handles the response according to the response code
    */
    func didReceiveResponseCode(response : NSHTTPURLResponse){
        
    }
    
}

