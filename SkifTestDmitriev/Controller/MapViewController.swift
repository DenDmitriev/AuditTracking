//
//  MapViewController.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import GoogleMaps
import UIKit

class MapViewController: UIViewController {
    let map = GMSMapView(frame: .zero)
    var isAnimation: Bool = false
    
    override func loadView() {
        super.loadView()
        self.view = map
    }
}
