//
//  MapViewController.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import GoogleMaps
import UIKit
import SwiftUI

class MapViewController: UIViewController {
    
    @Binding var track: Track?
    @Binding var isPlaying: Bool
    @Binding var progress: Int
    @Binding var playSpeed: TrackPlaySpeed
    @Binding var isObserveMode: Bool
    @Binding var zoomLevel: Float
    @Binding var sliderMoving: Bool
    
    var mapView: GMSMapView {
        return self.view as? GMSMapView ?? map
    }
    
    private var state: State = .empty
    private let serialQueue = DispatchQueue.main
    private let group = DispatchGroup()
    private let defaultStrokeWidth: CGFloat = 6
    private var trackIsShow: Bool = false
    private let map = GMSMapView()
    private var marker: GMSMarker?
    
    init(track: Binding<Track?>, isPlaying: Binding<Bool>, progress: Binding<Int>, speed:
         Binding<TrackPlaySpeed>, isObserve: Binding<Bool>, zoomLevel: Binding<Float>, sliderMoving: Binding<Bool>) {
        self._track = track
        self._isPlaying = isPlaying
        self._progress = progress
        self._playSpeed = speed
        self._isObserveMode = isObserve
        self._zoomLevel = zoomLevel
        self._sliderMoving = sliderMoving
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            if let startLocation = track.locationPoints.first?.coordinate {
                addMarkerToMap(coordinates: startLocation)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.trackIsShow = true
                self.state = .ready
                handler()
            })
        }
    }
    
    func moveSlider() {
        switch state {
        case .ready, .pause, .play:
            nextClip()
        default:
            return
        }
    }
    
    func playTrack() {
        switch state {
        case .ready:
            guard let track else { return }
            addMarkerToMap(coordinates: track.locationPoints[progress].coordinate)
            nextClipAnimation()
        case .play:
            return
        case .pause:
            nextClipAnimation()
        default:
            return
        }
    }
    
    func zoom(to zoom: Float) {
        mapView.animate(toZoom: zoom)
        if let marker {
            mapView.animate(toLocation: marker.position)
        }
        // Zoom in one zoom level
//        let zoomCamera = GMSCameraUpdate.zoomIn()
//        mapView.animate(with: zoomCamera)
    }
    
    func removeTrack() {
        trackIsShow = false
        mapView.clear()
        track = nil
    }
    
    // MARK: - Private methods
    
    // MARK: Route
    
    private func makeRoute(for locations: [CLLocation]) -> GMSPolyline {
        let polyline = GMSPolyline()
        polyline.strokeWidth = defaultStrokeWidth
        polyline.path = buildPath(for: locations)
        polyline.spans = buildSpans(for: locations)
//        polyline.spans = buildSpansNew(for: locations)
        
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
    
    // MARK: Marker Animation
    
    enum State {
        case ready, play, pause, empty
    }
    
    private func nextClipAnimation() {
        guard
            let track,
            isPlaying,
            progress < track.locationPoints.count - 1
        else {
            state = .pause
            return
        }
        
        state = .play
        
        let clip = createClip(index: progress, animation: true)
        
        serialQueue.async(group: group, execute: clip)
    }
    
    private func nextClip() {
//        let clip: DispatchWorkItem
//        if sliderMoving {
//            clip = createClip(index: progress, animation: false)
//        } else {
//            clip = createClip(index: progress, animation: true)
//        }
        
        let clip = createClip(index: progress, animation: false)
        serialQueue.async(group: group, execute: clip)
    }
    
    private func createClip(index: Int, animation: Bool) -> DispatchWorkItem {
        let execute = DispatchWorkItem {
            guard let track = self.track else { return }
            let locationPoint = track.locationPoints[index]
            self.moveToSegment(locationPoint, animation: animation) {
                if animation {
                    self.progress += 1
                    self.nextClipAnimation()
                } else {
                    if self.sliderMoving {
                        self.nextClip()
                    }
                }
            }
        }
        
        return execute
    }
    
    private func addMarkerToMap(coordinates: CLLocationCoordinate2D) {
        guard marker == nil else { return }
        marker = GMSMarker(position: coordinates)
        let image = UIImage(named: "marker")
        let markerView = UIImageView(image: image)
        marker?.iconView = markerView
        marker?.tracksViewChanges = false
        marker?.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker?.map = mapView
    }
    
    private func moveToSegment(_ locationPoint: LocationPoint, animation: Bool, completion: @escaping (() -> Void)) {
        let next = locationPoint.coordinate
        let rotation = locationPoint.course ?? .zero
        let duration = animation ? duration(locationPoint) : 0
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock {
            completion()
        }
        
        marker?.rotation = rotation
        marker?.position = next
        if isObserveMode {
            let cameraUpdate = GMSCameraUpdate.setTarget(next, zoom: zoomLevel)
            mapView.animate(with: cameraUpdate)
        }
        
        CATransaction.commit()
    }
    
    private func duration(_ locationPoint: LocationPoint) -> TimeInterval {
        let animateFactor = 1.0
        let speedFactor = Double(playSpeed.rawValue) * animateFactor
        let speed = locationPoint.speed ?? 0
        let distance = locationPoint.distance ?? 0
        var duration: TimeInterval
        
        if speed == 0 {
            duration = 0
        } else {
            duration = distance / speed / speedFactor
        }
        
        let rounded = (duration * 10).rounded() / 10
        
        return rounded
    }
}
