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
    let hyperScrollLimit: CGFloat = 2.2
    
    var targetPoint = CGPoint()
    var isHyperScrolling = false
    var didStoppingCellNumber: Int = 0
    
    var animationController: AnimationController!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    
    func configure() {

        animationController = AnimationController(collectionView: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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

// MARK: - Delegate

extension MoviesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeKoef = collectionViewFlowLayout.itemSize.width / collectionViewFlowLayout.itemSize.height
        let cellSize = CGSize(width: (frame.height * sizeKoef).rounded(), height: frame.height)
        collectionViewFlowLayout.itemSize = cellSize
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let rightSectionInset = frame.width - collectionViewFlowLayout.itemSize.width - leftSectionInset
        let edgeInsets = UIEdgeInsets(top: 0, left: leftSectionInset, bottom: 0, right: rightSectionInset)
        collectionViewFlowLayout.sectionInset = edgeInsets
        return edgeInsets
    }
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
            //self.contentOffset = toPoint
            self.didStoppingCellNumber = self.calculateWillStoppingCellNumber()
            //self.animationController.cellView = (self.cellForItem(at: IndexPath(row: self.didStoppingCellNumber, section: 0)) as! MovieCell).posterImageView
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



















