//
//  ViewController.swift
//  DesidimeDemo
//
//  Created by Akanksha Sharma on 03/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //IBOutlets
    @IBOutlet weak var dealTable: UITableView!
    @IBOutlet weak var popularTable: UITableView!
    @IBOutlet var popularTableWidth: [NSLayoutConstraint]!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
    }

    override func viewDidLayoutSubviews() {
        popularTable.center = CGPointMake(popularTable.center.x + popularTable.frame.width, popularTable.center.y)
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
        var cell : DealCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("DealCell", forIndexPath: indexPath) as! DealCellTableViewCell
        return cell;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 5
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 5
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            UIView.animateWithDuration(0.5 as NSTimeInterval, animations: {
                self.mainView.center = CGPointMake(self.mainView.center.x - self.mainView.frame.width, self.mainView.center.y)

                }, completion: {
                    finished in
            })
        }
        
        if (sender.direction == .Right) {
            UIView.animateWithDuration(0.5 as NSTimeInterval, animations: {
                self.mainView.center = CGPointMake(self.mainView.center.x + self.mainView.frame.width, self.mainView.center.y)
                }, completion: {
                    finished in
            })
        }
    }

}

