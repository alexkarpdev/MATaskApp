//
//  MovieCell.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 04.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    static let identifier = "MovieCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var ticketImageView: UIImageView!
    
    func configure(from movieItem: MovieItem) {
        posterImageView.image = movieItem.image
        titleLabel.text = movieItem.title
        homeImageView.isHidden = !movieItem.isHome
        ticketImageView.isHidden = !movieItem.isTicket
    }
    
}
