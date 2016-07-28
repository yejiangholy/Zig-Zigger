//
//  GameViewController.swift
//  Zig Zigger
//
//  Created by JiangYe on 7/28/16.
//  Copyright (c) 2016 JiangYe. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    let scene = SCNScene()
    let cameraNode = SCNNode()
    let firstBox = SCNNode()
    var person = SCNNode()
    override func viewDidLoad() {
        self.createScene()
        
    }
    
    func createScene()
    {
        self.view.backgroundColor = UIColor.whiteColor()
        let sceneView = self.view as! SCNView
        sceneView.scene = scene
        
        
        //ceate Person 
        let personGeo = SCNSphere(radius: 0.2)
        person = SCNNode(geometry: personGeo)
        let personMaterial = SCNMaterial()
        personMaterial.diffuse.contents = UIColor.redColor()
        personGeo.materials = [personMaterial]
        person.position = SCNVector3Make(0, 1.1, 0)
        scene.rootNode.addChildNode(person)
        
        // create Camera
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 3
        cameraNode.position = SCNVector3Make(20, 20, 20)
        cameraNode.eulerAngles = SCNVector3Make(-45, 45, 0)
        let constraint = SCNLookAtConstraint(target: firstBox)
        constraint.gimbalLockEnabled = true
        self.cameraNode.constraints = [constraint]
        scene.rootNode.addChildNode(cameraNode)
        
        // Create Box 
        let firstBoxGeo = SCNBox(width: 1, height: 1.5, length: 1, chamferRadius: 0)
        firstBox.geometry = firstBoxGeo
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor(red: 0.2, green: 0.8, blue: 0.9, alpha: 1.0)
        firstBoxGeo.materials = [boxMaterial]
        firstBox.position = SCNVector3Make(0, 0, 0)
        scene.rootNode.addChildNode(firstBox)
        
        // Create Light 
        let light = SCNNode()
        light.light = SCNLight()
        light.light?.type = SCNLightTypeDirectional
        light.eulerAngles = SCNVector3Make(-45, 45, 0)
        scene.rootNode.addChildNode(light)
        
        let light2 = SCNNode()
        light2.light = SCNLight()
        light2.light?.type = SCNLightTypeDirectional
        light2.eulerAngles = SCNVector3Make(45, 45, 0)
        scene.rootNode.addChildNode(light2)
    }

}
