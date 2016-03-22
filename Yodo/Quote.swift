//
//  Quote.swift
//  Yodo
//
//  Created by Isaac Albets Ramonet on 19/03/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import Foundation
import CoreData

class Quote{
    
    var quoteAuthor: String
    var quoteContent: String
    var quoteCategory: String

    init(dictionary: [String : AnyObject]) {
        
        quoteAuthor = dictionary[AndruxClient.JSONResponseKeys.Author] as! String
        quoteContent = dictionary[AndruxClient.JSONResponseKeys.Quote] as! String
        quoteCategory = dictionary[AndruxClient.JSONResponseKeys.Category] as! String
    }


}