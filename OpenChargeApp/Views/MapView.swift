//
//  MapView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 09/03/2022.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    @Binding var directions: [String]
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var chargerViewModel: ChargerViewModel
    
    let mapView = MKMapView()

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }

    func makeUIView(context: Context) -> MKMapView {
        
        setupMapView(context: context)
        
        let sourcePlaceMark = setupSource()
        let destinationPlaceMark = setupDestination()
        let request = setupRequest(source: sourcePlaceMark, destination: destinationPlaceMark)
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotations([sourcePlaceMark, destinationPlaceMark])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true)
            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        
        return mapView
    }
    
    private func setupMapView(context: Context) {
        mapView.delegate = context.coordinator
        
        let region = locationViewModel.region
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    private func setupSource() -> MKPlacemark {
        let source = MKPointAnnotation()
        source.coordinate = locationViewModel.region.center
        source.title = "Your position"
        let sourcePlaceMark = MKPlacemark(coordinate: source.coordinate)
        return sourcePlaceMark
    }
    
    private func setupDestination() -> MKPlacemark {
        let destination = MKPointAnnotation()
        destination.coordinate = chargerViewModel.coordinate()
        destination.title = chargerViewModel.addressTitle()
        let destinationPlaceMark = MKPlacemark(coordinate: destination.coordinate)
        return destinationPlaceMark
    }
    
    private func setupRequest(source: MKPlacemark, destination: MKPlacemark) -> MKDirections.Request {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        
        request.transportType = .automobile
        return request
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemGreen
            renderer.lineWidth = 5
            return renderer
        }
    }
}
