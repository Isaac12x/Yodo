//
//  AndruxClient.swift
//  Yodo
//
//  Created by Isaac Albets Ramonet on 20/03/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import Foundation

class AndruxClient : NSObject {
    
    var session: NSURLSession!
    
    // MARK: Shared instance
    class func sharedInstance() -> AndruxClient {
        
        struct Singleton {
            static let sharedInstance = AndruxClient()
        }
        
        return Singleton.sharedInstance
    }
    
    override init(){
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    // MARK: - Task for resource
    
    func taskForGet(responseHandler: (response: [String:AnyObject]?, error: NSError?)-> Void){
        
        let params = [
            HTTPParameterKeys.URLParams : HTTPParameterValues.Famous
        ]
        
        let urlString = Constants.URL + AndruxClient.escapedParameters(params)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(Globals.HTTPHeaderValues.KeyValue, forHTTPHeaderField: Globals.HTTPHeaderKeys.MashapeKey)
        
        request.setValue(Globals.HTTPHeaderValues.ContentValue, forHTTPHeaderField: Globals.HTTPHeaderKeys.ContentType)
        request.setValue(Globals.HTTPHeaderValues.JSON, forHTTPHeaderField: Globals.HTTPHeaderKeys.Connection)
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) in
            
            
            guard error == nil else {
                responseHandler(response: nil, error: error)
                return
            }
            
            if let data = data {
                let jsonDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
                responseHandler(response: jsonDictionary, error: nil)
            } else {
                responseHandler(response: nil, error: error)
            }
            
        }
        task.resume()
        
    }

    /* Helpers */

    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            // make sure that it is a string value
            let stringValue = "\(value)"
            
            // Escape it
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            // Append it
            
            if let unwrappedEscapedValue = escapedValue {
                urlVars += [key + "=" + "\(unwrappedEscapedValue)"]
            } else {
                print("Warning: trouble excaping string \"\(stringValue)\"")
            }
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
}