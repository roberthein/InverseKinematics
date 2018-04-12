import Foundation
import UIKit
import SceneKit

class LegNode: SCNNode {
    
    private lazy var material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white.withAlphaComponent(0.2)
        
        return material
    }()
    
    required init(radius: CGFloat = 0.3, height: CGFloat = 6) {
        super.init()
        
        let capsule = SCNCapsule(capRadius: radius, height: height)
        capsule.materials = [material]
        capsule.heightSegmentCount = 10
        capsule.radialSegmentCount = 8
        capsule.capSegmentCount = 3
        
        geometry = capsule
        
        pivot = SCNMatrix4MakeTranslation(0, Float(height / 2), 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
