import Foundation
import SceneKit

public extension SCNTransaction {
    
    public static func easeInOut(duration: TimeInterval, _ transaction: () -> ()) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transaction()
        SCNTransaction.commit()
    }
}
