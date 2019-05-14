import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var scnView: SCNView {
        return view as! SCNView
    }
    
    private lazy var scene: SCNScene = {
        let scene = Models.pipe.scene
        scene.lightingEnvironment.contents = UIImage(named: "green-studio")
        scene.lightingEnvironment.intensity = 1.3
        
        return scene
    }()
    
    var rootNode: SCNNode {
        return scene.rootNode
    }
    
    var ik: SCNIKConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        
        rootNode.addChildNode(cameraNode)
        
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = .white
        
        let cylinderMaterial = SCNMaterial()
        cylinderMaterial.lightingModel = .physicallyBased
        cylinderMaterial.diffuse.contents = UIColor.white
        cylinderMaterial.metalness.contents = UIColor.white
        cylinderMaterial.metalness.intensity = 0
        cylinderMaterial.roughness.contents = UIColor.white
        cylinderMaterial.roughness.intensity = 0.3
        
        let cylinder = scene.rootNode.childNode(withName: "Cylinder", recursively: true)!
        cylinder.geometry?.materials = [cylinderMaterial]
        
        let armature = scene.rootNode.childNode(withName: "Armature", recursively: true)!
        ik = .inverseKinematicsConstraint(chainRootNode: armature)
        armature.childNode(withName: "head", recursively: true)!.constraints = [ik!]
        
        for i in 0 ..< 16 {
            guard let bone = armature.childNode(withName: "bone_\(i)", recursively: true) else { continue }
            ik!.setMaxAllowedRotationAngle(45 / 2, forJoint: bone)
        }
        
        self.randomize()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            self.randomize()
        }
    }
    
    func randomize() {
        let range: ClosedRange<Float> = -2 ... 2
        SCNTransaction.easeInOut(duration: 2, {
            self.ik?.targetPosition = SCNVector3(Float.random(in: range), Float.random(in: range), Float.random(in: range))
            self.scene.rootNode.childNode(withName: "Armature", recursively: true)!.position = SCNVector3(Float.random(in: range), Float.random(in: range), Float.random(in: range))
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
}
