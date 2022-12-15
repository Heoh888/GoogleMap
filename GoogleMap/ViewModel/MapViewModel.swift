//
//  MapViewModel.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 15.12.2022.
//

import Combine
import CoreLocation

class MapViewModel: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()

    // 1
     @Published var location: CLLocation? {
       willSet { objectWillChange.send() }
     }
    
    // 2
    var latitude: CLLocationDegrees {
        return location?.coordinate.latitude ?? 0
    }
    
    var longitude: CLLocationDegrees {
        return location?.coordinate.longitude ?? 0
    }
    
    // 3
    override init() {
      super.init()

      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
    }
}

extension MapViewModel: CLLocationManagerDelegate {
  // 4
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print(location.coordinate)
        self.location = location
    }
}
