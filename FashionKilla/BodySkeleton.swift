//
//  BodyVisualization.swift
//  FashionKilla
//
//  Created by Sanchitha Dinesh on 2/2/24.
//

import Foundation
import RealityKit
import ARKit
import SpriteKit

class BodySkeleton: Entity {
    
    static var shirt: TShirt = TShirt(shirtName: "Shirt 1")
    static var leftSleeve = UIImage(systemName: shirt.leftSleeve)
    static var rightSleeve = UIImage(systemName: shirt.rightSleeve)
    

    var joints: [String: Entity] = [:]
    var limbs: [String: Entity] = [:]
    required init(for bodyAnchor: ARBodyAnchor, shirtName: String) {
        BodySkeleton.shirt = TShirt(shirtName: shirtName)

        super.init()
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            var jointRadius: Float = 0.05
            var jointColor: UIColor = .white
            
            switch jointName {
            case  "left_shoulder_1_joint", "right_shoulder_1_joint":  jointRadius *= 0.5
           
            default:
                jointRadius = 0
                jointColor = .green
            }
            let jointEntity = createJoint(radius: jointRadius, color: jointColor)
            joints[jointName] = jointEntity
            self.addChild(jointEntity)
        }
        for bodyPart in BodyParts.allCases {
            guard let skeletonBone = createBodyLimb(bodyPart: bodyPart, bodyAnchor: bodyAnchor)
            else {continue}
            
            switch bodyPart.name {
            case "left_shoulder_1_joint-left_arm_joint", "left_arm_joint-left_forearm_joint":
                let limbEntity = createSleeve(for: skeletonBone, color: .white, name: BodySkeleton.shirt.leftSleeve)
                limbs[bodyPart.name] = limbEntity
                self.addChild(limbEntity)
            case "right_shoulder_1_joint-right_arm_joint", "right_arm_joint-right_forearm_joint":
                let limbEntity = createSleeve(for: skeletonBone, color: .white, name: BodySkeleton.shirt.rightSleeve)
                limbs[bodyPart.name] = limbEntity
                self.addChild(limbEntity)
            case "spine_6_joint-spine_5_joint":
                let limbEntity = createTorso(for: skeletonBone, color: .white, name: BodySkeleton.shirt.torso)
                limbs[bodyPart.name] = limbEntity
                self.addChild(limbEntity)
            case "left_upLeg_joint-left_leg_joint", "left_leg_joint-left_foot_joint", "right_upLeg_joint-right_leg_joint", "right_leg_joint-right_foot_joint":
                let limbEntity = createPantLeg(for: skeletonBone, color: .black)
                limbs[bodyPart.name] = limbEntity
                self.addChild(limbEntity)
            default:
                let limbEntity = createLimbEntity(for: skeletonBone)
                limbs[bodyPart.name] = limbEntity
                //self.addChild(limbEntity)
            }
            
        }
        
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    func update (with bodyAnchor: ARBodyAnchor) {
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            if let jointEntity = joints[jointName], let jointEntityTransForm = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName)) {
                
                let jointEntityOffsetFromRoot = simd_make_float3(jointEntityTransForm.columns.3)
                jointEntity.position = jointEntityOffsetFromRoot + rootPosition
                jointEntity.orientation = Transform(matrix: jointEntityTransForm).rotation
            }
        }
        
        for bodyPart in BodyParts.allCases {
            let partName = bodyPart.name
            
            guard let entity = limbs[partName], let skeletonBone = createBodyLimb(bodyPart: bodyPart, bodyAnchor: bodyAnchor)
            else {continue}
            
            entity.position = skeletonBone.centerPosition
            entity.look(at: skeletonBone.toJoint.position, from: skeletonBone.centerPosition, relativeTo: nil)
        }
    }
    private func createJoint(radius: Float, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, roughness: 0.8, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        return entity
    }
    
    private func createBodyLimb(bodyPart: BodyParts, bodyAnchor: ARBodyAnchor) -> BodyLimb? {
        guard let fromJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bodyPart.jointFromName)), let toJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bodyPart.jointToName))
        else {return nil}
        
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        let jointFromEntityOffSetFromRoot = simd_make_float3(fromJointEntityTransform.columns.3)
        
        let jointFromEntityPosition = jointFromEntityOffSetFromRoot + rootPosition
        
        let jointToEntityOffsetFromRoot = simd_make_float3(toJointEntityTransform.columns.3)
        
        let jointToEntityPosition = jointToEntityOffsetFromRoot + rootPosition
        
        let fromJoint = BodyJoint(name: bodyPart.jointFromName, position: jointFromEntityPosition)
        let toJoint = BodyJoint(name: bodyPart.jointToName, position: jointToEntityPosition)
        return BodyLimb(fromJoint: fromJoint, toJoint: toJoint)
    }
    
    private func createLimbEntity(for bodyLimb: BodyLimb, diameter: Float = 0.04, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateBox(size: [diameter, diameter, bodyLimb.length], cornerRadius: diameter/2)
        let material = SimpleMaterial(color: color, roughness: 0.5, isMetallic: true)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
    
    private func createSleeve(for bodyLimb: BodyLimb, diameter: Float = 0.1, color: UIColor, name: String) -> Entity {
          let mesh = MeshResource.generateBox(size: [diameter, diameter, bodyLimb.length], cornerRadius: diameter/2)
          
          var material = SimpleMaterial()
          material.color  = .init(tint: .white.withAlphaComponent(0.999),
                              texture: .init(try! .load(named: name)))
          material.metallic = .float(0.0)
          material.roughness = .float(0.5)
          
          let entity = ModelEntity(mesh: mesh, materials: [material])
          
          return entity
      }
    
    private func createTorso(for bodyLimb: BodyLimb, diameter: Float = 0.5, color: UIColor, name: String) -> Entity {
        let mesh = MeshResource.generateBox(size: [bodyLimb.length * 4, bodyLimb.length, bodyLimb.length * 6], cornerRadius: diameter/10)
        var material = SimpleMaterial()
        material.color  = .init(tint: .white.withAlphaComponent(0.999),
                            texture: .init(try! .load(named: name)))
        material.metallic = .float(0.0)
        material.roughness = .float(0.5)
        
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
    
    private func createPantLeg(for bodyLimb: BodyLimb, diameter: Float = 0.2, color: UIColor) -> Entity {
        let mesh = MeshResource.generateBox(size: [diameter, diameter, bodyLimb.length], cornerRadius: diameter/2)
        let material = SimpleMaterial(color: color, roughness: 0.5, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
}
