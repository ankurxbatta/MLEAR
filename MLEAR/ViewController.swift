//
//  ViewController.swift
//  MLEAR
//
//  Created by Ankur Batta on 12/09/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "TheDailyProphet" , bundle: Bundle.main) {
            
            configuration.detectionImages = trackedImages
            
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Images found")
            
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    var currentVideoNode: SKVideoNode?
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            // let videos = ["harrypotter": "harrypotter.mp4", "deatheater": "deatheater.mp4"]
            
            let videos = ["00": "00.mp4", "11": "11.mp4", "12": "12.mp4", "13": "13.mp4", "14": "14.mp4", "15": "15.mp4", "16": "16.mp4", "17": "17.mp4", "18": "18.mp4", "19": "19.mp4", "20": "20.mp4"]
            
            if let videoName = videos[imageAnchor.referenceImage.name!] {
                if let currentVideoNode = currentVideoNode {
                    currentVideoNode.pause()
                    currentVideoNode.removeFromParent()
                }
                
                let videoNode = SKVideoNode(fileNamed: videoName)
                videoNode.play()
                currentVideoNode = videoNode
                
                let videoScene = SKScene(size: CGSize(width: 480, height: 360))
                videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
                videoNode.yScale = -1.0
                videoScene.addChild(videoNode)
                
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                plane.firstMaterial?.diffuse.contents = videoScene
                
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                
                node.addChildNode(planeNode)
            }
        }
        
        return node
    }
}
