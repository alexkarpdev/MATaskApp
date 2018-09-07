//
//  FirstViewController.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 07.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animation()
        
    }
    
    func animation() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [.curveEaseIn], animations: { [unowned self] in
            self.logoImageView.alpha = 0
        }) { [unowned self] (position) in
            self.performSegue(withIdentifier: "next", sender: nil)
        }
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
