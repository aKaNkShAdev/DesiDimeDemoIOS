//
//  StringUtil.swift
//  DesidimeDemo
//
//  Created by Akanksha on 04/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import Foundation
import UIKit

extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)!
        self.init(attributedString.string)
    }
}


let encodedString = "The Weeknd <em>King Of The Fall</em>"
let decodedString = String(htmlEncodedString: encodedString)