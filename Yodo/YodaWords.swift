//
//  YodaWords.swift
//  Yodo
//
//  Created by Isaac Albets Ramonet on 21/03/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import Foundation
import CoreData

class YodaWords: NSManagedObject{
    
    @NSManaged var wisdom: String
    @NSManaged var quote: Quote?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?){
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(wisdom: String, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("YodaWords", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.wisdom = wisdom
    }
}
