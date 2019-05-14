import Foundation
import SceneKit

public extension SCNTransaction {
    
    static func easeInOut(duration: TimeInterval, _ transaction: () -> ()) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transaction()
        SCNTransaction.commit()
    }
}
