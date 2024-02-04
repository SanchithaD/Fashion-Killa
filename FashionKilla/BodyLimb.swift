//
//  BodyLimb.swift
//  FashionKilla
//
//  Created by Sanchitha Dinesh on 2/2/24.
//

import Foundation
import RealityKit

struct BodyLimb {
    var fromJoint: BodyJoint
    var toJoint: BodyJoint
    
    var centerPosition: SIMD3<Float> {
        [(fromJoint.position.x + toJoint.position.x) / 2, (fromJoint.position.y + toJoint.position.y) / 2, (fromJoint.position.z + toJoint.position.z) / 2]
    }
    
    var length: Float {
        simd_distance(fromJoint.position, toJoint.position)
    }
}
