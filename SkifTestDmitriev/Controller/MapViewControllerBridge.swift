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
    
    @Binding var zoomLevel: Float
    @Binding var track: Track?
    
    var onAnimationEnded: () -> ()
    
    func makeUIViewController(context: Context) -> MapViewController {
        let controller = MapViewController()
        controller.mapView.delegate = context.coordinator
        controller.mapView.animate(toZoom: zoomLevel)
        controller.mapView.isUserInteractionEnabled = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        uiViewController.zoom(to: zoomLevel)
        if let track {
            let padding: CGFloat = 16
            let insets = UIEdgeInsets(top: 50, left: padding, bottom: 250, right: padding)
            uiViewController.drawTrack(track: track, padding: insets) {
//                onZoomUpdated(uiViewController.mapView.camera.zoom)
            }
        }
        
    }
    
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapViewControllerBridge: MapViewControllerBridge
        
        init(_ mapViewControllerBridge: MapViewControllerBridge) {
            self.mapViewControllerBridge = mapViewControllerBridge
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            
        }
    }
}
