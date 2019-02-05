//
//  ARViewController.swift
//  DriftWatchAR
//
//  Created by Govindarajan Anand on 12/7/17.
//  Copyright © 2017 Govindarajan Anand. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import CoreLocation

class ARViewController: UIViewController {
    @IBOutlet var sceneView: ARSKView!
    
    var userLocation: CLLocation?
    var userHeading: Double?
    var driftWatches:[Place] = []
    var driftWatchProvider = DriftWatchProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driftWatches = driftWatchProvider.getDriftWatches()
        initializeARScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = AROrientationTrackingConfiguration()
        sceneView.session.run(configuration)
        
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.showDriftWatches()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ARViewController: ARSKViewDelegate {
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        
       let place = driftWatches.filter{ $0.identifer == anchor.identifier }.first
        let labelNode = SKLabelNode(text: place?.name)
        labelNode.fontSize = 12
        labelNode.fontColor = UIColor.black
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        
        //scale up the label's size so we have some margin
        let size = labelNode.frame.size
        
        //create a background node using the new size, rounding its corners gently
        let backgroundNode = SKShapeNode(rectOf: size, cornerRadius: 1)
        
        //draw a border around it using a more opaque version of its fill color
        backgroundNode.strokeColor = backgroundNode.fillColor.withAlphaComponent(1)
        backgroundNode.fillColor = UIColor.white
        backgroundNode.lineWidth = 1
        
        //add the label to the background then send back the backgorund
        backgroundNode.addChild(labelNode)
        return backgroundNode
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
}

private extension ARViewController {
    
    func initializeARScene() {
        sceneView.delegate = self
        if let scene = SKScene(fileNamed: "DriftWatchScene") {
            sceneView.presentScene(scene)
        }
    }
    
    func showDriftWatches() {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        // Create anchor using the camera's current position
        if sceneView.session.currentFrame != nil {
            
            for place in driftWatches {
                
                if let currentLocation = userLocation, let heading = userHeading {
                    let azimuthFromUser = Utility.direction(from: currentLocation, to: place.location)
                   // let distance = Float(currentLocation.distance(from: location))
                    
                    let locationInSpace = azimuthFromUser - heading
                    let radians = Utility.deg2rad(locationInSpace)
                    let rotationYAxis = matrix_float4x4(SCNMatrix4MakeRotation(Float(radians), 0, -1, 0))
                    
                    var translation = matrix_identity_float4x4
                    translation.columns.3.z = -1
                    
                    let transform = simd_mul(rotationYAxis, translation)
                    
                    let anchor = ARAnchor(transform: transform)
                    place.identifer = anchor.identifier
                    sceneView.session.add(anchor: anchor)
                }                
            }
        }
    }
}
