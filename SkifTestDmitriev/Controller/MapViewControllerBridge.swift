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
    @Binding var isPlaying: Bool
    
    var onAnimationEnded: () -> ()
    var onZoomChanged: (Float) -> ()
    
    func makeUIViewController(context: Context) -> MapViewController {
        let controller = MapViewController()
        controller.mapView.delegate = context.coordinator
        controller.mapView.animate(toZoom: zoomLevel)
        controller.mapView.isUserInteractionEnabled = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        animateToZoom(viewController: uiViewController)
        animateToTrack(viewController: uiViewController)
        if isPlaying {
            playTrack(viewController: uiViewController)
        }
    }
    
    private func playTrack(viewController: MapViewController) {
        if let track {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
            }
            viewController.playTrack(track, speed: .one)
        }
    }
    
    private func animateToZoom(viewController: MapViewController) {
        if viewController.mapView.camera.zoom != zoomLevel {
            DispatchQueue.main.async {
                viewController.zoom(to: zoomLevel)
            }
        }
    }
    
    private func animateToTrack(viewController: MapViewController) {
        if let track {
            let padding: CGFloat = 16
            let insets = UIEdgeInsets(top: 50, left: padding, bottom: 250, right: padding)
            viewController.drawTrack(track: track, padding: insets) {
                DispatchQueue.main.async {
                    onZoomChanged(viewController.mapView.camera.zoom)
                }
            }
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
}
