import Foundation
import SceneKit

public extension SCNScene {
    
    convenience init(daeName name: String) {
        self.init(named: name + ".dae", inDirectory: "art.scnassets")!
    }
}
