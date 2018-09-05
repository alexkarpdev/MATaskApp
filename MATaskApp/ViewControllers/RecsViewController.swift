//
//  RecsViewController.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 04.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit

class RecsViewController: UIViewController {
    
    @IBOutlet weak var movieCollectionView: MoviesCollectionView!

    let moviesCount = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure() {
        //movieCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        movieCollectionView.movieItems = DBController.prepareData(for: moviesCount)
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
