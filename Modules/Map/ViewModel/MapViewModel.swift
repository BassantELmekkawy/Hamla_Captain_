//
//  MapViewModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 20/05/2024.
//

import Foundation
import GoogleMaps

protocol MapViewModelProtocol {
    
    func pickupOrder(orderID: String)
    func arrivedOrder(orderID: String)
    func cancelOrder(orderID: String)
    func startOrder(orderID: String)
    func endOrder(orderID: String, dropoffLat: String, dropoffLng: String)

    var pickupResult:Observable<Model?> { get set }
    var arrivedResult:Observable<Model?> { get set }
    var cancelResult:Observable<Model?> { get set }
    var startResult:Observable<Model?> { get set }
    var endResult:Observable<EndOrderModel?> { get set }
    var errorMessage:Observable<String?> { get set }
    
}

class MapViewModel: MapViewModelProtocol {
    
    var pickupResult: Observable<Model?>  = Observable(nil)
    var arrivedResult: Observable<Model?> = Observable(nil)
    var cancelResult: Observable<Model?>  = Observable(nil)
    var startResult: Observable<Model?>   = Observable(nil)
    var endResult: Observable<EndOrderModel?>     = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    var currentPolyline: GMSPolyline?
    
    var api: MapApiProtocol
    
    init(api: MapApi) {
        self.api = api
    }
    
    func pickupOrder(orderID: String) {
        self.api.pickupOrder(orderID: orderID) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.pickupResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func arrivedOrder(orderID: String) {
        self.api.arrivedOrder(orderID: orderID) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.arrivedResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func cancelOrder(orderID: String) {
        self.api.cancelOrder(orderID: orderID) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.cancelResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func startOrder(orderID: String) {
        self.api.startOrder(orderID: orderID) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.startResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func endOrder(orderID: String, dropoffLat: String, dropoffLng: String) {
        self.api.endOrder(orderID: orderID, dropoffLat: dropoffLat, dropoffLng: dropoffLng) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.endResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func addMarker(marker: GMSMarker, image: String, mapView: GMSMapView) {
        
        marker.icon = UIImage(named: image)
        marker.map = mapView
    }
    
    func drawPath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, mapView: GMSMapView) {
        let origin = "\(start.latitude),\(start.longitude)"
        let destination = "\(end.latitude),\(end.longitude)"

        let apiKey = "AIzaSyB9Gu55XnI_UEP_hnW5GKVtWiAt-nxxxeU"
        let directionsURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(apiKey)"
        
        guard let url = URL(string: directionsURL) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let routes = json["routes"] as? [[String: Any]] {
                        if let route = routes.first, let overviewPolyline = route["overview_polyline"] as? [String: Any], let points = overviewPolyline["points"] as? String {
                            DispatchQueue.main.async {
                                // Decode the polyline into coordinates
                                let path = GMSPath(fromEncodedPath: points)
                                let polyline = GMSPolyline(path: path)
                                polyline.strokeWidth = 4.0
                                polyline.strokeColor = .blue
                                polyline.map = mapView
                                
                                self.currentPolyline = polyline
                            }
                            
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }

        task.resume()
    }
    
    func drawPolyline(path: GMSPath, mapView: GMSMapView) {
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        polyline.strokeColor = .blue
        polyline.map = mapView
    }
    
    func removeCurrentPolyline() {
        currentPolyline?.map = nil
        currentPolyline = nil
    }
    
}
