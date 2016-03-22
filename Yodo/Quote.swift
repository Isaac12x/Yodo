//
//  Quote.swift
//  Yodo
//
//  Created by Isaac Albets Ramonet on 19/03/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import Foundation
import CoreData

class Quote: NSManagedObject{
    
    struct Keys {
        static let Author = "author"
        static let Quote = "quote"
        static let Category = "category"
    }
    
    @NSManaged var quoteAuthor: String
    @NSManaged var quoteContent: String
    @NSManaged var quoteCategory: String
    @NSManaged var yodaWords: YodaWords?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?){
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Quote", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        quoteAuthor = dictionary[AndruxClient.JSONResponseKeys.Author] as! String
        quoteContent = dictionary[AndruxClient.JSONResponseKeys.Quote] as! String
        quoteCategory = dictionary[AndruxClient.JSONResponseKeys.Category] as! String
    }


}