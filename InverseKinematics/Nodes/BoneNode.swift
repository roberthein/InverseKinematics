import Foundation
import UIKit
import SceneKit

class BoneNode: SCNNode {
    
    private let minimumSize: CGFloat = 0.5
    private let minimumRadius: CGFloat = 0.25
    
    private lazy var material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.darkGray
        
        return material
    }()
    
    private lazy var transparent: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        
        return material
    }()
    
    private lazy var shortSide: SCNNode = {
        let height = minimumRadius
        
        let cone = SCNCone(topRadius: 0, bottomRadius: radius, height: height)
        cone.materials = [material]
        cone.heightSegmentCount = 1
        cone.radialSegmentCount = 4
        
        let node = SCNNode()
        node.geometry = cone
        node.pivot = SCNMatrix4MakeTranslation(0, Float(height) / 2, 0)
        node.position.y = Float((length) / 2)
        
        return node
    }()
    
    private lazy var longSide: SCNNode = {
        let height = max(minimumRadius, length - minimumRadius)
        let offset = minimumRadius / 2
        
        let cone = SCNCone(topRadius: 0, bottomRadius: radius, height: height)
        cone.materials = [material]
        cone.heightSegmentCount = 1
        cone.radialSegmentCount = 4
        
        let node = SCNNode()
        node.geometry = cone
        node.rotation = SCNVector4(0, 0, 1, Float.pi)
        node.pivot = SCNMatrix4MakeTranslation(0, Float(-offset), 0)
//        node.position.y = Float(minimumRadius)
        
        return node
    }()
    
    let radius: CGFloat
    let length: CGFloat
    
    required init(radius: CGFloat = 0.25, length: CGFloat = 0.5) {
        self.radius = radius
        self.length = length
        super.init()
        
        self |< [shortSide, longSide]
        
        let cyrlinder = SCNCylinder(radius: radius, height: length)
        cyrlinder.radialSegmentCount = 3
        cyrlinder.heightSegmentCount = 1
        
        geometry = cyrlinder
        geometry?.materials = [transparent]
        
        pivot = SCNMatrix4MakeTranslation(0, Float(length / 2), 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
