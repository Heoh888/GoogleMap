//
//  MapsView.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 15.12.2022.
//

import SwiftUI
import GoogleMaps
import MapKit

struct MapView: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: MainViewModel
    
    func makeUIView(context: Context) -> GMSMapView {
        let view = viewModel.mapView
        view.isMyLocationEnabled = true
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {

    }
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {

    }
}
