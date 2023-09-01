//
//  UberMapViewRepresentable.swift
//  UberMe
//
//  Created by Prakash Bist on 2023/08/07.
//

import SwiftUI
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable {
    
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    @Binding var mapState: MapViewState
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapView()
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let selectedLocationCoordinate = locationViewModel.selectedUberLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: selectedLocationCoordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: selectedLocationCoordinate)
            }
        case .lineAdded:
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currenRegion: MKCoordinateRegion?
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
                self.showLocation()
            }
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.currenRegion = region
            let coordinateRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                                                       latitudinalMeters: .greatestFiniteMagnitude,
                                                       longitudinalMeters: .greatestFiniteMagnitude)

            let boundary = MKMapView.CameraBoundary(coordinateRegion: coordinateRegion)

            parent.mapView.setCameraBoundary(boundary, animated: false)

        }
        
        func showLocation() {
            if let userLocation = userLocationCoordinate {
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                parent.mapView.setRegion(region, animated: true)
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .orange
            polyline.lineWidth = 6
            
            return polyline
        }
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.parent.mapView.addAnnotation(annotation)
            self.parent.mapView.selectAnnotation(annotation, animated: true)
            
        }
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .lineAdded
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func clearMapView() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currenRegion = currenRegion {
                parent.mapView.setRegion(currenRegion, animated: true)
            }
        }
    }
}
