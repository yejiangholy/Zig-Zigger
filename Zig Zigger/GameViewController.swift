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

class GameViewController: UIViewController , SCNSceneRendererDelegate {
    
    let scene = SCNScene()
    let cameraNode = SCNNode()
    let firstBox = SCNNode()
    var person = SCNNode()
    var goingLeft = Bool()
    var tempBox = SCNNode()
    var boxNumber = Int()
    var prevBoxNumber = Int()
    var firstOne = Bool()
    
    override func viewDidLoad() {
        self.createScene()
        
    }
    
    
    func fadeIn(node : SCNNode)
    {
        node.opacity = 0
        node.runAction(SCNAction.fadeInWithDuration(0.5))
    }
    
    func fadeOut(node: SCNNode)
    {
        let move = SCNAction.moveTo(SCNVector3Make(node.position.x, node.position.y - 2 , node.position.z), duration: 0.5)
        node.runAction(move)
        node.runAction(SCNAction.fadeOutWithDuration(0.5))
    }
    
    func createCoin(box : SCNNode) {
        
        let randomNumber = arc4random() % 6
        if randomNumber == 3 {
            let spin = SCNAction.rotateByAngle(CGFloat(M_PI * 2), aroundAxis: SCNVector3Make(0, 0.5, 0), duration: 0.5)
            let coinScene = SCNScene(named: "Coin.dae")
            let coin = coinScene?.rootNode.childNodeWithName("Coin", recursively: true)
            coin?.position = SCNVector3Make(box.position.x, box.position.y + 1, box.position.z)
            coin?.scale = SCNVector3Make(0.2, 0.2, 0.2)
            scene.rootNode.addChildNode(coin!)
            coin?.runAction(SCNAction.repeatActionForever(spin))
            fadeIn(coin!)
            
        }
        
        
    }
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        let deleteBox = self.scene.rootNode.childNodeWithName("\(prevBoxNumber)", recursively: true)
        
        let currentBox = self.scene.rootNode.childNodeWithName("\(prevBoxNumber + 1)", recursively: true)
        
        if deleteBox?.position.x > person.position.x + 1 || deleteBox?.position.z > person.position.z + 1 {
            
            prevBoxNumber += 1
            
            deleteBox?.removeFromParentNode()
            
            createBox()
            
        }
        
        if (person.position.x > (currentBox?.position.x)! - 0.5 && person.position.x < (currentBox?.position.x)! + 0.5) || (person.position.z > (currentBox?.position.z)! - 0.5 && person.position.z < (currentBox?.position.z)! + 0.5) {
            // on platform
            
        } else {
            
            die()
        }
        
    }
    
    
    func die() {
        
        person.runAction(SCNAction.moveTo(SCNVector3Make(person.position.x, person.position.y - 10, person.position.z), duration: 1.0))
        
        let wait = SCNAction.waitForDuration(0.5)
        
        _ = SCNAction.sequence([wait, SCNAction.runBlock({
        node in
            
            self.scene.rootNode.enumerateChildNodesUsingBlock({
            node , stop in
                
                node.removeFromParentNode()
            
            })
            
        }), SCNAction.runBlock({
            node in
            
            self.createScene()
            
        })])
    }
    func createBox() {
        tempBox = SCNNode(geometry: firstBox.geometry)
        let prevBox = scene.rootNode.childNodeWithName("\(boxNumber)", recursively: true)
        
        boxNumber += 1
        
        tempBox.name = "\(boxNumber)"
        
        let randomNumber = arc4random() % 2
        
        switch randomNumber {
            
        case 0:
            tempBox.position = SCNVector3Make((prevBox?.position.x)! - firstBox.scale.x, (prevBox?.position.y)! , (prevBox?.position.z)!)
            
            if firstOne == true {
                firstOne = false
                goingLeft = false
            }
            
            break
        case 1:
            tempBox.position = SCNVector3Make((prevBox?.position.x)!, (prevBox?.position.y)! , (prevBox?.position.z)! - firstBox.scale.z)
            
            if firstOne == true {
                firstOne = false
                goingLeft = true
            }
            
            break
        default:
            
            break
        }
        self.scene.rootNode.addChildNode(tempBox)
        createCoin(tempBox)
        fadeIn(tempBox)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        if goingLeft == false{
            person.removeAllActions()
            person.runAction(SCNAction.repeatActionForever(SCNAction.moveBy(SCNVector3Make(-100, 0, 0), duration: 20)))
            goingLeft = true
            
        } else {
            person.removeAllActions()
            person.runAction(SCNAction.repeatActionForever(SCNAction.moveBy(SCNVector3Make(0, 0, -100), duration: 20)))
            goingLeft = false
        }
    }
    
    func createScene()
    {
        boxNumber = 0
        prevBoxNumber = 0
        firstOne = true
        
        self.view.backgroundColor = UIColor.whiteColor()
        let sceneView = self.view as! SCNView
        sceneView.delegate = self
        sceneView.scene = scene
        
        
        //ceate Person 
        let personGeo = SCNSphere(radius: 0.2)
        person = SCNNode(geometry: personGeo)
        let personMaterial = SCNMaterial()
        personMaterial.diffuse.contents = UIColor(red: 0.8, green: 0.3, blue: 0.2, alpha: 1.0)
        personGeo.materials = [personMaterial]
        person.position = SCNVector3Make(0, 1.1, 0)
        scene.rootNode.addChildNode(person)
        
        // create Camera
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 3
        cameraNode.position = SCNVector3Make(20, 20, 20)
        cameraNode.eulerAngles = SCNVector3Make(-45, 45, 0)
        let constraint = SCNLookAtConstraint(target: person)
        constraint.gimbalLockEnabled = true
        self.cameraNode.constraints = [constraint]
        scene.rootNode.addChildNode(cameraNode)
        person.addChildNode(cameraNode)
        
        // Create Box 
        let firstBoxGeo = SCNBox(width: 1, height: 1.5, length: 1, chamferRadius: 0)
        firstBox.geometry = firstBoxGeo
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor(red: 0.2, green: 0.8, blue: 0.9, alpha: 1.0)
        firstBoxGeo.materials = [boxMaterial]
        firstBox.position = SCNVector3Make(0, 0, 0)
        scene.rootNode.addChildNode(firstBox)
        firstBox.name = "\(boxNumber)"
        
        for _ in 0...6 {
            
            createBox()
        }

        
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
