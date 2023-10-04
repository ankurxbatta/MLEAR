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

    var currentVideoNode: SKVideoNode?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Enable motion events
        self.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "MLEAR", bundle: Bundle.main) {
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

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        if let imageAnchor = anchor as? ARImageAnchor {
            let videos = [
                "11": "2001200.mp4",
                "12": "2001200.mp4",
                "13": "2001200.mp4",
                "14": "2001200.mp4",
                "15": "2001200.mp4",
                "16": "2001200.mp4",
                "17": "2001200.mp4",
                "18": "2001200.mp4",
                "19": "2001200.mp4",
                "20": "2001200.mp4"
            ]

            if let videoName = videos[imageAnchor.referenceImage.name!] {
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

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            if !imageAnchor.isTracked {
                currentVideoNode?.pause()
            } else {
                currentVideoNode?.play()
            }
        }
    }

    // Handle shake gesture
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            // Restart the application
            restartApplication()
        }
    }

    // Restart the application
    func restartApplication() {
        // Pause the current AR session
        sceneView.session.pause()

        // Remove any existing nodes
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }

        // Create a new session configuration
        let configuration = ARWorldTrackingConfiguration()

        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "MLEAR", bundle: Bundle.main) {
            configuration.detectionImages = trackedImages
            configuration.maximumNumberOfTrackedImages = 1
            print("Images found")
        }

        // Run the new AR session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}
