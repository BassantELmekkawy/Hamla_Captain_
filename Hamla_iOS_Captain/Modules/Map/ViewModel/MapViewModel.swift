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
    func startLoad(orderID: String)
    func endLoad(orderID: String)
    func startOrder(orderID: String)
    func arrivedPoint(orderID: String)
    func movePoint(orderID: String)
    func dropoffOrder(orderID: String)
    func startUnload(orderID: String)
    func endUnload(orderID: String)
    func endOrder(orderID: String, dropoffLat: String, dropoffLng: String)
    func confirmPaymentCash(orderID: String, amount: String)
    func rateOrder(orderID: String, rate: String)
    func cancelOrder(orderID: String)

    var pickupResult:Observable<Model?> { get set }
    var arrivedResult:Observable<Model?> { get set }
    var startLoadResult:Observable<Model?> { get set }
    var endLoadResult:Observable<Model?> { get set }
    var startOrderResult:Observable<Model?> { get set }
    var arrivedPointResult:Observable<Model?> { get set }
    var movePointResult:Observable<Model?> { get set }
    var dropoffResult:Observable<Model?> { get set }
    var startUnloadResult:Observable<Model?> { get set }
    var endUnloadResult:Observable<Model?> { get set }
    var endOrderResult:Observable<EndOrderModel?> { get set }
    var confirmPaymentCashResult:Observable<Model?> { get set }
    var rateOrderResult:Observable<Model?> { get set }
    var cancelResult:Observable<Model?> { get set }
    var errorMessage:Observable<String?> { get set }
    
}

class MapViewModel: MapViewModelProtocol {
    
    var pickupResult: Observable<Model?>  = Observable(nil)
    var arrivedResult: Observable<Model?> = Observable(nil)
    var startLoadResult:Observable<Model?> = Observable(nil)
    var endLoadResult:Observable<Model?> = Observable(nil)
    var startOrderResult:Observable<Model?> = Observable(nil)
    var arrivedPointResult:Observable<Model?> = Observable(nil)
    var movePointResult:Observable<Model?> = Observable(nil)
    var dropoffResult:Observable<Model?> = Observable(nil)
    var startUnloadResult:Observable<Model?> = Observable(nil)
    var endUnloadResult:Observable<Model?> = Observable(nil)
    var endOrderResult:Observable<EndOrderModel?> = Observable(nil)
    var confirmPaymentCashResult: Observable<Model?>  = Observable(nil)
    var rateOrderResult: Observable<Model?>  = Observable(nil)
    var cancelResult: Observable<Model?>  = Observable(nil)
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
                print(result ?? "")
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
                print(result ?? "")
                self.arrivedResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                print("error", error.message)
            }
        }
    }
    
    func startLoad(orderID: String) {
        self.api.startLoad(orderID: orderID) { result in
            switch result {
            case .success(let result):
                print(result ?? "")
                self.startLoadResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                print("error", error.message)
            }
        }
    }
    
    func endLoad(orderID: String) {
        self.api.endLoad(orderID: orderID) { result in
            switch result {
            case .success(let result):
                print(result ?? "")
                self.endLoadResult.value = result
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
                print(result ?? "")
                self.startOrderResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                print("error", error.message)
            }
        }
    }
    
    func arrivedPoint(orderID: String) {
        self.api.arrivePoint(orderID: orderID) { result in
            switch result {
            case .success(let result):
                print(result ?? "")
                self.arrivedPointResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                print("error", error.message)
            }
        }
    }
    
    func movePoint(orderID: String) {
        self.api.movePoint(orderID: orderID) { result in
            switch result {
            case .success(let result):
                print(result ?? "")
                self.movePointResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                print("error", error.message)
            }
        }
    }
    
    func dropoffOrder(orderID: String) {
        self.api.dropoffOrder(orderID: orderID) { result in
            switch result {
            case .success(let result):
                print(result ?? "")
                self.dropoffResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                print("error", error.message)
            }
        }
    }
    
    func startUnload(orderID: String) {
        self.api.startUnload(orderID: orderID) { result in
            switch result {
            case .success(let result):
                print(result ?? "")
                self.startUnloadResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                print("error", error.message)
            }
        }
    }
    
    func endUnload(orderID: String) {
        self.api.endUnload(orderID: orderID) { result in
            switch result {
            case .success(let result):
                print(result ?? "")
                self.endUnloadResult.value = result
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
                print(result ?? "")
                self.endOrderResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func confirmPaymentCash(orderID: String, amount: String) {
        self.api.confirmPaymentCash(orderID: orderID, amount: amount) { result in
            
            switch result {
            case .success(let result):
                print(result ?? "")
                self.confirmPaymentCashResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func rateOrder(orderID: String, rate: String) {
        self.api.rateOrder(orderID: orderID, rate: rate) { result in
            
            switch result {
            case .success(let result):
                print(result ?? "")
                self.rateOrderResult.value = result
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
                print(result ?? "")
                self.cancelResult.value = result
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
                                
                                // Remove existing polyline
                                self.currentPolyline?.map = nil
                                
                                // Create a new polyline
                                let newPolyline = GMSPolyline(path: path)
                                newPolyline.strokeWidth = 4.0
                                newPolyline.strokeColor = .blue
                                newPolyline.map = mapView
                                
                                // Update current polyline
                                self.currentPolyline = newPolyline
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
