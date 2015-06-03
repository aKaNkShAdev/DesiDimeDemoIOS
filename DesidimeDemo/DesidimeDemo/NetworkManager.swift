//
//  NetworkManager.swift
//  DesidimeDemo
//
//  Created by Akanksha Sharma on 03/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import Foundation

class NetworkManager: NSObject,NSURLConnectionDataDelegate,NSURLConnectionDelegate {
    var delegate: NetworkManagerDelegate?
    var responseData : NSMutableData?
    var jsonName : NSString =  ""
    var objectBuilder : ObjectBuilder = ObjectBuilder()

    
    func fetchDataRequest (request : NSURLRequest,jsonName : NSString){
        responseData = NSMutableData()
        self.jsonName = jsonName
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        
    }
    
    
    func stringByRemovingControlCharacters(inputString  :NSString) -> NSString{
        var controlChars : NSCharacterSet = NSCharacterSet.controlCharacterSet()
        var range : NSRange = inputString.rangeOfCharacterFromSet(controlChars)
        if(range.location != NSNotFound){
            var mutable : NSMutableString = NSMutableString(string: inputString)
            while(range.location != NSNotFound){
                mutable.deleteCharactersInRange(range)
                range = mutable.rangeOfCharacterFromSet(controlChars)
            }
            return mutable
        }
        return inputString
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse)
    { //It says the response started coming
        NSLog("didReceiveResponse :: \(response.MIMEType)")
        var httpResponse :NSHTTPURLResponse = response as! NSHTTPURLResponse
        var code : Int = httpResponse.statusCode
        if(code != 200){
            self.delegate?.didReceiveResponseCode(httpResponse)
            connection.cancel()
        }
        
    }
    
    func connection(connection: NSURLConnection, didReceiveData _data: NSData)
    { //This will be called again and again until you get the full response
        NSLog("didReceiveData")
        // Appending data
        self.responseData!.appendData(_data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        // This will be called when the data loading is finished i.e. there is no data left to be received and now you can process the data.
        NSLog("connectionDidFinishLoading")
        var responseStr:NSString = NSString(data:responseData!, encoding:NSUTF8StringEncoding)!
        var modifiedStr = self.stringByRemovingControlCharacters(responseStr)
        println(modifiedStr)
        var inputData :NSData = modifiedStr.dataUsingEncoding(NSUTF8StringEncoding)!
        self.didReceiveResponse(inputData, jsonName: jsonName)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError){
        self.requestFailedWithError(error)
    }
    
    /**
    Called when the response is received.
    */
    func didReceiveResponse(objectNotation : NSData, jsonName : NSString){
        var localErr : NSError?
        var responseDict : NSDictionary = objectBuilder.objectsFromJSON(objectNotation, jsonName: jsonName, error: &localErr)
        if !(localErr != nil){
            self.delegate?.didReceiveResponse(responseDict)
        } else {
            self.delegate?.requestFailedWithError(localErr!)
        }    }
    
    /**
    Called when the error is received.
    */
    func requestFailedWithError(error : NSError){
        self.delegate?.requestFailedWithError(error)
    }
    
    /**
    Handles the response according to the response code
    */
    func didReceiveResponseCode(response : NSHTTPURLResponse){
        self.delegate?.didReceiveResponseCode(response)
    }

    
    
}


protocol NetworkManagerDelegate{
    /**
    Called when the response is received.
    */
    func didReceiveResponse(objectNotation : NSDictionary)
    
    /**
    Called when the error is received.
    */
    func requestFailedWithError(error : NSError)
    
    /**
    Handles the response according to the response code
    */
    func didReceiveResponseCode(response : NSHTTPURLResponse)
}
