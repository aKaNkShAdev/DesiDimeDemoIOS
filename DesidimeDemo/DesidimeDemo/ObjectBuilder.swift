//
//  ObjectBuilder.swift
//  DesidimeDemo
//
//  Created by Akanksha Sharma on 03/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import UIKit

class ObjectBuilder: NSObject {
   
    
    func objectsFromJSON(data : NSData,jsonName : NSString,error :  NSErrorPointer) -> NSDictionary{
        var jsonObject: NSDictionary = NSDictionary()
        var objects : NSMutableArray = NSMutableArray()
        
        if(jsonName.isEqualToString("deals")){
            var error: NSError?
            var feeds: NSMutableArray = NSMutableArray()
            feeds = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as! NSMutableArray
            println(error)
            for item in feeds{
                var feedObj : Deal = Deal()
                let feed = item as! NSDictionary
                for (key, value) in feed {
                    if(feedObj.respondsToSelector(NSSelectorFromString(key as! String))){
                        feedObj.setValue(feed.objectForKey(key), forKey: key as! String)
                    }
                }
                println("Property: \"\(feedObj.id)\"")
                objects.addObject(feedObj)
            }
            var feedDict : NSDictionary = NSDictionary(object: objects, forKey: "deals")
            return feedDict
            
        }  else {
            var error: NSError?
            var jsonObject: NSDictionary = NSDictionary()
            jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSDictionary
            println(error)
            NSLog("%@",jsonObject)
            return jsonObject
            
        }
    }

}
