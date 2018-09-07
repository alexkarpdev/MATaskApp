//
//  DBController.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 04.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

class DBController {
    
    static func prepareData(for count: Int) -> [MovieItem] {
        
        let titles = ["Based on your rate for ‘Interstellar’",
                      "New season this week",
                      "376 of your friends wantto watch this movie",
                      "Sequel for movie you’ve loved",
                      "Based on novel"]
        
        let posterImages = (0..<titles.count).map { (i) -> UIImage in
            let posterName = "Poster " + String(format: "%03d", i)
            guard let image = UIImage(named: posterName) else { fatalError("Don't found poster with name: \"\(posterName)\"") }
            return image
        }
        
        return (0..<count).map { (i) -> MovieItem in
            let val = 10.rnd
            return MovieItem(title: titles[titles.count.rnd],
                             image: posterImages[posterImages.count.rnd],
                             isHome: val > 6,
                             isTicket: val > 4)
        }
    }
    
}
