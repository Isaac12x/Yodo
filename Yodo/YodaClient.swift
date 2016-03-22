//
//  YodaClient.swift
//  Yodo
//
//  Created by Isaac Albets Ramonet on 15/03/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import Foundation

class YodaClient: NSObject {
    
    var session: NSURLSession!
    
    // MARK: Shared instance
    class func sharedInstance() -> YodaClient{
        struct Singleton {
            static let sharedInstance = YodaClient()
        }
        
        return Singleton.sharedInstance
    }
    
    override init(){
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    // MARK: - Task for resource
    
    func taskForGet(sentence: String, responseHandler: (result: AnyObject?, error: NSError?)-> Void){
        
        let newSentence = escapedForYoda(sentence)
        let params = [
            "sentence" : newSentence
        ]
        
        let urlString = Constants.URL + YodaClient.escapedParameters(params)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.setValue(Globals.HTTPHeaderValues.KeyValue, forHTTPHeaderField: Globals.HTTPHeaderKeys.MashapeKey )
        request.setValue(Globals.HTTPHeaderValues.Text, forHTTPHeaderField: Globals.HTTPHeaderKeys.Connection)
        
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) in
            
            
            guard error == nil else {
                responseHandler(result: nil, error: error)
                return
            }
            
            if let data = data {
                responseHandler(result: data, error: nil)
            } else {
                responseHandler(result: nil, error: error)
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
    
    
    func escapedForYoda(sentence: String) -> String{
        var sentencePlus = sentence
        sentencePlus = sentence.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return sentencePlus
    }
}
