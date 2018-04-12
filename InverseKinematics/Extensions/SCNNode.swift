import Foundation
import SceneKit

precedencegroup ForwardApplication {
    associativity: right
}

infix operator |<: ForwardApplication
infix operator |<<: ForwardApplication

@discardableResult func |< (left: SCNNode, right: SCNNode) -> SCNNode {
    left.addChildNode(right)
    return left
}

@discardableResult func |< (left: SCNNode, right: [SCNNode]) -> SCNNode {
    right.forEach { left |< $0 }
    return left
}

@discardableResult func |<< (left: SCNNode, right: [SCNNode]) -> SCNNode {
    var previousNode: SCNNode = left
    
    right.forEach {
        previousNode |< $0
        previousNode = $0
    }
    
    return left
}
