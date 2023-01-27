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
        
        do {
          // Set the map style by passing the URL of the local file.
          if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
              view.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
          } else {
            NSLog("Unable to find style.json")
          }
        } catch {
          NSLog("One or more of the map styles failed to load. \(error)")
        }
        return view
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }
    
    private func configStyle() {
        
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        
    }
}
