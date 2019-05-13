import Foundation
import UIKit
import SceneKit

class BoneNode: SCNNode {
    
    private let minimumSize: CGFloat = 1
    private let minimumRadius: CGFloat = 0.5
    
    private lazy var material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        
        return material
    }()
    
    private lazy var shortSide: SCNNode = {
        let height = minimumRadius
        
        let node = SCNNode()
        node.geometry = createGeometry(height: height)
        node.pivot = SCNMatrix4MakeTranslation(0, Float(height) / 2, 0)
        node.position.y = Float((length) / 2)
        
        return node
    }()
    
    private lazy var longSide: SCNNode = {
        let height = max(minimumRadius, length - minimumRadius)
        let offset = minimumRadius / 2
        
        let node = SCNNode()
        node.geometry = createGeometry(height: height)
        node.rotation = SCNVector4(0, 0, 1, Float.pi)
        node.pivot = SCNMatrix4MakeTranslation(0, Float(-offset), 0)
        
        return node
    }()
    
    let radius: CGFloat
    let length: CGFloat
    
    required init(radius: CGFloat = 0.5, length: CGFloat = 1) {
        self.radius = radius
        self.length = length
        super.init()
        
        self |< [shortSide, longSide]
        
        pivot = SCNMatrix4MakeTranslation(0, Float(length / 2), 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createGeometry(height: CGFloat) -> SCNGeometry {
        let cone = SCNCone(topRadius: 0, bottomRadius: radius, height: height)
        cone.materials = [material]
        cone.heightSegmentCount = 1
        cone.radialSegmentCount = 64
        
        return cone
    }
}
