//
//  MapViewModel.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 29.12.2022.
//

import GoogleMaps
import RealmSwift
import SwiftUI

enum MainManager {
    case startNewTrack
    case showPreviousRoute
    case browseMain
    case `default`
}

class MainViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapView = GMSMapView()
    @Published var zoom: Float = 15.0
    @Published var routeTime = ""
    @Published var previousResultDistance = ""
    @Published var previousResultTime = ""
    @Published var time = 0
    @Published var viewManager: MainManager = .default
    
    var coordinates = [CLLocationCoordinate2D]()
    var locationManager = CLLocationManager()
    var locationService = LocationService.instance
    let service = RealmService()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinate = locations.last!.coordinate
        switch viewManager {
        case .startNewTrack:
            coordinates.append(coordinate)
            startNewTrack(coordinates: coordinates)
            manager.allowsBackgroundLocationUpdates = true
        case .showPreviousRoute:
            print("showPreviousRoute")
        case .browseMain:
            manager.allowsBackgroundLocationUpdates = false
        case .default:
            coordinates = []
            manager.allowsBackgroundLocationUpdates = false
            let camera = GMSCameraPosition(latitude: coordinate.latitude,
                                           longitude: coordinate.longitude, zoom: zoom)
            mapView.camera = camera
            viewManager = .browseMain
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func saveResult() {
        do {
            let route = RouteModel()
            route.routeTime = routeTime
            coordinates.forEach {
                route.latitude.append($0.latitude)
                route.longitude.append($0.longitude)
            }
            try self.service.deleteAll()
            try self.service.add(object: route)
        } catch {
            print(error)
        }
    }
    
    func timer(seconds: Int) {
        routeTime = "\(seconds / 3600):\((seconds % 3600) / 60):\((seconds % 3600) % 60)"
    }
    
    func getPreviousResult() {
        coordinates = []
        var distance = 0.0
        guard let result = service.read(RouteModel.self) else { return }
        guard let routeTime = result.last?.routeTime else { return }
        guard let latitudeStart = result[0].latitude.first, let longitudeStart = result[0].longitude.first else { return }
        guard let latitudeFinish = result[0].latitude.last, let longitudeFinish = result[0].longitude.last else { return }
        
        
        (0..<result[0].longitude.count).forEach { i in
            coordinates.append(CLLocationCoordinate2D(latitude: result[0].latitude[i],
                                                      longitude: result[0].longitude[i]))
        }
        
        let path = GMSMutablePath()
        if coordinates.count >= 2 {
            coordinates.forEach { item in
                path.add(CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
            }
        }
        
        if coordinates.count >= 2 {
            for index in 0..<coordinates.count - 1 {
                distance = distance + distanceTwoPoints(firstPoint: coordinates[index], secondPoint: coordinates[index + 1])
            }
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 7.0
        polyline.strokeColor = .systemBlue
        polyline.map = mapView
        
        if coordinates.count >= 2 {
            coordinates.forEach {
                let circleCenter = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                let circle = GMSCircle(position: circleCenter, radius: 0.5)
                circle.fillColor = .white
                circle.strokeColor = .systemBlue
                circle.strokeWidth = 3
                circle.map = mapView
            }
        }
        
        previousResultTime = "\(routeTime)"
        previousResultDistance = distance < 100 ? "\(distance.rounded()) metrs" : "\(distance.rounded() / 1000) km"
        
        let positionStart = CLLocationCoordinate2D(latitude: latitudeStart, longitude: longitudeStart)
        let start = GMSMarker(position: positionStart)
        start.title = "Start"
        start.map = mapView
        
        let positionFinish = CLLocationCoordinate2D(latitude: latitudeFinish, longitude: longitudeFinish)
        let finish = GMSMarker(position: positionFinish)
        finish.title = "Finish"
        finish.map = mapView
        
        let one = CLLocationCoordinate2D(latitude: coordinates.first!.latitude, longitude: coordinates.first!.longitude)
        let two = CLLocationCoordinate2D(latitude: farthestPoint(coordinates: coordinates).latitude, longitude: farthestPoint(coordinates: coordinates).longitude)
        let bounds = GMSCoordinateBounds(coordinate: one, coordinate: two)
        let camera = mapView.camera(for: bounds, insets: UIEdgeInsets())!
        mapView.camera = camera
        
    }
    
    func getPreviousRoute() -> RouteModel!  {
        service.read(RouteModel.self)?.last
    }
    
    func mapClear() {
        mapView.clear()
    }
    
    func myLocation() {
        locationService
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 75)
                print(position.viewingAngle)
                self?.mapView.animate(to: position)
            }
            .dispose()
    }
    
    private func distanceTwoPoints(firstPoint: CLLocationCoordinate2D, secondPoint: CLLocationCoordinate2D) -> Double {
        let coordinate0 = CLLocation(latitude: firstPoint.latitude, longitude: firstPoint.longitude)
        let coordinate1 = CLLocation(latitude: secondPoint.latitude, longitude: secondPoint.longitude)
        return coordinate0.distance(from: coordinate1)
    }
    
    private func farthestPoint(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        let startPoint = coordinates.first!
        var result = startPoint
        var distance = 0.0
        coordinates.forEach {
            if distance < distanceTwoPoints(firstPoint: startPoint, secondPoint: $0) {
                distance = distanceTwoPoints(firstPoint: startPoint, secondPoint: $0)
                result = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }
        }
        return result
    }
    
    private func startNewTrack(coordinates: [CLLocationCoordinate2D]) {
        let path = GMSMutablePath()
        if coordinates.count >= 2 {
            let arraySlice = coordinates.suffix(2)
            path.add(CLLocationCoordinate2D(latitude: arraySlice.first!.latitude, longitude: arraySlice.first!.longitude))
            path.add(CLLocationCoordinate2D(latitude: arraySlice.last!.latitude, longitude: arraySlice.last!.longitude))
            
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 7.0
            polyline.strokeColor = .systemBlue
            polyline.map = mapView
            
            let circleCenter = CLLocationCoordinate2D(latitude: arraySlice.first!.latitude, longitude: arraySlice.first!.longitude)
            let circle = GMSCircle(position: circleCenter, radius: 0.5)
            circle.fillColor = .white
            circle.strokeColor = .systemBlue
            circle.strokeWidth = 3
            circle.map = mapView
            
        }
        let camera = GMSCameraPosition(latitude: coordinates.last!.latitude, longitude: coordinates.last!.longitude, zoom: 17)
        mapView.animate(to: camera)
        mapView.camera = camera
    }
}
