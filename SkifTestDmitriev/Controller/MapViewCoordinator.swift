//
//  MapViewCoordinator.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 16.11.2023.
//

import Foundation
import GoogleMaps

final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
    var mapViewControllerBridge: MapViewControllerBridge
    
    init(_ mapViewControllerBridge: MapViewControllerBridge) {
        self.mapViewControllerBridge = mapViewControllerBridge
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {

    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        syncZoomLevel(mapView)
    }
    
    private func syncZoomLevel(_ mapView: GMSMapView) {
        if mapView.camera.zoom != mapViewControllerBridge.zoomLevel {
            let zoomLevel = mapView.camera.zoom
            mapViewControllerBridge.onZoomChanged(zoomLevel)
        }
    }
}
