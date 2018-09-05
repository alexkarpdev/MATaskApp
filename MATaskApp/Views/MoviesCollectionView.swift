//
//  MoviesCollectionView.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 04.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit

class MoviesCollectionView: UICollectionView {
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
    var movieItems = [MovieItem]() {
        didSet {
            self.reloadData()
        }
    }
    
    let leftSectionInset: CGFloat = 25.0
    let scrollVelocityMin: CGFloat = 0.5
    let hyperScrollLimit: CGFloat = 2.5
    
    var targetPoint = CGPoint()
    var isHyperScrolling = false
    var didStoppingCellNumber: Int = 0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    
    func configure() {
        let sizeKoef = collectionViewFlowLayout.itemSize.width / collectionViewFlowLayout.itemSize.height
        let cellSize = CGSize(width: frame.height * sizeKoef, height: frame.height)
        collectionViewFlowLayout.itemSize = cellSize
        
        let rightSectionInset = frame.width - collectionViewFlowLayout.itemSize.width - leftSectionInset
        collectionViewFlowLayout.sectionInset =  UIEdgeInsets(top: 0, left: leftSectionInset, bottom: 0, right: rightSectionInset)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
}

// MARK: - Data source

extension MoviesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        movieCell.configure(from: movieItems[indexPath.row])
        return movieCell
    }
}

// MARK: - Delegate

extension MoviesCollectionView: UICollectionViewDelegate {
    
}

// MARK: - Slide animation

extension MoviesCollectionView {
    
    func calculateWillStoppingCellNumber() -> Int {
        let countOfItems = movieItems.count
        let cellWidth = collectionViewFlowLayout.itemSize.width
        let lineSpacing = collectionViewFlowLayout.minimumLineSpacing
        let number = Int((contentOffset.x / (cellWidth + lineSpacing)).rounded())
        return max(0, min(countOfItems - 1, number))
    }
    
    func stopDeceleration(for scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: false)
    }
    
    func startSlideAnimation(velocity: CGPoint? = nil) {
        let willStoppingCellNumber = calculateWillStoppingCellNumber()
        let cellWidth = collectionViewFlowLayout.itemSize.width
        let lineSpacing = collectionViewFlowLayout.minimumLineSpacing
        
        var nextNumber = willStoppingCellNumber
        if !isHyperScrolling {
            let countOfItems = movieItems.count
            let canSlideNext = didStoppingCellNumber + 1 < countOfItems && velocity!.x > scrollVelocityMin
            let canSlideBack = didStoppingCellNumber - 1 >= 0 && velocity!.x < -scrollVelocityMin
            
            let isCellsAreSame = willStoppingCellNumber == didStoppingCellNumber
            let canSlide = isCellsAreSame && (canSlideNext || canSlideBack)
            
            nextNumber = canSlide ? (didStoppingCellNumber + (canSlideNext ? 1 : -1)) : willStoppingCellNumber
        }
        let toPoint = CGPoint(x: nextNumber * Int(cellWidth + lineSpacing), y: 0)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.contentOffset = toPoint
        }, completion: { position in
            self.didStoppingCellNumber = self.calculateWillStoppingCellNumber()
        })
    }
    
    // MARK: - Scrollview delegate methods
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.x.abs < hyperScrollLimit {
            isHyperScrolling = false
            targetContentOffset.pointee = scrollView.contentOffset
            startSlideAnimation(velocity: velocity)
        }else {
            isHyperScrolling = true
            targetPoint = targetContentOffset.pointee
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if !isHyperScrolling { stopDeceleration(for: scrollView) }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isHyperScrolling && (targetPoint.x - scrollView.contentOffset.x).abs < 20 {
            stopDeceleration(for: scrollView)
            startSlideAnimation()
        }
    }
}



















