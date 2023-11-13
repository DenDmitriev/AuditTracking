//
//  MapViewControllerBridge.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import GoogleMaps
import SwiftUI

struct MapViewControllerBridge: UIViewControllerRepresentable {
    typealias UIViewControllerType = MapViewController
    
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController()
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        
    }
}
