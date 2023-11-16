//
//  MapViewController.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import GoogleMaps
import UIKit

class MapViewController: UIViewController {
    
    private let defaultStrokeWidth: CGFloat = 6
    private var trackIsShow: Bool = false
    private let map = GMSMapView(frame: .zero)
    
    var mapView: GMSMapView {
        return self.view as? GMSMapView ?? map
    }
    
    override func loadView() {
        super.loadView()
        self.view = map
    }
    
    func drawTrack(track: Track?, padding: UIEdgeInsets? = nil, handler: @escaping (() -> Void)) {
        guard
            let track,
            !trackIsShow
        else { return }
        
        let locations = track.locationPoints.map { $0.clLocation }
        let route = makeRoute(for: locations)
        let strokeRoute = makeStrokeRoute(for: route.path ?? GMSPath())
        strokeRoute.map = mapView
        route.map = mapView

        if let path = route.path {
            let bounds = GMSCoordinateBounds(path: path)
            mapView.animate(with: .fit(bounds, with: padding ?? .zero))
            trackIsShow = true
            handler()
        }
    }
    
    func removeTrack() {
        trackIsShow = false
    }
    
    func zoom(to zoom: Float) {
        mapView.animate(toZoom: zoom)
    }
    
    private func makeRoute(for locations: [CLLocation]) -> GMSPolyline {
        let polyline = GMSPolyline()
        polyline.strokeWidth = defaultStrokeWidth
        polyline.path = buildPath(for: locations)
        polyline.spans = buildSpans(for: locations)
        
        return polyline
    }
    
    private func makeStrokeRoute(for path: GMSPath) -> GMSPolyline {
        let polyline = GMSPolyline()
        polyline.path = path
        polyline.strokeWidth = defaultStrokeWidth + 2
        polyline.strokeColor = .white
        
        return polyline
    }
    
    private func buildPath(for locations: [CLLocation]) -> GMSMutablePath {
        let path = GMSMutablePath()
        locations.enumerated().forEach { index, location in
            path.add(location.coordinate)
        }
        return path
    }
    
    private func buildSpans(for locations: [CLLocation]) -> [GMSStyleSpan] {
        var spans: [GMSStyleSpan] = []
        locations.enumerated().forEach { index, location in
            guard index != .zero else {
                let color = Speed(speed: Int(location.speed)).uiColor
                let span = GMSStrokeStyle.gradient(from: color, to: color)
                let style = GMSStyleSpan(style: span)
                spans.append(style)
                return
            }
            let previous = locations[index - 1]

            let colorFrom = Speed(speed: Int(previous.speed)).uiColor
            let colorTo = Speed(speed: Int(location.speed)).uiColor

            if colorTo == colorFrom {
                guard
                    let style = spans.last?.style,
                    var segments = spans.last?.segments
                else { return }

                segments += 1

                let lastIndex = spans.count - 1
                spans[lastIndex] = GMSStyleSpan(style: style, segments: segments)
            } else {
                let style = GMSStrokeStyle.gradient(from: colorFrom, to: colorTo)
                let span = GMSStyleSpan(style: style)

                spans.append(span)
            }
        }
        
        return spans
    }
    
    func playTrack(_ track: Track, speed: TrackPlaySpeed) {
        let next = track.locationPoints[50000].coordinate
        let nextCam = GMSCameraUpdate.setTarget(next)
        mapView.animate(with: nextCam)
    }
}
