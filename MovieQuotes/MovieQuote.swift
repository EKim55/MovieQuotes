//
//  MovieQuote.swift
//  MovieQuotes
//
//  Created by CSSE Department on 3/29/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit

class MovieQuote: NSObject {
    var quote: String
    var movie: String
    
    init(quote:String, movie:String) {
        self.quote = quote
        self.movie = movie
    }
}
