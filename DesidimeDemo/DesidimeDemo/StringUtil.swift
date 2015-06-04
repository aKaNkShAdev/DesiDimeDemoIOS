//
//  StringUtil.swift
//  DesidimeDemo
//
//  Created by Akanksha on 04/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import Foundation
import UIKit

func html2String(html:String) -> String {
    let regex:NSRegularExpression  = NSRegularExpression(
        pattern: "<.*?>",
        options: NSRegularExpressionOptions.CaseInsensitive,
        error: nil)!
    
    
    let range = NSMakeRange(0, count(html))
    let htmlLessString :String = regex.stringByReplacingMatchesInString(html,
        options: NSMatchingOptions.allZeros,
        range:range ,
        withTemplate: "")
    return htmlLessString
}