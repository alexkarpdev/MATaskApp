//
//  MoviesCollectionView.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 04.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit

class MoviesCollectionView: UICollectionView {

    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
    private var movieItems = [MovieItem]() {
        didSet {
            reloadData()
        }
    }
    
    private let scrollVelocityMin: CGFloat = 0.5
    private let hyperScrollLimit: CGFloat = 2.2
    private var targetPoint = CGPoint()
    private var isHyperScrolling = false
    private var slideAnimator = UIViewPropertyAnimator()
    private var didStoppingCellNumber: Int = -1
    private var animationController: AnimationController!
    
    public let leftSectionInset: CGFloat = 25.0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    
    public func configure(movieItems: [MovieItem], aLabels: [ALabel]) {
        self.movieItems = movieItems
        animationController = AnimationController(collectionView: self, aLabels: aLabels) { [unowned self] isLock in
            self.isScrollEnabled = !isLock
        }
        
    }
    
    func assignCellForAnimating(for number:Int) {
        if let movieCell = cellForItem(at: IndexPath(row: number, section: 0)) as! MovieCell? {
            animationController.movedImageView = movieCell.posterImageView
            animationController.cellPanelView = movieCell.panelView
        }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if didStoppingCellNumber == -1 {
            performBatchUpdates({self.reloadSections([0])}, completion: {
                (result) in
                if result {
                    self.didStoppingCellNumber = 0
                    self.assignCellForAnimating(for: 0)
                    print("test")
                }
            })
        }
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
        isHyperScrolling = false
        let toPoint = CGPoint(x: nextNumber * Int(cellWidth + lineSpacing), y: 0)
        
        slideAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: {
            self.contentOffset = toPoint
        })
        slideAnimator.addCompletion(){ position in
            if position == .end {
                self.animationController.panGestureRecognizer.isEnabled = true
                self.assignCellForAnimating(for: nextNumber)
                UISelectionFeedbackGenerator().selectionChanged()
                self.didStoppingCellNumber = self.calculateWillStoppingCellNumber()
            }
        }
        slideAnimator.startAnimation()

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
        animationController.panGestureRecognizer.isEnabled = false
        if isHyperScrolling && (targetPoint.x - scrollView.contentOffset.x).abs < 50 {
            stopDeceleration(for: scrollView)
            startSlideAnimation()
        }
    }
    
}






















