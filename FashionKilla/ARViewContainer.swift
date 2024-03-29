//
//  ARViewContainer.swift
//  FashionKilla
//
//  Created by Sanchitha Dinesh on 2/2/24.
//

import SwiftUI
import ARKit
import RealityKit

private var bodySkeleton: BodySkeleton?
private let bodySkeletonAnchor = AnchorEntity()

struct ARViewContainer: UIViewRepresentable {
    typealias UIViewType = ARView
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        arView.setupForBodyTracking()
        arView.scene.addAnchor(bodySkeletonAnchor)
        
        return arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
}

extension ARView: ARSessionDelegate {
    func setupForBodyTracking() {
        let configuration = ARBodyTrackingConfiguration()
        
        self.session.run(configuration)
        self.session.delegate = self
    }
    
    public func session (_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {
                if let skeleton = bodySkeleton {
                    skeleton.update(with: bodyAnchor)
                }
                else {
                    bodySkeleton = BodySkeleton(for: bodyAnchor, shirtName: "Shirt 1")
                    
                    bodySkeletonAnchor.addChild(bodySkeleton!)
                    
                }
            }
        }
    }
}
