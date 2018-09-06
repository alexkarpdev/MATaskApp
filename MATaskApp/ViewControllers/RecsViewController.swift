//
//  RecsViewController.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 04.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit

class RecsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var movieCollectionView: MoviesCollectionView!
    @IBOutlet weak var wantALbel: ALabel!
    @IBOutlet weak var watchALable: ALabel!
    @IBOutlet weak var likeALabel: ALabel!
    @IBOutlet weak var aLabelHeightConstraint: NSLayoutConstraint!
    
    let moviesCount = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure() {
        watchALable.heightConstraint = aLabelHeightConstraint
        movieCollectionView.configure(movieItems: DBController.prepareData(for: moviesCount), aLabels: [wantALbel, watchALable, likeALabel])
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

