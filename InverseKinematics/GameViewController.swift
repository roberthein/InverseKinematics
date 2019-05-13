import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    private lazy var leg = LegNode()
    
    private lazy var bones: [BoneNode] = {
        return [
            BoneNode(),
            BoneNode(length: 2),
            BoneNode(length: 2),
            BoneNode(length: 2),
            BoneNode()
        ]
    }()
    
    private lazy var ikConstraint = SCNIKConstraint.inverseKinematicsConstraint(chainRootNode: bones.first!)
    
    var scnView: SCNView {
        return view as! SCNView
    }
    
    private lazy var scene = SCNScene()
    
    var rootNode: SCNNode {
        return scene.rootNode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        
        rootNode |< [cameraNode, lightNode, ambientLightNode]
        
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = false
        scnView.backgroundColor = .black
        scnView.debugOptions = [
//            .showPhysicsShapes,
//            .showLightInfluences,
//            .showLightExtents,
//            .showPhysicsFields,
//            .showWireframe,
            .renderAsWireframe,
//            .showSkeletons,
//            .showCreases,
//            .showConstraints,
//            .showCameras
        ]
        
//        scene.lightingEnvironment.contents =  UIImage(named: "environment")
//        scene.lightingEnvironment.intensity = 1.3
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        scnView.gestureRecognizers = [tapGesture, panGesture]
        
        rootNode |<< bones
        
        for (i, bone) in bones.enumerated() {
            ikConstraint.setMaxAllowedRotationAngle(90, forJoint: bone)
            bone.position = bones.first == bone ? SCNVector3(0, 0, 0) : SCNVector3(0, -bones[i - 1].length / 2, 0)
        }
        
        bones.last!.constraints = [ikConstraint]
        
        leg.position = bones.first!.position
        leg.skinner = SCNSkinner(baseGeometry: leg.geometry, bones: bones, boneInverseBindTransforms: bones.map({ $0.transform }) as [NSValue], boneWeights: SCNGeometrySource(), boneIndices: SCNGeometrySource())
        leg.skinner?.skeleton = bones.first!
    }
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.location(in: gestureRecognizer.view)
        move(to: location, duration: 0.8)
    }
    
    @objc func pan(_ gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.location(in: gestureRecognizer.view)
        move(to: location, duration: 0.1)
    }
    
    func move(to location: CGPoint, duration: TimeInterval) {
        let xTarget: Float = Float((location.x - (UIScreen.main.bounds.width / 2)) / 50)
        let yTarget: Float = Float((-location.y + (UIScreen.main.bounds.height / 2)) / 50)
        
        SCNTransaction.easeInOut(duration: duration) {
            ikConstraint.targetPosition = SCNVector3Make(xTarget, yTarget, 0)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
}

