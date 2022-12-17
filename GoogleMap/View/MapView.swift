//
//  MapsView.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 15.12.2022.
//

import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
    
    @StateObject var locationManager = MapViewModel()
    private let zoom: Float = 15.0
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude))
        if let coordinate = locationManager.location?.coordinate {
            let marker = GMSMarker(position: coordinate)
            marker.map = mapView
        }
    }
}
