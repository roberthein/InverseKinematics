import Foundation
import SceneKit

public enum Models: String {
    case pipe
}

extension Models {
    
    var scene: SCNScene {
        return SCNScene(daeName: rawValue)
    }
    
    var childNodes: [SCNNode] {
        return scene.rootNode.childNodes
    }
    
    var geometry: SCNGeometry {
        return scene.rootNode.childNodes[0].geometry!
    }
}
