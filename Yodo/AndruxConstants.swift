//
//  AndruxConstants.swift
//  Yodo
//
//  Created by Isaac Albets Ramonet on 20/03/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import Foundation

extension AndruxClient {

    struct Constants {
        static let URL = "https://andruxnet-random-famous-quotes.p.mashape.com/"
    }
    
    struct HTTPParameterKeys {
        static let URLParams = "cat"
    }
    
    struct HTTPParameterValues {
        static let Movies = "movies"
        static let Famous = "famous"
    }
    
    struct JSONResponseKeys {
        static let Quote = "quote"
        static let Author = "author"
        static let Category = "category"
    }

}