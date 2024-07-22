//
//  ViewModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation
import CoreLocation

struct GeocodingResult: Codable {
    let results: [Result]
    let status: String

    struct Result: Codable {
        let addressComponents: [AddressComponent]

        enum CodingKeys: String, CodingKey {
            case addressComponents = "address_components"
        }
    }

    struct AddressComponent: Codable {
        let longName: String
        let shortName: String
        let types: [String]

        enum CodingKeys: String, CodingKey {
            case longName = "long_name"
            case shortName = "short_name"
            case types
        }
    }
}

protocol HomeViewModelProtocol {
    
    func getCaptainStatus(captainID: String)
    func getCaptainDetails()
    func isCaptainOnOrder()
    func getOrdersDetails(orderIDs: [String])
    func acceptOrder(orderID: String, captainLat: String, captainLng: String)
    func rejectOrder(orderID: String)
    func setOrderPrice(orderID: String, price: String)
    
    var captainStatus:Observable<Bool?> { get set }
    var captainDetailsResult: Observable<RegisterModel?> { get set }
    var captainOnOrderResult: Observable<CaptainOnOrderModel?> { get set }
    var orderDetailsResult:Observable<OrdersDetailsModel?> { get set }
    var acceptResult:Observable<Model?> { get set }
    var rejectResult:Observable<Model?> { get set }
    var assignOrder: Observable<[Int]?> {get set}
    var currentOrder: Observable<Int?> {get set}
    var ordersWithPrice: Observable<[Int: String]> {get set}
    func updateAvailability(lat: String, lng: String)
    var updateAvailabilityResult:Observable<UpdateAvailabilityModel?> { get set }
    var orderPriceResult:Observable<(Model?, Int?)?> { get set }
    var errorMessage:Observable<String?> { get set }
    
}

class HomeViewModel: HomeViewModelProtocol {
    
    var captainStatus: Observable<Bool?> = Observable(nil)
    var captainDetailsResult: Observable<RegisterModel?>  = Observable(nil)
    var captainOnOrderResult: Observable<CaptainOnOrderModel?>  = Observable(nil)
    var orderDetailsResult: Observable<OrdersDetailsModel?>  = Observable(nil)
    var acceptResult: Observable<Model?>  = Observable(nil)
    var rejectResult: Observable<Model?>  = Observable(nil)
    var assignOrder: Observable<[Int]?> = Observable(nil)
    var currentOrder: Observable<Int?> = Observable(nil)
    var ordersWithPrice: Observable<[Int: String]> = Observable([:])
    var updateAvailabilityResult: Observable<UpdateAvailabilityModel?>  = Observable(nil)
    var orderPriceResult: Observable<(Model?, Int?)?> = Observable((nil, nil))
    var errorMessage: Observable<String?> = Observable(nil)
    
    var api: HomeApiProtocol
    
    init(api: HomeApi) {
        self.api = api
    }
    
    func getCaptainDetails() {
        self.api.getCaptainDetails { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.captainDetailsResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)
                
            }
        }
    }
    
    func isCaptainOnOrder() {
        self.api.isCaptainOnOrder { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.captainOnOrderResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)
                
            }
        }
    }
    
    func getOrdersDetails(orderIDs: [String]) {
        print("Received orderIDs: \(orderIDs)")
        self.api.getOrdersDetails(orderIDs: orderIDs) { result in
            switch result {
            case .success(let result):
                print(result)
                self.orderDetailsResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)
                
            }
        }
    }
    
    func updateAvailability(lat: String, lng: String) {
        self.api.updateAvailability(lat: lat, lng: lng) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.updateAvailabilityResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)
                
            }
        }
    }
    
    func acceptOrder(orderID: String, captainLat: String, captainLng: String) {
        self.api.acceptOrder(orderID: orderID, captainLat: captainLat, captainLng: captainLng) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.acceptResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)
                
            }
        }
    }
    
    func rejectOrder(orderID: String) {
        self.api.rejectOrder(orderID: orderID) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.rejectResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)
                
            }
        }
    }
    
    func setOrderPrice(orderID: String, price: String) {
        self.api.setOrderPrice(orderID: orderID, price: price) { result in
            switch result {
            case .success(let result):
                print(result)
                self.orderPriceResult.value?.0 = result
                self.orderPriceResult.value?.1 = Int(orderID)
            case .failure(let error):
                self.errorMessage.value = error.message
                print("error", error.message)
            }
        }
    }
    
    func getCaptainStatus(captainID: String) {
        FirebaseManager.shared.getCaptainStatus(captainId: captainID) { isOnline in
            guard let isOnline = isOnline else {
                return
            }
            self.captainStatus.value = isOnline
            print("is Online: \(isOnline)")
        }
    }
    
    func getCaptainPriceForOrders(orderIDs: [Int]) {
        FirebaseManager.shared.getCaptainPriceForOrders(orderIDs: orderIDs) { ordersWithPrice in
            self.ordersWithPrice.value = ordersWithPrice
        }
    }
    
    func observeOrders(captainId: String) {
        removeOrdersObserver()
        FirebaseManager.shared.observeNewOrdersAddedToCaptain(captainId: captainId) { assignOrder in
            guard let assignOrder = assignOrder else {
                return
            }
            self.assignOrder.value = assignOrder
            print("New Orders: \(assignOrder)")
        }
    }
    
    func observeCurrentOrder(captainId: String) {
        FirebaseManager.shared.observeCurrentOrder(captainId: captainId) { currentOrder in
            guard let currentOrder = currentOrder else {
                return
            }
            self.currentOrder.value = currentOrder
        }
    }
    
    func removeOrdersObserver() {
        FirebaseManager.shared.removeObserverForCaptain(captainId: String(UserInfo.shared.get_ID()))
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coordinate.latitude),\(coordinate.longitude)&key=AIzaSyB9Gu55XnI_UEP_hnW5GKVtWiAt-nxxxeU"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let geocodingResult = try JSONDecoder().decode(GeocodingResult.self, from: data)
                if let result = geocodingResult.results.first {
                    for component in result.addressComponents {
                        if component.types.contains("administrative_area_level_1") {
                            print(component.longName)
                            completion(component.longName)
                            return
                        }
                    }
                }
                completion(nil)
            } catch {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func areLocationsInSameGovernorate(orderID: Int, location1: CLLocation, location2: CLLocation, completion: @escaping (Bool, Int) -> Void) {
        let group = DispatchGroup()
        var governorate1: String?
        var governorate2: String?
        
        group.enter()
        reverseGeocode(coordinate: location1.coordinate) { governorate in
            governorate1 = governorate
            group.leave()
        }
        
        group.enter()
        reverseGeocode(coordinate: location2.coordinate) { governorate in
            governorate2 = governorate
            group.leave()
        }
        
        group.notify(queue: .main) {
            //print(governorate1)
            //print(governorate2)
            if let governorate1 = governorate1, let governorate2 = governorate2 {
                completion(governorate1 == governorate2, orderID)
            } else {
                completion(false, orderID)
            }
        }
    }
    
}
