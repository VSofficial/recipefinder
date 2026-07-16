//
//  FridgeItemsView.swift
//  recipefinder
//
//  Created by Varun Sharma on 22/04/26.
//

import SwiftUI
import RealityKit

import SwiftUI
import SceneKit

struct FridgeSceneView: UIViewRepresentable {

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.backgroundColor = .gray
        view.allowsCameraControl = true
        
        let scene = SCNScene()
        view.scene = scene
        view.autoenablesDefaultLighting = true
        
        //  Camera (IMPORTANT)
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 5)
        scene.rootNode.addChildNode(cameraNode)
        
        //  Light (IMPORTANT)
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(0, 5, 5)
        scene.rootNode.addChildNode(lightNode)
        
        //  Debug box (to confirm scene works)
        let box = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
        box.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(box)
        
        //  Try loading model
        if let modelScene = SCNScene(named: "fridge2") {
            let node = SCNNode()
            
            for child in modelScene.rootNode.childNodes {
                node.addChildNode(child)
            }
            
            
            node.scale = SCNVector3(0.01, 0.01, 0.01)
            node.position = SCNVector3(0, 0, 0)
            
            scene.rootNode.addChildNode(node)
        } else {
            print("Model not loading")
        }
        
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}

#Preview {
    FridgeSceneView()
}



