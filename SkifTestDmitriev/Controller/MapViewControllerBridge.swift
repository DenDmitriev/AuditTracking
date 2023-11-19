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
    
    @ObservedObject var trackManager: TrackManager
    @Binding var zoomLevel: Float
    @Binding var track: Track
    @Binding var isPlaying: Bool
    @Binding var playSpeed: TrackPlaySpeed
    @Binding var isObserve: Bool
    @Binding var mapRouter: MapViewRouter
    @Binding var sliderMoving: Bool
    
    var onAnimationEnded: () -> ()
    var onZoomChanged: (Float) -> ()
    
    func makeUIViewController(context: Context) -> MapViewController {
        let controller = MapViewController(
            trackManager: trackManager,
            isPlaying: $isPlaying,
            speed: $playSpeed,
            isObserve: $isObserve,
            zoomLevel: $zoomLevel,
            sliderMoving: $sliderMoving
        )
        
        controller.mapView.delegate = context.coordinator
        controller.mapView.animate(toZoom: zoomLevel)
        controller.mapView.isUserInteractionEnabled = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        switch mapRouter {
        case .zoom:
            animateToZoom(viewController: uiViewController)
        case .loadTrack:
            animateToTrack(viewController: uiViewController)
        case .player:
            playTrack(viewController: uiViewController)
        case .slider:
            moveSlider(viewController: uiViewController)
        case .empty:
            return
        }
    }
    
    private func playTrack(viewController: MapViewController) {
        DispatchQueue.main.async {
            viewController.playTrack()
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
        let padding: CGFloat = 16
        let insets = UIEdgeInsets(top: 50, left: padding, bottom: 250, right: padding)
        viewController.drawTrack(track: track, padding: insets) {
            DispatchQueue.main.async {
                onZoomChanged(viewController.mapView.camera.zoom)
            }
        }
    }
    
    private func moveSlider(viewController: MapViewController) {
        viewController.moveSlider()
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
}
