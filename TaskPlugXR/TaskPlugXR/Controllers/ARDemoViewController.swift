//
//  ARDemoViewController.swift
//  TaskPlugXR
//
//  Created by N, Narasimhulu on 25/12/20.
//  Copyright © 2020 Narasimha. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARDemoViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        self.setupWorldTracking()
        self.sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    private func setupWorldTracking() {
        if ARWorldTrackingConfiguration.isSupported {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            configuration.isLightEstimationEnabled = true
            self.sceneView.session.run(configuration, options: [])
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        
        // Adding two 3d objcts parallely
        guard let planeObj = add3DObject(with: "art.scnassets/toy_biplane", gesture: gesture),
            let drummerObj = add3DObject(with: "art.scnassets/toy_drummer", gesture: gesture) else {
                return
        }
        
        self.sceneView.scene.rootNode.addChildNode(planeObj)
        self.sceneView.scene.rootNode.addChildNode(drummerObj)
        
    }
    
    func add3DObject(with objectName: String, gesture: UITapGestureRecognizer) -> SCNNode? {
        let results = self.sceneView.hitTest(gesture.location(in: gesture.view), types: ARHitTestResult.ResultType.featurePoint)
        guard let result: ARHitTestResult = results.first else {
            return nil
        }
    
        guard let url = Bundle.main.url(forResource: objectName, withExtension: "usdz") else { fatalError() }
        
        let scene = try! SCNScene(url: url, options: [.checkConsistency: true])
        
        let node = scene.rootNode.childNode(withName: "SketchUp_\(objectName)", recursively: true)
        node?.scale = SCNVector3(0.01,0.01,0.01)
        
        let position = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        node?.position = position
        return node
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
