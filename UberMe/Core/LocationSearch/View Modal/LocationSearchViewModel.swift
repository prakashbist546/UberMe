//
//  LocationSearchViewModel.swift
//  UberMe
//
//  Created by Prakash Bist on 2023/08/07.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropTime: String?
    @Published var tripDistance: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: location search failed with error: \(error.localizedDescription)")
                return
            }
            
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideType ) -> Double {
        guard let userCoordinate = self.userLocation else { return 0.0 }
        guard let destCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
        
        let startLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let destLocation = CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude)
        
        let tripDistance = startLocation.distance(from: destLocation)
        return type.computePrice(for: tripDistance)
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error = error {
                print("DEBUG: Failed to get directions with error: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else { return }
            self.configureTripTimes(with: route.expectedTravelTime)
            self.tripDistance = String(Double(Int(route.distance)/10)/100)

            completion(route)
        }
    }
    
    func configureTripTimes(with expectedTripTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickupTime = formatter.string(from: Date())
        
        dropTime = formatter.string(from: Date() + expectedTripTime)
    }
}

// MARK: - MKLocalSearchCompleterDelegate -

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
