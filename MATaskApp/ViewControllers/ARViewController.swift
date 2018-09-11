//
//  ARViewController.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 08.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {
    
    var planeNode: SCNNode!
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var moviewNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var refButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //constraints

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "endLaunchLogo1024.png")
        planeNode = SCNNode(geometry: SCNPlane(width: 1, height: 1))
        planeNode.geometry!.firstMaterial?.diffuse.contents = image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
